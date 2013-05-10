unit glRender;

interface
uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,dglopengl;

type

GRender = object
private
   start, stop, elapsed : cardinal;
  procedure GoToFullScreen(pWidth, pHeight, pBPP, pFrequency : Word);

public
    RC        : HGLRC;
    DC        : HDC;
    ShowFPS   : Boolean;
    FontBase  : GLUInt;
    StartTick : Cardinal;
    Frames    : Integer;
    FPS       : Single;
    _Handle:integer;
procedure init(handle:integer);
procedure Close;


procedure PrintText(pX,pY : Integer; const pText : String);
procedure BuildFont(pFontName : String);

procedure Clean(r,g,b:single);



procedure BeginScene;
procedure EndScene;

procedure Begin2D(w,h:integer);
procedure End2D;


end;


implementation
procedure GRender.Close;
begin
DeactivateRenderingContext;
wglDeleteContext(RC);
ReleaseDC(_Handle, DC);
ChangeDisplaySettings(devmode(nil^), 0);
end;

procedure GRender.BeginScene;
begin
wglMakeCurrent(dc, rc);
start := GetTickCount;
end;
procedure GRender.EndScene;
begin

SwapBuffers(DC);
wglMakeCurrent(0,0);
inc(Frames);
if GetTickCount - StartTick >= 500 then
 begin
 FPS       := Frames/(GetTickCount-StartTick)*1000;
 Frames    := 0;
 StartTick := GetTickCount
 end;

   stop := GetTickCount;
   elapsed := stop - start; //milliseconds


end;



procedure GRender.Clean;
begin
glClearColor(r,g,b,1);
glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
end;


procedure GRender.init(handle:integer);
begin
InitOpenGL;
_Handle:=handle;
DC := GetDC(Handle);
RC := CreateRenderingContext(DC, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
ActivateRenderingContext(DC, RC);
glEnable(GL_DEPTH_TEST);
glDepthFunc(GL_LESS);
glClearColor(0,0,0,0);
BuildFont('MS Sans Serif');
StartTick := GetTickCount;


    glEnable (GL_DEPTH_TEST);
    glDisable (GL_CULL_FACE);


    glViewport(0, 0, 800, 640);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0,800,640,0, -100,100);
    glMatrixMode(GL_MODELVIEW);


end;


procedure GRender.GoToFullScreen(pWidth, pHeight, pBPP, pFrequency : Word);
var
 dmScreenSettings : DevMode;
begin
ZeroMemory(@dmScreenSettings, SizeOf(dmScreenSettings));
with dmScreenSettings do
 begin
 dmSize              := SizeOf(dmScreenSettings);
 dmPelsWidth         := pWidth;
 dmPelsHeight        := pHeight;
 dmBitsPerPel        := pBPP;
 dmDisplayFrequency  := pFrequency;
 dmFields            := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL or DM_DISPLAYFREQUENCY;
 end;
if (ChangeDisplaySettings(dmScreenSettings, CDS_FULLSCREEN) = DISP_CHANGE_FAILED) then
 begin
 MessageBox(0, 'ChangeDisplaySettings!', 'Error', MB_OK or MB_ICONERROR);
 exit
 end;
end;


procedure GRender.BuildFont(pFontName : String);
var
 Font : HFONT;
begin
FontBase := glGenLists(96);
Font     := CreateFont(16, 0, 0, 0, FW_MEDIUM, 0, 0, 0, ANSI_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY, FF_DONTCARE or DEFAULT_PITCH, PChar(pFontName));
SelectObject(DC, Font);
wglUseFontBitmaps(DC, 0, 256, FontBase);
DeleteObject(Font)
end;



procedure GRender.PrintText(pX,pY : Integer; const pText : String);
begin
if (pText = '') then   exit;
glPushAttrib(GL_LIST_BIT);
 glRasterPos2i(pX, pY);
 glListBase(FontBase);
 glCallLists(Length(pText), GL_UNSIGNED_BYTE, PChar(pText));
glPopAttrib;
end;


procedure GRender.Begin2D(w,h:integer);
begin
glDisable(GL_DEPTH_TEST);
glDisable(GL_TEXTURE_2D);
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
glOrtho(0,w,h,0, -100,100);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
end;
procedure GRender.End2D;
begin
PrintText(5,15, FloatToStr(FPS)+' fps');
glEnable(GL_DEPTH_TEST);
glEnable(GL_TEXTURE_2D);
end;






end.
