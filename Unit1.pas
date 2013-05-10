unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ThdTimer,dglopengl,hge,HGEClasses, ComCtrls,
  Menus, StdCtrls,global,Unit_edit,graphicex,Unit_objects, JvBaseDlg, JvImageDlg, XPMan, ExtDlgs;

type
  TForm1 = class(TForm)
    timer: TThreadedTimer;
    Panel1: TPanel;
    timer2: TThreadedTimer;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    ExportXML1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    World1: TMenuItem;
    Grid1: TMenuItem;
    New1: TMenuItem;
    N3: TMenuItem;
    XPManifest1: TXPManifest;
    OpenPictureDialog1: TOpenPictureDialog;
    N4: TMenuItem;
    EditMode1: TMenuItem;
    N5: TMenuItem;
    New2: TMenuItem;
    Objects1: TMenuItem;
    Edit1: TMenuItem;
    N6: TMenuItem;
    Add1: TMenuItem;
    Images1: TMenuItem;
    Add2: TMenuItem;
    iles1: TMenuItem;
    LoadLayer1: TMenuItem;
    Editor1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure timerTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Add1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure EditMode1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Edit1Click(Sender: TObject);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Add2Click(Sender: TObject);
    procedure Editor1Click(Sender: TObject);
    procedure LoadLayer1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure ExportXML1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

//  RC2        : HGLRC;
//  DC2        : HDC;

    RC1        : HGLRC;
    DC1        : HDC;



implementation

uses Unit_grid, Unit_Images, Unit_tiler, Unit_tilemap;

{$R *.dfm}

 {
RC = wglCreateContext( DC1 );
wglMakeCurrent( DC1, RC );
wglMakeCurrent( DC2, RC );
}



procedure TForm1.FormCreate(Sender: TObject);
begin
InitOpenGL;



   Defaults;

DC1 := GetDC(panel1.Handle);
RC1 := CreateRenderingContext(DC1, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
ActivateRenderingContext(DC1, RC1);
glenabled:=true;
{
DC2 := GetDC(panel2.Handle);
RC2 := CreateRenderingContext(DC2, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
ActivateRenderingContext(DC2, RC2);
}
  System_Initiate;
  FScreenWidth:=panel1.Width;
  FScreenHeight:=panel1.Height;
  glViewPort(0,0,panel1.Width,panel1.Height);
  SetTransform(1,0,0,0);

   wordlw:=2000;
   worldh:=panel1.Height;
   worldx:=0;//wordlw/2;
   worldy:=0;//worldh/2;



      level:=Tlevel.Create;

timer.Enabled:=true;
//timer2.Enabled:=true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
System_End;
timer.Enabled:=false;
timer2.Enabled:=false;
    level.Destroy;

end;

procedure TForm1.timerTimer(Sender: TObject);
var
  x,y:integer;
  finalx,finaly:integer;
begin
  FScreenWidth:=panel1.Width;
  FScreenHeight:=panel1.Height;

  wglMakeCurrent(dc1, rc1);

    glClearColor(0,0,0.4,1);
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);


  //worldx := -mousex+120 div 2-wordlw div 2;

//  Engine.Y := -Y+Engine.Height div 2-Height div 2;

    if worldx<0 then worldx:=0;
    if worldy<0 then worldy:=0;

    if worldx>wordlw then worldx:=wordlw;
    if worldy>worldh then worldy:=worldh;





    posx_global:=worldx+mousex/worldscale;
    posy_global:=worldy+mousey/worldscale;

    posx_grid:=worldx+mousex / gridw / worldscale;
    posy_grid:=worldy+mousey / gridh / worldscale;

    tilex_grid:=mousex / gridw / worldscale;
    tiley_grid:=mousey / gridh / worldscale;


  //  objx:=posx_global ;
  //  objy:=posy_global ;

   //  objx:=(worldx+(mousex / gridw) / worldscale);
   //  objy:=(worldy+(mousey / gridh) / worldscale);

   if  snap_objects then
   begin

     finalx:=(trunc(posx_global) div gridw) ;
     finaly:=(trunc(posy_global) div gridh) ;

     objx:=finalx * gridw;
     objy:=finaly * gridh;
   end else
   begin
     objx:=posx_global;
     objy:=posy_global;
   end;



       StatusBar1.Panels.Items[0].Text:=
    'Grid X:'+inttostr(trunc(posx_grid))+
    '--Grid Y:'+inttostr(trunc(posy_grid));


     StatusBar1.Panels.Items[1].Text:=
    'Global X:'+inttostr(trunc(posx_global))+
    '--Global Y:'+inttostr(trunc(posy_global));

         StatusBar1.Panels.Items[2].Text:=
     'Obj X:'+inttostr (trunc(objx))+
    '--Obj Y:'+inttostr(trunc(objy));


    if (objx<0) then objx:=0;
    if (objx>wordlw-gridw) then objx:=wordlw-gridw;

    if (objy<0) then objy:=0;
    if (objy>worldh-gridh) then objy:=worldh-gridh;



  //   scroll_wordl(FScreenWidth div 2,FScreenHeight div 2,FScreenWidth,FScreenHeight,keymovex,keymovey);


  SetTransform(worldscale,worldx,worldy,0);
//    SetTransform(worldscale,0,0,0);


   // SetTransform(1,0,0,0);
   //Setup2DScene(panel1.Width,panel1.Height,-1000,1000);

    Gfx_BeginBatch;







 case form5.RadioGroup2.ItemIndex of
 0://objects
 begin


case Unit_objects.Form4.RadioGroup1.ItemIndex of
0:begin
if (assigned( globalimage)) and (objects_mode) then
begin
  DrawEx(globalimage,0,objx-(globalimage.PatternWidth/2),objy-(globalimage.PatternHeight/2),0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);
//  DrawEx(globalimage,0,posx_grid,posy_grid,0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);
//  DrawEx(globalimage,0,posx_global,posy_global,0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);


end;
end;
1:begin
  if (assigned(select_obj)) then
begin
  select_obj.isselect:=false;
end;


select_obj:=level.Select(trunc(objx),trunc(objy));
if (assigned(select_obj)) then
begin
  select_obj.isselect:=true;
  if mousepress then
  begin
    select_obj.Active:=false;
    select_obj:=nil;
  end;
end;
end;
2:begin
end;
end;

end; // end objects
1:begin//paths

end;
2:begin//tiles

    if (assigned(tilemap)) then
    begin
     if (mousepress) then tilemap.SetTile(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),TileSelect);
    end;

end;
end;

    if (assigned(tilemap)) then
    begin
     if form5.CheckBox1.Checked then tilemap.Render;
    end;

       level.Render;

      
      for x:=0 to (wordlw div gridw) do
      begin
      Gfx_RenderLine(x*gridw,0,x*gridw,worldh,gridcolor);
      end;
     for y:=0 to (worldh div gridh)  do
     begin
      Gfx_RenderLine(0,y*gridh,wordlw,y*gridh,gridcolor);
     end;
     Gfx_RenderRect(-1,-1,wordlw-1,worldh-1,0,0,1);

      Gfx_RenderRect(objx,objy,gridw,gridh,1,0,1);
     // Gfx_RenderRect(posx_global,posy_global,gridw,gridh,1,0,1);





      Gfx_EndBatch;
     //   glBindTexture(GL_TEXTURE_2D, 0);
      
    SwapBuffers(DC1);
  //  wglMakeCurrent(0,0);
{
    wglMakeCurrent(dc2, rc2);

      glClearColor(0.4,0,0.4,1);
      glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);


    glLoadIdentity();
    glPushMatrix();
    glTranslatef (0.0, 0.0, 0.0);

    glcolor4f(1,0,0,1);
    glBegin (GL_TRIANGLES);
    glVertex3f (0.0, 0.0, 0.0);
    glVertex3f (0.0, 10.0, 0.0);
    glVertex3f (10.0, 10.0, 0.0);
    glEnd();

    glPopMatrix();

    SwapBuffers(DC2);
    wglMakeCurrent(0,0);
    }

    System_Loop;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
caption:=inttostr(key);


if key=38 then worldy:=worldy-gridh;
if key=40 then worldy:=worldy+gridh;

if key=37 then worldx:=worldx-gridw;
if key=39 then worldx:=worldx+gridw;


 case form5.RadioGroup2.ItemIndex of
 0://objects
 begin

 end;
 1://pchats
 begin

 end;
 2:  //tiles
 begin
    if (assigned(tilemap)) then
    begin

   if key=87 then
     tilemap.SetTileFlipY(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),true)
   else if key=83 then
        tilemap.SetTileFlipY(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),false);

   if key=65 then
     tilemap.SetTileFlipX(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),true)
   else if key=68 then
        tilemap.SetTileFlipX(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),false);

   end;
        
 end;


 end;

 {
if key=38 then keymovey:=keymovey-gridh;
if key=40 then keymovey:=keymovey+gridh;

if key=37 then keymovex:=keymovex-gridw;
if key=39 then keymovex:=keymovex+gridw;
  }
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
mousex:=x;
mousey:=y;
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
mousex:=x;
mousey:=y;
mousepress:=true;

 if Button=mbLeft then
   begin

if (assigned(select_obj)) then select_obj.isselect:=false;
 select_obj:=level.Select(trunc(objx),trunc(objy));
if (assigned(select_obj)) then select_obj.isselect:=true;
 end;

 if Button=mbRight then
   begin

   if (assigned(select_obj)) then
    begin
         select_obj.isselect:=true;
         select_obj.x:=objx+select_obj.PivotX;
         select_obj.y:=objy+select_obj.PivotY;
    end;

 end;



end;

procedure TForm1.Add1Click(Sender: TObject);
var
  png:TPNGGraphic;
  tga:TTargaGraphic;
  
  image:TGraphicExGraphic;
begin
form4.Button2Click(form4);
{
OpenPictureDialog1.InitialDir:= ExtractFilePath(ParamStr(0))+'Sprites';
if OpenPictureDialog1.Execute then
begin
  level.LoadImage(OpenPictureDialog1.FileName);
  Form4.JvThumbView1.AddFromFile(OpenPictureDialog1.FileName);
  Form4.JvThumbView1.Update;

  glBindTexture(GL_TEXTURE_2D, 0);
end;
 }
end;

procedure TForm1.Show1Click(Sender: TObject);
begin
//Unit_sprites.Form3.Show;
end;

procedure TForm1.EditMode1Click(Sender: TObject);
begin
Unit_edit.Form5.Show;
end;

procedure TForm1.Grid1Click(Sender: TObject);
begin
Unit_edit.Form5.Show;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
worldscale:=worldscale+(WheelDelta/1000);
if worldscale<0.1 then worldscale:=0.1;
if worldscale>2 then  worldscale:=2;

//caption:=floattostr(worldscale);


end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
Unit_objects.Form4.Show;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
  mousepress:=false;


  if (Button=mbLeft) then
  begin
case Unit_objects.Form4.RadioGroup1.ItemIndex of
0:begin

if (assigned( globalimage)) and (objects_mode) then
begin
if (assigned(select_obj)) then select_obj.isselect:=false;
select_obj:=level.CreateObj(globalimage,objx,objy,globalimage.name);
//select_obj:=level.CreateObj(globalimage,objx,objy,globalimage.name);
select_obj.isselect:=true;
end;
end;
end;

end;




end;

procedure TForm1.Add2Click(Sender: TObject);
begin
form3.show;
end;

procedure TForm1.Editor1Click(Sender: TObject);
begin
 form7.Show;
end;

procedure TForm1.LoadLayer1Click(Sender: TObject);
begin
form8.Show;
end;

procedure TForm1.Save1Click(Sender: TObject);
var
  path:string;
begin
  path:=ExtractFilePath(ParamStr(0))+'levels/level.txt';

Level.SaveToFile(path);
end;

procedure TForm1.Load1Click(Sender: TObject);
var
  path:string;
begin
  path:=ExtractFilePath(ParamStr(0))+'levels/level.txt';

Level.LoadFromFile(path);
end;

procedure TForm1.ExportXML1Click(Sender: TObject);
var
  path:string;
begin
  path:=ExtractFilePath(ParamStr(0))+'levels/level.xml';

Level.SaveXML(path);
end;

end.
 