unit HGE;




interface

uses
 windows,math, dglopengl,sysutils,GlDraw,pixmap;

const
GL_CLAMP_TO_EDGE = $812F;

const
  HGE_VERSION = $200;
 WND_TITLE = 'Android  -  Djoker';


 type
 TDIKeyBuf = array[0..255] of Byte;



const
  M_PI   = 3.14159265358979323846;
  M_PI_2 = 1.57079632679489661923;
  M_PI_4 = 0.785398163397448309616;
  M_1_PI = 0.318309886183790671538;
  M_2_PI = 0.636619772367581343076;


CFushia=4294443256;
CBlack=4278452224;

const
  HGESLIDER_BAR         = 0;
  HGESLIDER_BARRELATIVE = 1;
  HGESLIDER_SLIDER      = 2;
  
function ARGB(const A, R, G, B: Byte): Longword;
function GetA(const Color: Longword): Byte;
function GetR(const Color: Longword): Byte;
function GetG(const Color: Longword): Byte;
function GetB(const Color: Longword): Byte;
function SetA(const Color: Longword; const A: Byte): Longword;
function SetR(const Color: Longword; const A: Byte): Longword;
function SetG(const Color: Longword; const A: Byte): Longword;
function SetB(const Color: Longword; const A: Byte): Longword;


const
  BLEND_COLORADD   = 1;
  BLEND_COLORMUL   = 0;
  BLEND_ALPHABLEND = 2;
  BLEND_ALPHAADD   = 0;
  BLEND_ZWRITE     = 4;
  BLEND_NOZWRITE   = 0;

  BLEND_DEFAULT     = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  BLEND_DEFAULT_Z   = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_ZWRITE;
  BLEND_ADD           = BLEND_COLORMUL or BLEND_ALPHAADD or BLEND_NOZWRITE;
  BLEND_SUB         = BLEND_COLORMUL or BLEND_ALPHAADD or BLEND_ZWRITE;



type
hVector=record
x,y:single;
end;
HColor=record
r,g,b,a:single;
end;
  THGEBoolState = (
    HGE_WINDOWED      = 12,   // bool    run in window?    (default: false)
    HGE_ZBUFFER       = 13,   // bool    use z-buffer?    (default: false)
    HGE_TEXTUREFILTER = 28   // bool    texture filtering?  (default: true)

  );

type
  THGEFuncState = (
    HGE_FRAMEFUNC      = 1,    // bool*()  frame function    (default: NULL) (you MUST set this)
    HGE_RENDERFUNC     = 2,    // bool*()  render function    (default: NULL)
    HGE_EXITFUNC       = 6    // bool*()  exit function    (default: NULL)
  );


type
  THGEIntState = (
    HGE_SCREENWIDTH    = 9,    // int    screen width    (default: 800)
    HGE_SCREENHEIGHT   = 10    // int    screen height    (default: 600)
  );



(*
** Callback protoype used by HGE
*)
type
  THGECallback = function: Boolean;

(*
** HGE_FPS system state special constants
*)
const
  HGEFPS_UNLIMITED =  0;
  HGEFPS_VSYNC     = -1;

(*
** HGE Primitive type constants
*)
const
  HGEPRIM_LINES    = 2;
  HGEPRIM_TRIPLES  = 3;
  HGEPRIM_QUADS    = 4;



  type



  TTexture = class
  private
    FName: string;
    FTextureWidth: Integer;
    FTextureHeight: Integer;
    FHandle: PPixmap;
    FOriginalWidth: Integer;
    FOriginalHeight: Integer;
    FId:GLuint;
    LinearInterpolating:boolean;
    Repeating:boolean;
     

  public
    PatternWidth,
    PatternHeight:integer;
    filename:string;

    { ITexture }
    function  GetName: string;
    procedure SetName(Value: string);
    procedure  Get_Pixel(x,y:integer;var Red, Green, Blue, Alpha: byte);
    procedure  Set_Pixel(x,y:integer;var Red, Green, Blue, Alpha: byte);
  public
    constructor Create(width,height:INTEGER; Red, Green, Blue, Alpha: byte;fill:boolean=TRUE);overload;
    constructor Create(rad:INTEGER; Red, Green, Blue, Alpha: byte;fill:boolean=TRUE);overload;

    constructor Create(fname:string);overload;
    constructor Create(data:pointer;size:integer);overload;
    destructor Destroy;
    function GetWidth(const Original: Boolean = true): Integer;
    function GetHeight(const Original: Boolean = true): Integer;
    procedure bind();
    function getId:gluint;
    property name:string read fname write fname;
  end;


  Xpoint=record
  x,y:single;
  end;

   TSpline=Object
  private
     mMidPoints: array of Xpoint;
     FPixelsPts: array of Xpoint;
     mCount:integer;
     procedure AddPixel( Point:Xpoint);

  public
  procedure EditPoint(index:integer; Point:Xpoint);overload;
  procedure EditPoint(index:integer; x,y:single);overload;

  procedure EditPixel(index:integer; Point:Xpoint);overload;
  procedure EditPixel(index:integer; x,y:single);overload;


  procedure AddControlPoint( Point:Xpoint);overload;
  procedure AddControlPoint( x,y:single);overload;

  procedure Render(x,y:single;color,controlColor:DWORD);

  function GetControlPoint(index:integer):Xpoint;

  procedure GeneratePixels;

    function GetPointsCount:integer;
  function GetPixel(index:integer):Xpoint;
  function GetPixelCount:integer;
	procedure PointOnCurve(var Point:Xpoint; t:single;p0,p1,p2,p3:Xpoint);

   procedure Clear;

  procedure SaveFile(fname:string);
  procedure LoadFile(fname:string);


  end;


(*
** HGE Vertex structure
*)
type
  THGEVertex = record
    X, Y: Single;   // screen position
    Z: Single;      // Z-buffer depth 0..1
    Col: Longword;  // color
    TX, TY: Single; // texture coordinates
  end;
  PHGEVertex = ^THGEVertex;
  THGEVertexArray = array [0..MaxInt div 32 - 1] of THGEVertex;
  PHGEVertexArray = ^THGEVertexArray;

  THGIndiceArray = array [0..MaxInt div 32 - 1] of integer;
  PHGEIndiceArray = ^THGIndiceArray;



(*
** HGE Quad structure
*)
type
  THGEQuad = record
    V: array [0..3] of THGEVertex;
    Tex: TTexture;
    Blend: Integer;
  end;
  PHGEQuad = ^THGEQuad;

type
  THGETriple = record
    V: array [0..2] of THGEVertex;
    Tex: TTexture;
    Blend: Integer;
  end;
  PHGETriple = ^THGETriple;


     function System_Initiate: Boolean;
     function System_Loop: Boolean;
     function System_End: Boolean;

    procedure System_Log(const S: String);

    function Input_MouseX:single;
    function Input_MouseY:single;
    function Input_MouseDown:boolean;
      function Input_KeyDown(key:integer):boolean;



    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;

    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;

    function Resource_Load(const Filename: String;const Size: pLongword;var data:pointer):boolean ;

    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single;const Color: Longword = $FFFFFFFF; const Z: Single = 0.0);
    procedure Gfx_RenderRect( x,  y,  width,  height:single;r,g,b:single;depth:single=0.0);overload;
    procedure Gfx_RenderRect( x,  y,  width,  height:single;colord:cardinal;depth:single);overload;

    procedure Gfx_BeginBatch;
    procedure Gfx_EndBatch;
    procedure Gfx_RenderQuad( Quad: THGEQuad);
    procedure Gfx_RenderQuadUp( Quad: THGEQuad);




procedure DrawImage(texture:TTexture;x,y,w,h:integer;z:single;Color:dword;blend:integer);overload;
procedure DrawImage(texture:TTexture;x,y,z,angle:single;Color:dword;blend:integer);overload;
procedure DrawImage(texture:TTexture;x,y,z,w,h:single;Color:dword;blend:integer);overload;
procedure DrawImage(texture:TTexture;x,y,z,w,h,angle:single;Color:dword;blend:integer);overload;
procedure DrawImage(texture:TTexture;x,y,z,srcx,srcy,srcw,srch:single;Color:dword;blend:integer);overload;




    function Texture_Load(const Filename: String): TTexture; overload;
    function Texture_Load(data:pointer;size:integer): TTexture; overload;
    function Texture_GetWidth(const Tex: TTexture; const Original: Boolean = true): Integer;
    function Texture_GetHeight(const Tex: TTexture; const Original: Boolean = true): Integer;
    procedure Gfx_SetBlendMode(const Blend: Integer);


    var

    // Timer

    FPSCount,lastFPSCount : Integer;            // Counter for FPS
     _ms_prev,_last,_time,_gameTime:integer;
     passedTime, elapsed,rate,maxElapsed:single;




function RGBA(r,g,b,a: single): integer;

function  CreateHGEVertex(sx, sy,sz:single; color:DWORD; tu ,tv:single):THGEVertex;

function COLOR_ARGB(a,r,g,b: single): DWORD;
procedure COLOR_UnRGB(color : LongWord; var R, G, B : Byte);
procedure COLOR_UnRGBAF(color : LongWord; var cR, cG, cB,cA : single);
procedure COLOR_UnRGBA(color : LongWord; var R, G, B,A : Byte);




const

  K_LBUTTON    = $01;
  K_RBUTTON    = $02;
  K_MBUTTON    = $04;

  K_ESCAPE      = $1B;
  K_BACKSPACE  = $08;
  K_TAB        = $09;
  K_ENTER      = $0D;
  K_SPACE      = $20;

  K_SHIFT      = $10;
  K_CTRL        = $11;
  K_ALT        = $12;

  K_LWIN        = $5B;
  K_RWIN        = $5C;
  K_APPS        = $5D;

  K_PAUSE      = $13;
  K_CAPSLOCK    = $14;
  K_NUMLOCK    = $90;
  K_SCROLLLOCK = $91;

  K_PGUP        = $21;
  K_PGDN        = $22;
  K_HOME        = $24;
  K_END        = $23;
  K_INSERT      = $2D;
  K_DELETE      = $2E;

  K_LEFT        = $25;
  K_UP          = $26;
  K_RIGHT      = $27;
  K_DOWN        = $28;

  K_0          = $30;
  K_1          = $31;
  K_2          = $32;
  K_3          = $33;
  K_4          = $34;
  K_5          = $35;
  K_6          = $36;
  K_7          = $37;
  K_8          = $38;
  K_9          = $39;

  K_A          = 97;
  K_B          = $42;
  K_C          = $43;
  K_D          = 100;
  K_E          = $45;
  K_F          = $46;
  K_G          = $47;
  K_H          = $48;
  K_I          = $49;
  K_J          = $4A;
  K_K          = $4B;
  K_L          = $4C;
  K_M          = $4D;
  K_N          = $4E;
  K_O          = $4F;
  K_P          = $50;
  K_Q          = $51;
  K_R          = $52;
  K_S          = 115;
  K_T          = $54;
  K_U          = $55;
  K_V          = $56;
  K_W          = 119;
  K_X          = $58;
  K_Y          = $59;
  K_Z          = $5A;

  K_GRAVE      = $C0;
  K_MINUS      = $BD;
  K_EQUALS      = $BB;
  K_BACKSLASH  = $DC;
  K_LBRACKET    = $DB;
  K_RBRACKET    = $DD;
  K_SEMICOLON  = $BA;
  K_APOSTROPHE = $DE;
  K_COMMA      = $BC;
  K_PERIOD      = $BE;
  K_SLASH      = $BF;

  K_NUMPAD0    = $60;
  K_NUMPAD1    = $61;
  K_NUMPAD2    = $62;
  K_NUMPAD3    = $63;
  K_NUMPAD4    = $64;
  K_NUMPAD5    = $65;
  K_NUMPAD6    = $66;
  K_NUMPAD7    = $67;
  K_NUMPAD8    = $68;
  K_NUMPAD9    = $69;

  K_MULTIPLY    = $6A;
  K_DIVIDE      = $6F;
  K_ADD        = $6B;
  K_SUBTRACT    = $6D;
  K_DECIMAL    = $6E;

  K_F1          = $70;
  K_F2          = $71;
  K_F3          = $72;
  K_F4          = $73;
  K_F5          = $74;
  K_F6          = $75;
  K_F7          = $76;
  K_F8          = $77;
  K_F9          = $78;
  K_F10        = $79;
  K_F11        = $7A;
  K_F12        = $7B;


var
mousex:single;
mousey:single;
MouseButton:integer;
lastkey:integer=0;
keys : Array[0..255] of Boolean;

implementation

uses vertexbuffer,SpriteBatch;

var
    FVertArray: PHGEVertexArray;
    FPrim: Integer;
    FCurPrimType: Integer;
    FCurBlendMode: Integer;
    FCurTexture: TTexture;
    FIndices:array of word;

procedure CopyVertices(pVertices: PByte; numVertices: Integer);
var
  pVB: pointer;
begin
  Move(pVertices^, pVB^, Sizeof( THGEVertex) * numVertices);
end;



 function Input_MouseDown:boolean;
 begin
 result:=boolean(MouseButton);
 end;

  function Input_KeyDown(key:integer):boolean;
 begin
  result:=keys[key];
 end;


 function Input_MouseX:single;
 begin
 result:=mousex;
 end;
 function Input_MouseY:single;
 begin
 result:=mousey;
 end;


function  CreateHGEVertex(sx, sy,sz:single; color:DWORD; tu ,tv:single):THGEVertex;
begin
result.x:=sx;
result.y:=sy;
result.z:=sz;
result.col:=color;
result.tx:=tu;
result.ty:=tv;
end;





const
  CRLF = #13#10;




function ARGB(const A, R, G, B: Byte): Longword;
begin
  Result := (A shl 24) or (R shl 16) or (G shl 8) or B;
end;

function GetA(const Color: Longword): Byte;
begin
  Result := Color shr 24;
end;

function GetR(const Color: Longword): Byte;
begin
  Result := (Color shr 16) and $FF;
end;

function GetG(const Color: Longword): Byte;
begin
  Result := (Color shr 8) and $FF;
end;

function GetB(const Color: Longword): Byte;
begin
  Result := Color and $FF;
end;

function SetA(const Color: Longword; const A: Byte): Longword;
begin
  Result := (Color and $00FFFFFF) or (A shl 24);
end;

function SetR(const Color: Longword; const A: Byte): Longword;
begin
  Result := (Color and $FF00FFFF) or (A shl 16);
end;

function SetG(const Color: Longword; const A: Byte): Longword;
begin
  Result := (Color and $FFFF00FF) or (A shl 8);
end;

function SetB(const Color: Longword; const A: Byte): Longword; 
begin
  Result := (Color and $FFFFFF00) or A;
end;

function RGBA(r,g,b,a: single): integer;
begin
Result :=
    (round(a * 255) shl 24) or
    (round(r * 255) shl 16) or
    (round(g * 255) shl 8) or
    (round(b * 255));


end;

function Color_RGB(R, G, B : Byte):integer;
begin
Result :=
    (r shl 16) or
    (g shl 8) or
    (b);

end;
procedure COLOR_UnRGBA(color : LongWord; var R, G, B,A : Byte);
begin
           A:= color shr 24;
           R:= color shr 16;
           G:= color shr 8;
           B:= color;
end;

procedure COLOR_UnRGBAF(color : LongWord; var cR, cG, cB,cA : single);
var
r,g,b,a:byte;

begin
           A:= color shr 24;
           R:= color shr 16;
           G:= color shr 8;
           B:= color;

           cr:=r/255.0;
           cg:=g/255.0;
           cb:=b/255.0;
           ca:=a/255.0;

end;

procedure COLOR_UnRGB(color : LongWord; var R, G, B : Byte);
begin
           R:= color shr 16;
           G:= color shr 8;
           B:= color;
end;
function COLOR_ARGB(a,r,g,b: single): DWORD;
begin
Result :=
    (round(a * 255) shl 24) or
    (round(r * 255) shl 16) or
    (round(g * 255) shl 8) or
    (round(b * 255));
end;

(****************************************************************************
 * HGE_Impl.h
 ****************************************************************************)

{-$DEFINE DEMO}

const
  VERTEX_BUFFER_SIZE = 1000;





//implementation

{ TTexture }

function CreateGlTexture(Width, Height:integer; alpha : boolean; pData : Pointer;LinearInterpolating,Repeating:BOOLEAN) : GLuint;
var
  Texture : GLuint;
begin
  glGenTextures(1, @Texture);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, Texture);

   if LinearInterpolating then begin
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  end else begin
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
  end;
  if Repeating then begin
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
  end else begin
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
  end;


 if alpha then	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBa, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData) else
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, Width, Height, 0, GL_RGB, GL_UNSIGNED_BYTE, pData);
result:=texture;
end;



 function nextPowerOfTwo(Size : Word) : Word;
 begin
  if Size> 4096 then result:=4096;
  if Size<=4096 then result:=4096;
  if Size<=2048 then result:=2048;
  if Size<=1024 then result:=1024;
  if Size<=512  then result:=512;
  if Size<=256  then result:=256;
  if Size<=128  then result:=128;
  if Size<=64   then result:=64;
  if Size<=32   then result:=32;
  if Size<=16   then result:=16;
  if Size<=8    then result:=8;
  if Size<=4    then result:=4;
  if Size<=2    then result:=2;
 end;

 function isPowerOfTwo(Size : Word) : boolean;
 begin
  result:= (Size=2) or (Size=4) or (Size=8) or (Size=16) or (Size=32) or (Size=64) or (Size=128) or
  (Size=256) or (Size=512) or (Size=1024) or (Size=2048) or (Size=4096);
 end;

constructor TTexture.Create(rad:INTEGER; Red, Green, Blue, Alpha: byte;fill:boolean=TRUE);
var
width,height:integer;
begin
LinearInterpolating:=false;
Repeating:=true;
FHandle:=nil;
FId:=0;

width:=nextPowerOfTwo(rad * 2);
height:=nextPowerOfTwo(rad * 2);


FOriginalWidth:=width;
FOriginalHeight:=height;
PatternWidth:=FOriginalWidth;
PatternHeight:=FOriginalHeight;



FHandle:=pixmap_new(width,height,4);
if fill then pixmap_fill_circle(FHandle,width div 2,height div 2, rad,ARGB(red,green,blue,alpha)) else
pixmap_draw_circle(FHandle,width div 2,height div 2, rad,ARGB(red,green,blue,alpha));
//if fill then pixmap_fill_circle(FHandle,0,0, rad,ARGB(red,green,blue,alpha)) else
//pixmap_draw_circle(FHandle,0,0, rad,ARGB(red,green,blue,alpha));

FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;


if FHandle.format>=4 then
fId:=CreateGlTexture(FHandle.width,FHandle.height,TRUE,FHandle.pixels,LinearInterpolating,Repeating) else
fId:=CreateGlTexture(FHandle.width,FHandle.height,false,FHandle.pixels,LinearInterpolating,Repeating);


end;

constructor TTexture.Create(width,height:INTEGER; Red, Green, Blue, Alpha: byte;fill:boolean);
begin
LinearInterpolating:=false;
Repeating:=true;
FHandle:=nil;
FId:=0;

FOriginalWidth:=width;
FOriginalHeight:=height;
PatternWidth:=FOriginalWidth;
PatternHeight:=FOriginalHeight;

width:=nextPowerOfTwo(width);
height:=nextPowerOfTwo(height);


FHandle:=pixmap_new(width,height,4);
if fill then pixmap_fill_rect(FHandle,0,0,width,height ,ARGB(red,green,blue,alpha)) else
pixmap_draw_rect(FHandle,0,0,width,height,ARGB(red,green,blue,alpha));

FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;


if FHandle.format>=4 then
fId:=CreateGlTexture(FHandle.width,FHandle.height,TRUE,FHandle.pixels,LinearInterpolating,Repeating) else
fId:=CreateGlTexture(FHandle.width,FHandle.height,false,FHandle.pixels,LinearInterpolating,Repeating);



end;

constructor TTexture.Create(data:pointer;size:integer);
begin
LinearInterpolating:=true;
Repeating:=true;
FHandle:=nil;
FId:=0;
FHandle:=pixmap_loadmemory(data,size,0);

FOriginalWidth:=FHandle.width;
FOriginalHeight:=FHandle.height;
FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;

if (isPowerOfTwo(FHandle.width) and isPowerOfTwo(FHandle.height)) then
begin
if FHandle.format>=4 then
fId:=CreateGlTexture(FHandle.width,FHandle.height,TRUE,FHandle.pixels,LinearInterpolating,Repeating) else
fId:=CreateGlTexture(FHandle.width,FHandle.height,false,FHandle.pixels,LinearInterpolating,Repeating);
FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;
FOriginalWidth:=FHandle.width;
FOriginalHeight:=FHandle.height;
end else
begin
pixmap_free(FHandle);
FHandle:=pixmap_loadmemory_power_of2(data,size,0);
if FHandle.format>=4 then
fId:=CreateGlTexture(FHandle.width,FHandle.height,TRUE,FHandle.pixels,LinearInterpolating,Repeating) else
fId:=CreateGlTexture(FHandle.width,FHandle.height,false,FHandle.pixels,LinearInterpolating,Repeating);
FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;
end;

PatternWidth:=FOriginalWidth;
PatternHeight:=FOriginalHeight;

end;

constructor TTexture.Create(fname:string);
begin
filename:=fname;
LinearInterpolating:=false;
Repeating:=true;
FHandle:=nil;
FId:=0;
FHandle:=pixmap_load(PAnsiChar(fname),0);

FOriginalWidth:=FHandle.width;
FOriginalHeight:=FHandle.height;
FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;

if (isPowerOfTwo(FHandle.width) and isPowerOfTwo(FHandle.height)) then
begin
if FHandle.format>=4 then
fId:=CreateGlTexture(FHandle.width,FHandle.height,TRUE,FHandle.pixels,LinearInterpolating,Repeating) else
fId:=CreateGlTexture(FHandle.width,FHandle.height,false,FHandle.pixels,LinearInterpolating,Repeating);
FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;
FOriginalWidth:=FHandle.width;
FOriginalHeight:=FHandle.height;
end else
begin
pixmap_free(FHandle);
FHandle:=pixmap_load_power_of2(PAnsiChar(fname),0);
if FHandle.format>=4 then
fId:=CreateGlTexture(FHandle.width,FHandle.height,TRUE,FHandle.pixels,LinearInterpolating,Repeating) else
fId:=CreateGlTexture(FHandle.width,FHandle.height,false,FHandle.pixels,LinearInterpolating,Repeating);
FTextureWidth:=FHandle.width;
FTextureHeight:=FHandle.height;
end;
PatternWidth:=FOriginalWidth;
PatternHeight:=FOriginalHeight;


end;

destructor TTexture.Destroy;
begin
glDeleteTextures(1, @fId);
pixmap_free(FHandle);
FHandle:=nil;
end;


procedure TTexture.bind();
begin
 glBindTexture(GL_TEXTURE_2D, FId);
end;
function TTexture.getId;
begin
result:=fId;
end;


function TTexture.GetName: string;
begin
  Result := FName;
end;

procedure TTexture.SetName(Value: string);
begin
  FName := Value;
end;


function TTexture.GetHeight(const Original: Boolean): Integer;
begin
  if (Original) then
    Result := FOriginalHeight
  else
    Result := FTextureHeight;
end;

function TTexture.GetWidth(const Original: Boolean): Integer;
begin
  if (Original) then
    Result := FOriginalWidth
  else
    Result := FTextureWidth;
end;



procedure  TTexture.Get_Pixel(x,y:integer;var Red, Green, Blue, Alpha: byte);
begin


end;

procedure  TTexture.Set_Pixel(x,y:integer;var Red, Green, Blue, Alpha: byte);
begin


end;

{ TStream }

var
  GSeed: Longword = 0;









procedure Gfx_SetBlendMode(const blend:integer);
begin
	//glDisable(GL_ALPHA_TEST);
 //	glEnable(GL_BLEND); // Enable Blending
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



    if ((Blend and BLEND_ALPHABLEND) <> (FCurBlendMode and BLEND_ALPHABLEND)) then
  begin
    if ((Blend and BLEND_ALPHABLEND) <> 0) then
   	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)  	//Alpha blending
    else
    	glBlendFunc(GL_SRC_ALPHA, GL_ONE); //Addictive
  end;


  if ((Blend and BLEND_ZWRITE) <> (FCurBlendMode and BLEND_ZWRITE)) then
   begin
    if ((Blend and BLEND_ZWRITE) <> 0) then
      glDepthMask(GLboolean(GL_TRUE)) { *Converted from glDepthMask*  }
    else
     glDepthMask(GLboolean(GL_FALSE)); { *Converted from glDepthMask*  }
  end;

     //glTexEnvx
  if ((Blend and BLEND_COLORADD) <> (FCurBlendMode and BLEND_COLORADD)) then
   begin
    if ((Blend and BLEND_COLORADD) <> 0) then
      glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_ADD)
    else
      glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
  end;

  FCurBlendMode := Blend;
end;


procedure RenderBatch(const EndScene: Boolean=false);
var
i:integer;
vertex:THGEVertex;
r,g,b,a:byte;
color:longword;
begin
  if Assigned(FVertArray) then
  begin
   if (FPrim <> 0) then
   begin
   {
         for i:=0 to (FPrim*4) do // VERTEX_BUFFER_SIZE-1  do
         begin
          vertex:=FVertArray[i];
          color:=vertex.Col;
          COLOR_UnRGBA(color,r,g,b,a);
          vertex.Col:=ARGB(a,b,g,r);
          FVertArray[i]:=vertex;
         end;
    }

      case FCurPrimType of
        HGEPRIM_QUADS:
        begin
     //   glDrawArrays(GL_QUADS, 0, FPrim *4 );
       glDrawElements(GL_TRIANGLES, FPrim*6, GL_UNSIGNED_SHORT, @Findices[0]);
        end;
        HGEPRIM_TRIPLES:
        begin
         glDrawArrays(GL_TRIANGLES, 0, FPrim * 3 );
        end;
        HGEPRIM_LINES:
        begin
        glDrawArrays(GL_LINES, 0, FPrim *2 );
        end;
      end;

      FPrim := 0;
    end;

    if (EndScene) then
    begin
      FreeMem(FVertArray);
      FVertArray := nil;
    end ;
   end;



end;


procedure Gfx_RenderRect( x,  y,  width,  height:single;colord:cardinal;depth:single);
begin

		Gfx_RenderLine(x,y,x+width,y,colord,depth);
		Gfx_RenderLine(x+width,y,x+width,y+height,colord,depth);
		Gfx_RenderLine(x+width,y+height,x,y+height,colord,depth);
		Gfx_RenderLine(x,y+height,x,y,colord,depth);
end;


procedure Gfx_RenderRect( x,  y,  width,  height:single;r,g,b:single;depth:single);
begin

		Gfx_RenderLine(x,y,x+width,y,COLOR_ARGB(1,r,g,b),depth);
		Gfx_RenderLine(x+width,y,x+width,y+height,COLOR_ARGB(1,r,g,b),depth);
		Gfx_RenderLine(x+width,y+height,x,y+height,COLOR_ARGB(1,r,g,b),depth);
		Gfx_RenderLine(x,y+height,x,y,COLOR_ARGB(1,r,g,b),depth);
end;

procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single;const Color: Longword; const Z: Single);
var
  I: Integer;
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_LINES)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_LINES)
      or (FCurTexture <> nil) or (FCurBlendMode <> BLEND_DEFAULT)
    then begin
     RenderBatch;
      FCurPrimType := HGEPRIM_LINES;
      if (FCurBlendMode <> BLEND_DEFAULT) then
        Gfx_SetBlendMode(BLEND_DEFAULT);
      if (FCurTexture <> nil) then
      begin
         glBindTexture(GL_TEXTURE_2D, 0);
        FCurTexture := nil;
      end;
    end;

    I := FPrim * HGEPRIM_LINES;
    FVertArray[I].X := X1; FVertArray[I+1].X := X2;
    FVertArray[I].Y := Y1; FVertArray[I+1].Y := Y2;
    FVertArray[I].Z     := Z;
    FVertArray[I+1].Z   := Z;
    FVertArray[I].Col   := Color;
    FVertArray[I+1].Col := Color;
    FVertArray[I].TX    := 0;
    FVertArray[I+1].TX  := 0;
    FVertArray[I].TY    := 0;
    FVertArray[I+1].TY  := 0;

    Inc(FPrim);
  end;
end;

procedure Gfx_RenderTriple(const Triple: THGETriple);
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_TRIPLES)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_TRIPLES)
      or (FCurTexture <> Triple.Tex)
      or (FCurBlendMode <> Triple.Blend)
    then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_TRIPLES;
      if (FCurBlendMode <> Triple.Blend) then
        Gfx_SetBlendMode(Triple.Blend);
      if (Triple.Tex <> FCurTexture) then
      begin
        if Assigned(Triple.Tex) then Triple.Tex.bind()        else           glBindTexture(GL_TEXTURE_2D, 0);
          FCurTexture := Triple.Tex;
      end;

    end;

    Move(Triple.V,FVertArray[FPrim * HGEPRIM_TRIPLES],SizeOf(THGEVertex) * HGEPRIM_TRIPLES);
    Inc(FPrim);
  end;
end;

procedure Gfx_BeginBatch;
begin
if Assigned(FVertArray) then
begin
      FreeMem(FVertArray);
      FVertArray := nil;
end;
    FCurTexture:=NIL;
    GetMem( pointer(FVertArray),VERTEX_BUFFER_SIZE * SizeOf(THGEVertex));

     glEnableClientState(GL_VERTEX_ARRAY);
     glEnableClientState(GL_COLOR_ARRAY);
     glEnableClientState(GL_TEXTURE_COORD_ARRAY);


    glVertexPointer    (3, GL_FLOAT,  sizeof (ThgeVertex), @FVertArray[0].x);
    glColorPointer     (4, GL_UNSIGNED_BYTE,  sizeof (ThgeVertex), @FVertArray[0].col);
    glTexCoordPointer  (2, GL_FLOAT,  sizeof (ThgeVertex), @FVertArray[0].tx);


end;



procedure Gfx_EndBatch;
begin

  RenderBatch(True);
  FCurTexture:=NIL;

	glDisableClientState (GL_VERTEX_ARRAY);
	glDisableClientState (GL_TEXTURE_COORD_ARRAY);
	glDisableClientState (GL_COLOR_ARRAY);

end;
procedure Gfx_RenderQuad( Quad: THGEQuad);
var
i:integer;
vertex:THGEVertex;
r,g,b,a:byte;
color:longword;
begin
  if Assigned(FVertArray) then
  begin
    if (FCurPrimType <> HGEPRIM_QUADS)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_QUADS)

      or (FCurTexture <> Quad.Tex)
      or (FCurBlendMode <> Quad.Blend) 
  then
    begin
      RenderBatch;
      FCurPrimType := HGEPRIM_QUADS;
      if (FCurBlendMode <> Quad.Blend) then
      Gfx_SetBlendMode(Quad.Blend);
      if (Quad.Tex <> FCurTexture) then
      begin
        if Assigned(Quad.Tex) then Quad.Tex.bind()        else           glBindTexture(GL_TEXTURE_2D, 0);
          FCurTexture := Quad.Tex;
      end;
    end;

     for i:=0 to 3 do
         begin
          vertex:=Quad.v[i];
          color:=vertex.Col;
          COLOR_UnRGBA(color,r,g,b,a);
          vertex.Col:=ARGB(a,b,g,r);
          Quad.v[i]:=vertex;
         end;


    Move(Quad.V,FVertArray[FPrim * HGEPRIM_QUADS],SizeOf(THGEVertex) * HGEPRIM_QUADS);
    Inc(FPrim);
  end;
end;

    {
//1000 = 194
procedure Gfx_RenderQuad( Quad: THGEQuad);
var
r,g,b,a:byte;
begin

  if (quad.Tex<>nil) then quad.Tex.bind();
  SetBlendMode(quad.Blend);


    glBegin(GL_QUADS);
    COLOR_UnRGBA(quad.v[0].Col,r,g,b,a);glColor4ub(r,g,b,a);
	  glTexCoord2f(quad.v[0].TX,quad.v[0].ty);
    glVertex3f( quad.v[0].x,quad.v[0].y,quad.v[0].z);
    COLOR_UnRGBA(quad.v[1].Col,r,g,b,a);glColor4ub(r,g,b,a);
    glTexCoord2f(quad.v[1].tx,quad.v[1].ty);
    glVertex3f( quad.v[1].x,quad.v[1].y,quad.v[1].z);
    COLOR_UnRGBA(quad.v[2].Col,r,g,b,a);glColor4ub(r,g,b,a);
    glTexCoord2f(quad.v[2].tx,quad.v[2].ty);
    glVertex3f( quad.v[2].x,quad.v[2].y,quad.v[2].z);
    COLOR_UnRGBA(quad.v[3].Col,r,g,b,a);glColor4ub(r,g,b,a);
   	glTexCoord2f(quad.v[3].tx,quad.v[3].ty);
    glVertex3f( quad.v[3].x,quad.v[3].y,quad.v[3].z);
    glEnd();

end;
    }


//1000 = 200
procedure Gfx_RenderQuadUp( Quad: THGEQuad);
var
    Vertices  : array[0..3] of Vector3f;
    TexCoords : array[0..3] of Vector2f;
    Colors    : array[0..3] of Color4f;

r,g,b,a:byte;

indices:array[0..5]of integer;



begin


      indices[0]:=0;indices[1]:=1;indices[2]:=2;
      indices[3]:=0;indices[4]:=2;indices[5]:=3;


      
    Vertices[0].x:=quad.v[1].x;
    Vertices[0].y:=quad.v[1].y;
    Vertices[0].z:=quad.v[1].z;
    TexCoords[0].x:=quad.v[1].tx;
    TexCoords[0].y:=quad.v[1].ty;
    COLOR_UnRGBA(quad.v[1].col,r,g,b,a);
    Colors[0].r:=r;    Colors[0].g:=g;    Colors[0].b:=b;    Colors[0].a:=a;




    Vertices[1].x:=quad.v[0].x;
    Vertices[1].y:=quad.v[0].y;
    Vertices[1].z:=quad.v[0].z;
    TexCoords[1].x:=quad.v[0].tx;
    TexCoords[1].y:=quad.v[0].ty;
    COLOR_UnRGBA(quad.v[0].col,r,g,b,a);
    Colors[1].r:=r;    Colors[1].g:=g;    Colors[1].b:=b;    Colors[1].a:=a;


    Vertices[2].x:=quad.v[3].x;
    Vertices[2].y:=quad.v[3].y;
    Vertices[2].z:=quad.v[3].z;
    TexCoords[2].x:=quad.v[3].tx;
    TexCoords[2].y:=quad.v[3].ty;
    COLOR_UnRGBA(quad.v[3].col,r,g,b,a);
    Colors[2].r:=r;    Colors[2].g:=g;    Colors[2].b:=b;    Colors[2].a:=a;


    Vertices[3].x:=quad.v[2].x;
    Vertices[3].y:=quad.v[2].y;
    Vertices[3].z:=quad.v[2].z;
    TexCoords[3].x:=quad.v[2].tx;
    TexCoords[3].y:=quad.v[2].ty;
    COLOR_UnRGBA(quad.v[2].col,r,g,b,a);
    Colors[3].r:=r;    Colors[3].g:=g;    Colors[3].b:=b;    Colors[3].a:=a;


          {
       //************
    Vertices[0].x:=quad.v[0].x;
    Vertices[0].y:=quad.v[0].y;
    Vertices[0].z:=quad.v[0].z;
    TexCoords[0].x:=quad.v[0].tx;
    TexCoords[0].y:=quad.v[0].ty;
    COLOR_UnRGBA(quad.v[0].col,r,g,b,a);
    Colors[0].r:=r;    Colors[0].g:=g;    Colors[0].b:=b;    Colors[0].a:=a;






    Vertices[1].x:=quad.v[1].x;
    Vertices[1].y:=quad.v[1].y;
    Vertices[1].z:=quad.v[1].z;
    TexCoords[1].x:=quad.v[1].tx;
    TexCoords[1].y:=quad.v[1].ty;
    COLOR_UnRGBA(quad.v[1].col,r,g,b,a);
    Colors[1].r:=r;    Colors[1].g:=g;    Colors[1].b:=b;    Colors[1].a:=a;

    Vertices[2].x:=quad.v[3].x;
    Vertices[2].y:=quad.v[3].y;
    Vertices[2].z:=quad.v[3].z;
    TexCoords[2].x:=quad.v[3].tx;
    TexCoords[2].y:=quad.v[3].ty;
    COLOR_UnRGBA(quad.v[2].col,r,g,b,a);
    Colors[2].r:=r;    Colors[2].g:=g;    Colors[2].b:=b;    Colors[2].a:=a;


    Vertices[3].x:=quad.v[2].x;
    Vertices[3].y:=quad.v[2].y;
    Vertices[3].z:=quad.v[2].z;
    TexCoords[3].x:=quad.v[2].tx;
    TexCoords[3].y:=quad.v[2].ty;
    COLOR_UnRGBA(quad.v[3].col,r,g,b,a);
    Colors[3].r:=r;    Colors[3].g:=g;    Colors[3].b:=b;    Colors[3].a:=a;
    //*/***
         }


  if (quad.Tex<>nil) then quad.Tex.bind();
Gfx_SetBlendMode(quad.Blend);


    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);



    glVertexPointer    (3, GL_FLOAT, sizeof(Vector3f), @Vertices[0]);
    glColorPointer     (4, GL_FLOAT, sizeof(Color4f), @Colors[0]);
    glTexCoordPointer  (2, GL_FLOAT, sizeof(Vector2f), @TexCoords[0]);











   //0,1,2, // first triangle (bottom left - top left - top right)
	 //	0,2,3; // second triangle (bottom left - top right - bottom right)

 //	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, @indices[0]);

 //    glDrawArrays(GL_TRIANGLES, 0, 4);

     glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	//glDrawArrays(GL_QUADS, 0, 4);


          glDisableClientState(GL_VERTEX_ARRAY);
          glDisableClientState(GL_TEXTURE_COORD_ARRAY);
          glDisableClientState(GL_COLOR_ARRAY);



end;



   {

procedure Gfx_RenderQuad( Quad: THGEQuad);
var
verteces:array[0..11]of single;
texCoords:array[0..7]of single;
colors:array[0..15]of GLByte;
r,g,b,a:byte;

indices:array[0..5]of integer;



begin


      indices[0]:=0;indices[1]:=1;indices[2]:=2;
      indices[3]:=0;indices[4]:=2;indices[5]:=3;


    verteces[0]:=quad.v[1].x;
    verteces[1]:=quad.v[1].y;
    verteces[2]:=quad.v[1].z;

    verteces[3]:=quad.v[0].x;
    verteces[4]:=quad.v[0].y;
    verteces[5]:=quad.v[0].z;

    verteces[6]:=quad.v[3].x;
    verteces[7]:=quad.v[3].y;
    verteces[8]:=quad.v[3].z;


    verteces[9]:=quad.v[2].x;
    verteces[10]:=quad.v[2].y;
    verteces[11]:=quad.v[2].z;




       texCoords[0]:=quad.v[1].tx;
       texCoords[1]:=quad.v[1].ty;

       texCoords[2]:=quad.v[0].tx;
       texCoords[3]:=quad.v[0].ty;

       texCoords[4]:=quad.v[3].tx;
       texCoords[5]:=quad.v[3].ty;

       texCoords[6]:=quad.v[2].tx;
       texCoords[7]:=quad.v[2].ty;

  r:=1;
  g:=1;
  b:=1;
  a:=1;

// COLOR_UnRGBA(quad.v[1].Col,r,g,b,a);
 colors[0]:=r; colors[1]:=g; colors[2]:=b; colors[3]:=a;
// COLOR_UnRGBA(quad.v[0].Col,r,g,b,a);
 colors[4]:=r; colors[5]:=g; colors[6]:=b; colors[7]:=a;
// COLOR_UnRGBA(quad.v[3].Col,r,g,b,a);
 colors[8]:=r; colors[9]:=g; colors[10]:=b; colors[11]:=a;
 //COLOR_UnRGBA(quad.v[2].Col,r,g,b,a);
 colors[12]:=r; colors[13]:=g; colors[14]:=b; colors[15]:=a;


  if (quad.Tex<>nil) then quad.Tex.bind();
  SetBlendMode(quad.Blend);



    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);


  glVertexPointer(3, GL_FLOAT, 0, @verteces[0]);
  glColorPointer(4, GL_UNSIGNED_BYTE, 0, @colors[0]);
 	glTexCoordPointer(2, GL_FLOAT, 0, @texCoords[0]);


   //0,1,2, // first triangle (bottom left - top left - top right)
	 //	0,2,3; // second triangle (bottom left - top right - bottom right)

 //	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, @indices[0]);

    // glDrawArrays(GL_TRIANGLES, 0, 4);

 //    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	glDrawArrays(GL_QUADS, 0, 4);


          glDisableClientState(GL_VERTEX_ARRAY);
          glDisableClientState(GL_TEXTURE_COORD_ARRAY);
          glDisableClientState(GL_COLOR_ARRAY);






end;


    }










function Resource_Load(const Filename: String;const Size: pLongword;var data:pointer):boolean ;
const
  ResErr = 'Can''t load resource: %s';
var
  Name, ZipName: String;
  Done, I: Integer;
  F: THandle;
  BytesRead: Cardinal;
  uncompressed_size : Longint;
begin


  Result := false;
  Data := nil;
  if (Filename = '') then      Exit;

                                 {



    // Load from file
  F := FileCreate(PChar(Filename));
  if (F = INVALID_HANDLE_VALUE) then
  begin
   Exit;
  end;

  uncompressed_size := FileSize(F);
  try
    GetMem(Data,uncompressed_size);
  except
    FileClose(F);
    Exit;
  end;

  if (not FileRead(F) ) then
  begin
    FileClose(F);
    FreeMem(Data);
    Exit;
  end;

 // Result := IResource.Create(Data,BytesRead);
  FileClose(F);
//  if Assigned(Size) then    Size^ := BytesRead;
}
result:=true;

end;





function Random_Float(const Min, Max: Single): Single;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + (GSeed shr 16) * (1.0 / 65535.0) * (Max - Min);
end;

function Random_Int(const Min, Max: Integer): Integer;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + Integer((GSeed xor GSeed shr 15) mod Cardinal(Max - Min + 1));
end;

procedure Random_Seed(const Seed: Integer);
begin
  if (Seed = 0) then
    GSeed := GetTickCount
  else
    GSeed := Seed;
end;






function System_Initiate: Boolean;
var
n,x,i:integer;
  PIndices: PInteger;

begin
  rate:= 1;
  maxElapsed:= 0.0333;
  _time:=GetTickCount;
  lastFPSCount:=0;
  Random_Seed;
  Result := True;
  FVertArray := nil;
  setlength( FIndices,VERTEX_BUFFER_SIZE * 6 div 4 * SizeOf(INTEGER));

  FPrim := 0;
  FCurPrimType := HGEPRIM_QUADS;
  FCurBlendMode := BLEND_DEFAULT;
  FCurTexture := nil;

  n:=0;
  x:=0;

  for I := 0 to (VERTEX_BUFFER_SIZE div 4) - 1 do
  begin
  FIndices[x]:=n;  inc(x);
  FIndices[x]:=n+1;inc(x);
  FIndices[x]:=n+2;inc(x);
  FIndices[x]:=n+2;inc(x);
  FIndices[x]:=n+3;inc(x);
  FIndices[x]:=n;  inc(x);
  Inc(N,4);
  end;

   


          {
     GetMem( FIndices,VERTEX_BUFFER_SIZE * 6 div 4 * SizeOf(integer));

     PIndices:=@FIndices[0];

  for I := 0 to (VERTEX_BUFFER_SIZE div 4) - 1 do begin
    PIndices^ := N  ; Inc(PIndices);
    PIndices^ := N+1; Inc(PIndices);
    PIndices^ := N+2; Inc(PIndices);
    PIndices^ := N+2; Inc(PIndices);
    PIndices^ := N+3; Inc(PIndices);
    PIndices^ := N;   Inc(PIndices);
    Inc(N,4);
  end;

   }
end;
function System_End: Boolean;
begin

  
setlength(FIndices,0);

if Assigned(FVertArray) then
begin
      FreeMem(FVertArray);
      FVertArray := nil;
end;
end;



procedure System_Log(const S: String);
begin
writeln(s);
end;



function System_Loop: Boolean;
var
    finished : Boolean;
begin
      _time := GetTickCount();
			 elapsed := (_time - _last) / 1000;
			if (elapsed > maxElapsed) then elapsed := maxElapsed;
			elapsed :=elapsed* rate;
			_last := _time;
      inc(FPSCount);
			if( _time - 1000 > _ms_prev ) then
      begin
      _ms_prev := _time;
      lastFPSCount:=FPSCount;
      FPSCount:=0;
      end;
  Result := True;
end;


function Texture_GetHeight(const Tex: TTexture;const Original: Boolean): Integer;
begin
  Result := Tex.GetHeight(Original);
end;

function Texture_GetWidth(const Tex: TTexture;const Original: Boolean): Integer;
begin
  Result := Tex.GetWidth(Original);
end;



function Texture_Load(const Filename: String): TTexture;
var
 tex:TTexture;
begin
  tex:=TTexture.Create(filename);
  result:=tex;
end;
function Texture_Load(data:pointer;size:integer): TTexture;
var
 tex:TTexture;
begin
  tex:=TTexture.Create(data,size);
  result:=tex;
end;





function Timer_GetDelta: Single;
begin
  Result := elapsed;
end;

function Timer_GetFPS: Integer;
begin
 Result :=max( lastFPSCount,FPSCount);
end;

function Timer_GetTime: Single;
begin
  Result := GetTickCount();
end;






function TSpline.GetPixel(index:integer):Xpoint;
begin
result:=FPixelsPts[index];
end;


function TSpline.GetControlPoint(index:integer):Xpoint;
begin
result:=mMidPoints[index];
end;

procedure TSpline.SaveFile(fname:string);
begin
end;
procedure TSpline.LoadFile(fname:string);
begin

end;




function TSpline.GetPixelCount:integer;
begin
result:=high(FPixelsPts);
end;
function TSpline.GetPointsCount:integer;
begin
result:=high(mMidPoints);
end;

procedure TSpline.PointOnCurve(var Point:Xpoint; t:single;p0,p1,p2,p3:Xpoint);
var
t2,t3:single;
begin
 t2 := t * t;
 t3 := t2 * t;
	point.x := 0.5 * (( 2.0 * p1.x ) +
		( -p0.x + p2.x ) * t +
		( 2.0 * p0.x - 5.0 * p1.x + 4 * p2.x - p3.x ) * t2 +
		( -p0.x + 3.0 * p1.x - 3.0 * p2.x + p3.x ) * t3 );

	point.y := 0.5 * ( ( 2.0 * p1.y ) +
		( -p0.y + p2.y ) * t +
		( 2.0 * p0.y - 5.0 * p1.y + 4 * p2.y - p3.y ) * t2 +
		( -p0.y + 3.0 * p1.y - 3.0 * p2.y + p3.y ) * t3 );

end;


procedure TSpline.Render(x,y:single;color,controlColor:DWORD);
var
i,size:integer;
begin

  size:=high(mMidPoints);
  if size>=0 then
  begin
    for i:=0 to size do
    begin
//     phge.Rectangle(mMidPoints[i].x, mMidPoints[i].y,2,2,controlColor,false);
    end;
  end;


	if (mCount > 0) then
  begin
  size:=high(FPixelsPts);
  for i:=0 to size-1 do
  begin
//  phge.Line2Color(x+FPixelsPts[i].x, y+FPixelsPts[i].y, x+FPixelsPts[i+1].x, y+FPixelsPts[i+1].y, color,color,0);
  end;
  size:=high(mMidPoints);
  for i:=0 to size do
  begin
//   phge.Rectangle(mMidPoints[i].x-3, mMidPoints[i].y-3,6,6,controlColor,true);
  end;

  end;
end;

procedure TSpline.Clear;
begin
    SetLength(mMidPoints, 0);
    SetLength(FPixelsPts, 0);


      mCount:=0;

end;

procedure TSpline.GeneratePixels;
var
	 dx,dy,dist,t,inc,x, y:single;
   newPt,extraPt:Xpoint;
   n:integer;
begin
     SetLength(FPixelsPts,0);

 inc := 0.0001;


	x := mMidPoints[0].x;
	y := mMidPoints[0].y;

  newPt.x:=x;
  newPt.y:=y;

 AddPixel(newPT);

 for n:=0 to  high(mMidPoints)-2 do
 begin
 t:=inc;
 while (t<=1.0) do
 begin
 		PointOnCurve(newPt, t, mMidPoints[n], mMidPoints[n+1], mMidPoints[n+2], mMidPoints[n+3]);
  
			 dx := newPt.x-x;
			 dy := newPt.y-y;

			    dist := sqrt(dx*dx + dy*dy);

       		if (dist >= 1.0) then
          begin
           AddPixel(newPt);
				   x := newPt.x;
				   y := newPt.y;

          end;

       	t :=t+ inc;
 end;
 end;

 mCount:=high(FPixelsPts);
end;

procedure TSpline.AddControlPoint( Point:Xpoint);
begin
     SetLength(mMidPoints, Length(mMidPoints) + 1);
     mMidPoints[High(mMidPoints)] := Point;
end;
procedure TSpline.AddControlPoint( x,y:single);
var
tp:Xpoint;
begin
tp.x:=x;
tp.y:=y;
AddControlPoint(tp);
end;
procedure TSpline.EditPoint(index:integer; Point:Xpoint);
begin
     mMidPoints[index] := Point;
end;
procedure TSpline.EditPoint(index:integer; x,y:single);

var
tp:Xpoint;
begin
tp.x:=x;
tp.y:=y;
EditPoint(index,tp);

end;

procedure TSpline.EditPixel(index:integer; Point:Xpoint);
begin
     FPixelsPts[index] := Point;
end;
procedure TSpline.EditPixel(index:integer; x,y:single);

var
tp:Xpoint;
begin
tp.x:=x;
tp.y:=y;
EditPixel(index,tp);

end;


procedure TSpline.AddPixel( Point:Xpoint);
begin
     SetLength(FPixelsPts, Length(FPixelsPts) + 1);
     FPixelsPts[High(FPixelsPts)] := Point;
end;





procedure BltQuad( Quad: ThgeQuad;Src,Dest:TRECT;z:single;Color:dword; Angle : Single;VFlip,HFlip:boolean);
function swap(a,b:single;isswap:boolean):single;
begin
if isswap then
result:=b else result:=a;
end;
var
 Verts:array[0..3]of ThgeVertex;
SurfW,
SurfH,
XCenter ,
YCenter,

XCor ,
YCor:single;
  pvb:pbyte;
  w,h:integer;
begin

w:=Texture_GetWidth(Quad.tex);
h:=Texture_GetHeight(Quad.tex);


SurfW := w+2;
SurfH := h+2;

XCenter := Dest.Left + (Dest.Right - Dest.Left + 1) / 2;
YCenter := Dest.Top  + (Dest.Bottom - Dest.Top + 1) / 2;


If Angle = 0 Then
begin
    XCor := Dest.Left;
    YCor := Dest.Bottom;
end Else
begin
    XCor := XCenter + (Dest.Left - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle);
End;



Quad.V[0]:=CreateHGEVertex(XCor,YCor,z,color,
swap(Src.Left / SurfW,(Src.Right + 1) / SurfW,VFlip),
swap((Src.Bottom + 1) / SurfH,Src.Top / SurfH,HFlip));

If Angle = 0 Then
begin
    XCor := Dest.Left;
    YCor := Dest.Top;
end Else
begin

    XCor := XCenter + (Dest.Left - XCenter) * Sin(Angle ) + (Dest.Top - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle);
End;


//1 - Top left vertex
Quad.V[1]:=CreateHGEVertex(XCor,YCor,z,color,
swap(Src.Left / SurfW,(Src.Right + 1) / SurfW,VFlip),
swap(Src.Top / SurfH,(Src.Bottom + 1) / SurfH,HFlip)


);

If Angle = 0 Then
begin
    XCor := Dest.Right;
    YCor := Dest.Bottom;
end Else
begin
    XCor := XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle) ;
    YCor := YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle);
End;



//2 - Bottom right vertex
Quad.V[3]:=CreateHGEVertex(XCor,YCor,z,color,
swap((Src.Right + 1) / SurfW,Src.Left / SurfW,VFlip),
swap((Src.Bottom + 1) / SurfH,Src.Top / SurfH,HFlip)


);

If Angle = 0 Then
begin
    XCor := Dest.Right;
    YCor := Dest.Top;
end Else
begin
    XCor := XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Top - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle);
End;



//3 - Top right vertex
Quad.V[2]:=CreateHGEVertex (XCor,YCor,z,color,
swap((Src.Right + 1) / SurfW,Src.Left / SurfW,VFlip),
swap(Src.Top / SurfH,(Src.Bottom + 1) / SurfH,HFlip)
);



Gfx_RenderQuad(Quad);



end;


procedure Blt(Texture:TTexture;Src,Dest:TRECT;z:single;Color:dword; Angle : Single;VFlip,HFlip:boolean;blend:integer);
function swap(a,b:single;isswap:boolean):single;
begin
if isswap then
result:=b else result:=a;
end;
var
 Verts:array[0..3]of ThgeVertex;
SurfW,
SurfH,
XCenter ,
YCenter,

XCor ,
YCor:single;
  pvb:pbyte;
  w,h:integer;

  Quad: ThgeQuad;
begin

w:=Texture_GetWidth(Texture);
h:=Texture_GetHeight(Texture);


SurfW := w+2;
SurfH := h+2;

XCenter := Dest.Left + (Dest.Right - Dest.Left + 1) / 2;
YCenter := Dest.Top  + (Dest.Bottom - Dest.Top + 1) / 2;


If Angle = 0 Then
begin
    XCor := Dest.Left;
    YCor := Dest.Bottom;
end Else
begin
    XCor := XCenter + (Dest.Left - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle);
End;



Quad.V[0]:=CreateHGEVertex(XCor,YCor,z,color,
swap(Src.Left / SurfW,(Src.Right + 1) / SurfW,VFlip),
swap((Src.Bottom + 1) / SurfH,Src.Top / SurfH,HFlip));

If Angle = 0 Then
begin
    XCor := Dest.Left;
    YCor := Dest.Top;
end Else
begin

    XCor := XCenter + (Dest.Left - XCenter) * Sin(Angle ) + (Dest.Top - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Left - XCenter) * Cos(Angle);
End;


//1 - Top left vertex
Quad.V[1]:=CreateHGEVertex(XCor,YCor,z,color,
swap(Src.Left / SurfW,(Src.Right + 1) / SurfW,VFlip),
swap(Src.Top / SurfH,(Src.Bottom + 1) / SurfH,HFlip)


);

If Angle = 0 Then
begin
    XCor := Dest.Right;
    YCor := Dest.Bottom;
end Else
begin
    XCor := XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Bottom - YCenter) * Cos(Angle) ;
    YCor := YCenter + (Dest.Bottom - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle);
End;



//2 - Bottom right vertex
Quad.V[3]:=CreateHGEVertex(XCor,YCor,z,color,
swap((Src.Right + 1) / SurfW,Src.Left / SurfW,VFlip),
swap((Src.Bottom + 1) / SurfH,Src.Top / SurfH,HFlip)


);

If Angle = 0 Then
begin
    XCor := Dest.Right;
    YCor := Dest.Top;
end Else
begin
    XCor := XCenter + (Dest.Right - XCenter) * Sin(Angle) + (Dest.Top - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.Top - YCenter) * Sin(Angle) - (Dest.Right - XCenter) * Cos(Angle);
End;



//3 - Top right vertex
Quad.V[2]:=CreateHGEVertex (XCor,YCor,z,color,
swap((Src.Right + 1) / SurfW,Src.Left / SurfW,VFlip),
swap(Src.Top / SurfH,(Src.Bottom + 1) / SurfH,HFlip)
);

 quad.Tex:=Texture;
 quad.Blend:=blend;

Gfx_RenderQuad(Quad);



end;




procedure DrawImageUp(texture:TTexture;x,y,w,h:integer;z:single;Color:dword;blend:integer);
var
Quad: ThgeQuad;
x1,y1,y2,x2:integer;
xOffset,yOffset:integer;
begin
Quad.tex:=texture;
Quad.blend:=blend;

x1 :=x;
y1 :=y;
x2 :=x+w;
y2 :=y+h;




        quad.v[0].z := z;
                quad.v[1].z := z;
                        quad.v[2].z := z;
                                quad.v[3].z := z;

        quad.v[0].x   := x1;
        quad.v[0].y   := y1;
        quad.v[0].col := Color;

        quad.v[1].x   := x2;
        quad.v[1].y   := y1;
        quad.v[1].col := Color;

        quad.v[2].x   := x2;
        quad.v[2].y   := y2;
        quad.v[2].col := Color;

        quad.v[3].x   := x1;
        quad.v[3].y   := y2;
        quad.v[3].col := Color;


        quad.v[0].tx := 0.0;        quad.v[0].ty := 0.0;
        quad.v[1].tx := 1.0;        quad.v[1].ty := 0.0;
        quad.v[2].tx := 1.0;        quad.v[2].ty := 1.0;
        quad.v[3].tx := 0.0;        quad.v[3].ty := 1.0;


Gfx_RenderQuad(Quad);
end;

procedure DrawImage(texture:TTexture;x,y,w,h:integer;z:single;Color:dword;blend:integer);
var
Quad: ThgeQuad;
x1,y1,y2,x2:integer;
xOffset,yOffset:integer;
begin
Quad.tex:=texture;
Quad.blend:=blend;

x1 :=x;
y1 :=y;
x2 :=x+w;
y2 :=y+h;




        quad.v[0].z := z;
                quad.v[1].z := z;
                        quad.v[2].z := z;
                                quad.v[3].z := z;

        quad.v[0].x   := x1;
        quad.v[0].y   := y1;
        quad.v[0].col := Color;

        quad.v[1].x   := x2;
        quad.v[1].y   := y1;
        quad.v[1].col := Color;

        quad.v[2].x   := x2;
        quad.v[2].y   := y2;
        quad.v[2].col := Color;

        quad.v[3].x   := x1;
        quad.v[3].y   := y2;
        quad.v[3].col := Color;


        quad.v[0].tx := 0.0;        quad.v[0].ty := 0.0;
        quad.v[1].tx := 1.0;        quad.v[1].ty := 0.0;
        quad.v[2].tx := 1.0;        quad.v[2].ty := 1.0;
        quad.v[3].tx := 0.0;        quad.v[3].ty := 1.0;


Gfx_RenderQuad(Quad);
end;





procedure DrawImage(texture:TTexture;x,y,z,w,h:single;Color:dword;blend:integer);
var
Src,Dest:TRECT;
Quad: ThgeQuad;
begin

Quad.tex:=texture;
Quad.blend:=blend;
src.Left:=round(x);
src.Top:=round(y);
src.Right:=round(x+w);
src.Bottom:=round(y+h);
dest.Left:=0;
dest.top:=0;
dest.Right:=Texture_GetWidth(texture);
dest.Bottom:=Texture_GetHeight(texture);
BltQuad(Quad,dest,src,z,color,0,false,false);
end;


procedure DrawImage(texture:TTexture;x,y,z,srcx,srcy,srcw,srch:single;Color:dword;blend:integer);


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: ThgeQuad;
begin
  TempX1 := X ;
  TempY1 := Y ;
  TempX2 := X + srcw ;
  TempY2 := Y + srch;



  TexX1 := srcx;
  TexY1 := srcy;
  TexX2 := srcw;
  TexY2 := srch;

  FQuad.V[0].TX := TexX1; FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2; FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2; FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1; FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.0;
  FQuad.V[1].Z := 0.0;
  FQuad.V[2].Z := 0.0;
  FQuad.V[3].Z := 0.0;


    FQuad.V[0].Col := Color;
    FQuad.V[1].Col := Color;
    FQuad.V[2].Col := Color;
    FQuad.V[3].Col := Color;

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;
  Gfx_RenderQuad(fquad);

end;

procedure DrawImage(texture:TTexture;x,y,z,w,h,angle:single;Color:dword;blend:integer);
var
Src,Dest:TRECT;
Quad: ThgeQuad;
begin

Quad.tex:=texture;
Quad.blend:=blend;
src.Left:=round(x);
src.Top:=round(y);
src.Right:=round(x+w);
src.Bottom:=round(y+h);
dest.Left:=0;
dest.top:=0;
dest.Right:=Texture_GetWidth(Quad.tex);
dest.Bottom:=Texture_GetHeight(Quad.tex);

BltQuad(Quad,dest,src,z,color,angle,false,false);
end;

procedure DrawImage(texture:TTexture;x,y,z,angle:single;Color:dword;blend:integer);
var
Src,Dest:TRECT;
Quad: ThgeQuad;
begin

Quad.tex:=texture;
Quad.blend:=blend;

dest.Left:=0;
dest.top:=0;
dest.Right:=Texture_GetWidth(texture);
dest.Bottom:=Texture_GetHeight(texture);

src.Left:=round(x);
src.Top:=round(y);
src.Right:=round(x+dest.Right);
src.Bottom:=round(y+dest.Bottom);


BltQuad(Quad,dest,src,z,color,angle,false,false);
end;





end.