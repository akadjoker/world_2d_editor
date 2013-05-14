

unit HGEClasses;



interface

uses
 windows, math,dialogs, SysUtils, Classes,HGE,SpriteCloud;

     
const
  MAX_PARTICLES  = 500;
  MAX_PSYSTEMS  = 100;



const
  HGEANIM_FWD = 0;
  HGEANIM_REV = 1;
  HGEANIM_PINGPONG = 2;
  HGEANIM_NOPINGPONG = 0;
  HGEANIM_LOOP = 4;
  HGEANIM_NOLOOP = 0;

  const
  HGETEXT_LEFT     = 0;
  HGETEXT_RIGHT    = 1;
  HGETEXT_CENTER   = 2;
  HGETEXT_HORZMASK = $03;

  HGETEXT_TOP      = 0;
  HGETEXT_BOTTOM   = 4;
  HGETEXT_MIDDLE   = 8;
  HGETEXT_VERTMASK = $0C;


const
  HGEDISP_NODE = 0;
  HGEDISP_TOPLEFT = 1;
  HGEDISP_CENTER = 2;


type

  tpoint=record
    x,y:integer;
  end;
  TQuad = array [0..3] of TPoint;


  TGlip=record
      TX, TY, Width, Height: Single;
      TexWidth, TexHeight: Single;
      TexX1, TexY1, TexX2, TexY2: Single;
  end;


THGERect = object
  private
    FClean: Boolean;
  public
    X1, Y1, X2, Y2: Single;
    procedure init(const Clean: Boolean); overload;
    procedure init(const AX1, AY1, AX2, AY2: Single); overload;
    procedure Clear;
    function IsClean: Boolean;
    procedure SetRect(const AX1, AY1, AX2, AY2: Single);
    procedure SetRadius(const X, Y, R: Single);
    procedure Encapsulate(const X, Y: Single);
    function TextPoint(const X, Y: Single): Boolean;
    function Intersect(const Rect: THGERect): Boolean;
        procedure draw(color:integer);
  end;
  PHGERect = ^THGERect;


  THGEParticle = record
    Location: hVector;
    Velocity: hVector;

    Gravity: Single;
    RadialAccel: Single;
    TangentialAccel: Single;

    Spin: Single;
    SpinDelta: Single;

    Size: Single;
    SizeDelta: Single;

    Color: HColor;
    ColorDelta: HColor;

    Age: Single;
    TerminalAge: Single;
  end;
  PHGEParticle = ^THGEParticle;


  THGESprite = class
 public

    procedure Render(const X, Y: Single);
    procedure RenderEx(const X, Y, Rot: Single; const HScale: Single = 1.0; VScale: Single = 0.0);
    procedure RenderStretch(const X1, Y1, X2, Y2: Single);
    procedure Render4V(const X0, Y0, X1, Y1, X2, Y2, X3, Y3: Single);

    procedure SetTexture(const Tex: TTEXTURE);
    procedure SetTextureRect(const X, Y, W, H: Single; const AdjSize: Boolean = True);
    procedure SetColor(const Col: dword; const I: Integer = -1);
    procedure SetZ(const Z: Single; const I: Integer = -1);
    procedure SetBlendMode(const Blend: Integer);
    procedure SetHotSpot(const X, Y: Single);
    procedure SetFlip(const X, Y: Boolean; const HotSpot: Boolean = False);

    function GetTexture: TTexture;
    procedure GetTextureRect(out X, Y, W, H: Single);
    function GetColor(const I: Integer = 0): dword;
    function GetZ(const I: Integer = -0): Single;
    function GetBlendMode: Integer;
    procedure GetHotSpot(out X, Y: Single);
    procedure GetFlip(out X, Y: Boolean);

    function GetBoundingBox(const X, Y: Single; var Rect: THGERect): THGERect;
    function GetBoundingBoxEx(const X, Y, Rot, HScale, VScale: Single; var Rect: THGERect): THGERect;
    function GetWidth: Single;
    function GetHeight: Single;


  public
       FQuad: THGEQuad;

  private
    Rect:THGERect;
    FTX, FTY, FWidth, FHeight: Single;
    FTexWidth, FTexHeight: Single;
    FHotX, FHotY: Single;
    FXFlip, FYFlip, FHSFlip: Boolean;

 published

    property TX: Single read FTX;
    property TY: Single read FTY;
    property Width: Single read FWidth;
    property Height: Single read FHeight;
    property TexWidth: Single read FTexWidth;
    property TexHeight: Single read FTexHeight;
    property HotX: Single read FHotX;
    property HotY: Single read FHotY;
    property XFlip: Boolean read FXFlip write FXFlip;
    property YFlip: Boolean read FYFlip write FYFlip;
    property HSFlip: Boolean read FHSFlip write FHSFlip;
  public
    constructor Create(const Texture: TTEXTURE; const TexX, TexY, W, H: Single);


  end;

   THGEAnimation = class(THGESprite)
  private
    procedure AnimationSetTextureRect(const X, Y, W, H: Single);
 public
    { IHGEAnimation }
    procedure Play;
    procedure Stop;
    procedure Resume;
    procedure Update(const DeltaTime: Single);
    function  IsPlaying: Boolean;

    procedure SetTexture(const Tex: TTEXTURE);
    procedure SetMode(const Mode: Integer);
    procedure SetSpeed(const FPS: Single);
    procedure SetFrame(const N: Integer);
    procedure SetFrames(const N: Integer);

    function GetMode: Integer;
    function GetSpeed: Single;
    function GetFrame: Integer;
    function GetFrames: Integer;
  private
    FOrigWidth: Integer;
    FPlaying: Boolean;
    FSpeed: Single;
    FSinceLastFrame: Single;
    FMode: Integer;
    FDelta: Integer;
    FFrames: Integer;
    FCurFrame: Integer;
  public
    constructor Create(const Texture: TTEXTURE; const NFrames: Integer; const FPS: Single; const X, Y, W, H: Single); overload;

  end;


  THGEFont = class
  protected
    { IHGEFont }

    function GetSprite(const Chr: Char): THGESprite;
    function GetHeight: Single;
    function GetStringWidth(const S: String;
      const FirstLineOnly: Boolean = True): Single;

  private
 // batch:TSpriteCloud;
  private
    FTexture: TTEXTURE;
    FLetters: array [0..255] of THGESprite;
   // glips:array[0..255]of TGlip;
    FPre, FPost: array [0..255] of Single;
    FHeight, FScale, FProportion, FRot, FTracking, FSpacing, FZ: Single;
    FCol: Longword;
    FBlend: Integer;
    function GetLine(const FromFile, Line: PChar): PChar;
  public

    constructor Create(const Filename: String);overload;
    constructor Create(image:TTexture;data:pointer;size:longword);overload;

    destructor Destroy;


    procedure Render(const X, Y: Single; const Algn: Integer; const S: String);
    procedure PrintF(const X, Y: Single; const Align: Integer;const Format: String; const Args: array of const);
    procedure PrintFB(const X, Y, W, H: Single; const Align: Integer;const Format: String; const Args: array of const);

    procedure SetColor(const Col: Longword);
    procedure SetZ(const Z: Single);
    procedure SetBlendMode(const Blend: Integer);
    procedure SetScale(const Scale: Single);
    procedure SetProportion(const Prop: Single);
    procedure SetRotation(const Rot: Single);
    procedure SetTracking(const Tracking: Single);
    procedure SetSpacing(const Spacing: Single);

    function GetColor: Longword;
    function GetZ: Single;
    function GetBlendMode: Integer;
    function GetScale: Single;
    function GetProportion: Single;
    function GetRotation: Single;
    function GetTracking: Single;
    function GetSpacing: Single;

  end;

   THGEDistortionMesh= Class
  protected


    function GetTexture: TTEXTURE;
    procedure GetTextureRect(out X, Y, W, H: Single);
    function GetBlendMode: Integer;
    function GetZ(const Col, Row: Integer): Single;
    function GetColor(const Col, Row: Integer): Longword;
    procedure GetDisplacement(const Col, Row: Integer; out DX, DY: Single;const Ref: Integer);

    function GetRows: Integer;
    function GetCols: Integer;

  private
    FDispArray:array of ThgeVertex;
    FRows, FCols: Integer;
    FCellW, FCellH: Single;
    FTX, FTY, FWidth, FHeight: Single;
    FQuad: THGEQuad;
  public
    destructor Destroy; override;
    constructor Create(const Cols, Rows: Integer);

     procedure Render(const X, Y: Single);
    procedure Clear(const Col: Longword = $FFFFFFFF; const Z: Single = 0.5);

    procedure SetTexture(const Tex: TTEXTURE);
    procedure SetTextureRect(const X, Y, W, H: Single);
    procedure SetBlendMode(const Blend: Integer);
    procedure SetZ(const Col, Row: Integer; const Z: Single);
    procedure SetColor(const Col, Row: Integer; const Color: Longword);
    procedure SetDisplacement(const Col, Row: Integer; const DX, DY: Single; const Ref: Integer);

  end;





  THGEParticleSystemInfo = record
    Sprite: THGESprite;
    Emission: Integer;
    Lifetime: Single;

    ParticleLifeMin: Single;
    ParticleLifeMax: Single;

    Direction: Single;
    Spread: Single;
    Relative: Boolean;

    SpeedMin: Single;
    SpeedMax: Single;

    GravityMin: Single;
    GravityMax: Single;

    RadialAccelMin: Single;
    RadialAccelMax: Single;

    TangentialAccelMin: Single;
    TangentialAccelMax: Single;

    SizeStart: Single;
    SizeEnd: Single;
    SizeVar: Single;

    SpinStart: Single;
    SpinEnd: Single;
    SpinVar: Single;

    ColorStart: HColor;
    ColorEnd: HColor;
    ColorVar: Single;
    AlphaVar: Single;
  end;
  PHGEParticleSystemInfo = ^THGEParticleSystemInfo;


  THGEParticleSystem = class
  protected
    { IHGEParticleSystem }
    function GetInfo: THGEParticleSystemInfo;

    procedure Transpose(const X, Y: Single);
    function GetParticlesAlive: Integer;
    function GetAge: Single;
    procedure GetPosition(out X, Y: Single);
    procedure GetTransposition(out X, Y: Single);



  private

    FInfo: THGEParticleSystemInfo;
    FAge: Single;
    FEmissionResidue: Single;
    FPrevLocation: hVector;
    FLocation: hVector;
    FTX, FTY: Single;
    FParticlesAlive: Integer;
    spaw:integer;
    FParticles: array [0..MAX_PARTICLES - 1] of THGEParticle;
  public
     procedure Render;
    procedure FireAt(const X, Y: Single);
    procedure Fire;
    procedure Stop(const KillParticles: Boolean = False);
    procedure Update(const DeltaTime: Single);
    procedure MoveTo(const X, Y: Single; const MoveParticles: Boolean = False);

    constructor Create(data:pointer;size:longword;FSprite:THGESprite); overload;
    constructor Create(const Filename: String;FSprite:THGESprite); overload;
    constructor Create(const PSI: THGEParticleSystemInfo); overload;
    procedure Save(const Filename: String);

   published
   property ParticlesAlive:integer read FParticlesAlive;
   property Emission: Integer read FInfo.emission write FInfo.emission;
  end;
  THGEParticleManager = class
  protected
    procedure Update(const DT: Single);
    procedure Render;

    function SpawnPS(const PSI: THGEParticleSystemInfo;const X, Y: Single): THGEParticleSystem;
    function IsPSAlive(const PS: THGEParticleSystem): Boolean;
    procedure Transpose(const X, Y: Single);
    procedure GetTransposition(out DX, DY: Single);
    procedure KillPS(const PS: THGEParticleSystem);
    procedure KillAll;
  private
    FNPS: Integer;
    FTX: Single;
    FTY: Single;
    FPSList: array [0..MAX_PSYSTEMS - 1] of THGEParticleSystem;
  public
    destructor Destroy; override;
  end;


    THGECanvas = object
  private
    FWidth, FHeight: Single;
    FTexWidth, FTexHeight: Integer;
    procedure SetColor(Color: Cardinal); overload;
    procedure SetColor(Color1, Color2, Color3, Color4: Cardinal); overload;
    procedure SetPattern(Texture: TTexture; PatternIndex: Integer);
    procedure SetMirror(MirrorX, MirrorY: Boolean);
  protected
    FQuad: THGEQuad;


  public


    procedure Draw(Image: TTexture; PatternIndex: Integer; X, Y: Single; BlendMode: Integer);  overload;
    procedure Draw(Image: TTexture; PatternIndex: Integer; X, Y: Single; color:dword;BlendMode: Integer);  overload;

    procedure DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single;
      MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;

    procedure DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;

    procedure DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Color: Cardinal; BlendMode: Integer); overload;


    procedure DrawColor1(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawColor1(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawColor1(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Red, Green, Blue, Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha1(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha1(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Alpha: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha1(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Alpha: Byte; Blendmode: Integer); overload;
    procedure DrawColor4(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawColor4(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawColor4(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawAlpha4(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha4(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer); overload;
    procedure DrawAlpha4(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer); overload;
    procedure Draw4V(Image:TTexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure Draw4V(Image:TTexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer); overload;
    procedure DrawStretch(Image: TTexture; PatternIndex: Integer; X1, Y1, X2, Y2: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
    procedure DrawPart(Texture: TTexture; X, Y, SrcX, SrcY, Width, Height,
      ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawPart(Texture: TTexture; X, Y, SrcX, SrcY, Width, Height: Single;
      Color: Cardinal; BlendMode: Integer); overload;

    procedure DrawRotate(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;

    procedure DrawRotate(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle: Real; Color: Cardinal; BlendMode: Integer); overload;

    procedure DrawRotateColor4(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY,

      Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
    procedure DrawRotateC(Image: TTexture; PatternIndex: Integer; X, Y, Angle,
      ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer); overload;
    procedure DrawRotateC(Image: TTexture; PatternIndex: Integer; X, Y, Angle: Single;
      Color: Cardinal; BlendMode: Integer); overload;

    procedure DrawWaveX(Image: TTexture; X, Y, Width, Height: Integer; Amp, Len,
      Phase: Integer; Color: Cardinal; BlendMode: Integer);

    procedure DrawWaveY(Image: TTexture; X, Y, Width, Height: Integer; Amp, Len,
      Phase: Integer; Color: Cardinal; BlendMode: Integer);
  end;

  
 THGEImages = class
 private
   Images: array of TTexture;
   SearchObjects: array of Integer;
   SearchDirty  : Boolean;
   function GetItem(Index: Integer): TTexture;
   function GetItemCount(): Integer;
   procedure InitSearchObjects();
   procedure SwapSearchObjects(Index1, Index2: Integer);
   function CompareSearchObjects(Obj1, Obj2: TTexture): Integer;
   function SplitSearchObjects(Start, Stop: Integer): integer;
   procedure SortSearchObjects(Start, Stop: integer);
   procedure UpdateSearchObjects();
   function GetImage(const Name: string): TTexture;
 public
   property Items[Index: Integer]: TTexture read GetItem; default;
   property ItemCount: Integer read GetItemCount;
   property Image[const Name: string]: TTexture read GetImage;
   function IndexOf(Element: TTexture): Integer; overload;
   function IndexOf(const Name: string): Integer; overload;
   procedure Remove(Index: Integer);

   procedure LoadFromFile(FileName: string); overload;
   procedure LoadFromFile(FileName: string; PatternWidth, PatternHeight: Integer); overload;

   procedure Load(FileName: string); overload;
   procedure Load(FileName: string; PatternWidth, PatternHeight: Integer); overload;


   procedure RemoveAll();
   constructor Create();
   destructor Destroy(); override;
 end;

 
  TTile=record
     MirrorX, MirrorY: Boolean;
     id:integer;
     Solid:boolean;
end;
PTile=^TTile;


THGETileMap = class
 public
      FCollisionMap: array of boolean;
      FMap: array of TTile;
      FCanvas:THGECanvas;

      FMapW:Integer;
      FMapH: Integer;
      FMapWidth: Integer;
      FMapHeight: Integer;
      FDoTile: Boolean;

      FScaleX, FScaleY: Single;
      FDoCenter: Boolean;
      FAlpha,FRed, FGreen, FBlue:integer;
      FBlendMode: Integer;

      X,Y:single;
      VisibleWidth,VisibleHeight,Height,Width:integer;
      FImage:TTexture;
      FNumTiles:integer;
      FContX:integer;
      FContY:integer;

      function GetCollisionMapItem(X, Y: Integer): Boolean;

      function GetCell(X, Y: Integer): TTile;
      procedure SetCell(X, Y: Integer; Value: TTile);

      procedure SetCollisionMapItem(X, Y: Integer; Value: Boolean);
      procedure SetMapSize(AMapWidth, AMapHeight: Integer);

 protected
      scrollx,scrolly:single;
 public
      constructor Create(worldw,worldh,tilew,tileh:integer;texture:TTexture);overload;
      constructor Create();overload;
      destructor Destroy;

      procedure Render;

    Procedure LoadFromStream(Stream  : TStream);
    Procedure SaveToStream  (Stream  : TStream);
    Procedure LoadFromFile  (FileName: String);
    Procedure SaveToFile    (FileName: String);



      procedure SetViewPort(w,h:integer);
      procedure SetTile(X, Y: Integer; Value:integer);

      procedure SetTileFlipX(X, Y: Integer; Value:boolean);
      procedure SetTileFlipY(X, Y: Integer; Value:boolean);

      property Cells[X, Y: Integer]: TTile read GetCell write SetCell;
      property CollisionMap[X, Y: Integer]: Boolean read GetCollisionMapItem write SetCollisionMapItem;
    //  property MapHeight: Integer read FMapHeight write SetMapHeight;
    //  property MapWidth: Integer read FMapWidth write SetMapWidth;
      property DoTile: Boolean read FDoTile write FDoTile;
    //  property NumTiles:integer read FNumTiles;
      property TilesX:integer read FContX;
      property TilesY:integer read FContY;

 end;

 Function  ReadStr (Stream: TStream): String;               overload;
procedure ReadStr (Stream: TStream; var   Value: String ); overload;
procedure WriteStr(Stream: TStream; const Value: String );



implementation


//------------------------------------------------------------------------------
Function ReadStr (Stream: TStream): String;
var i:word; s:string;
begin
  Stream.Read(i,SizeOf(i));
  SetLength(s,i);
  Stream.Read(PChar(s)^,i);
  Result:=s;
end;

//------------------------------------------------------------------------------
procedure ReadStr (Stream: TStream; var Value: String );
begin
  Value:=ReadStr(Stream);
end;

//------------------------------------------------------------------------------
procedure WriteStr (Stream: TStream; const Value: String );
var i:word;
begin
  i:=Length(Value);
  Stream.Write(i,SizeOf(i));
  Stream.Write(PChar(Value)^,i);
end;

(****************************************************************************
 * HGEFont.h, HGEFont.cpp
 ****************************************************************************)

const
  FNTHEADERTAG = '[HGEFONT]';
  FNTBITMAPTAG = 'Bitmap';
  FNTCHARTAG = 'Char';

{ THGEFont }

function setglip(Texture:TTEXTURE;TexX, TexY, W, H: Single):TGlip;
begin
  result.TX := TexX;
  result.TY := TexY;
  result.Width := W;
  result.Height := H;



  if (Texture<>nil) then
  begin
    result.TexWidth := Texture_GetWidth(Texture);
    result.TexHeight :=Texture_GetHeight(Texture);
  end else begin
    result.TexWidth := 1;
    result.TexHeight := 1;
  end;


  result.TexX1 := TexX / result.TexWidth;
  result.TexY1 := TexY / result.TexHeight;
  result.TexX2 := (TexX + W) / result.TexWidth;
  result.TexY2 := (TexY + H) / result.TexHeight;

end;

constructor THGEFont.Create(image:TTexture;data:pointer;size:longword);
var
  Desc, PDesc, PBuf: PChar;
  LineBuf: array [0..255] of Char;
  S: String;
  Chr: Char;
  I, X, Y, W, H, A, C: Integer;

  function GetParam: Integer;
  var
    Start: PChar;
    C: Char;
  begin
    while (PBuf^ in [' ',',']) do
      Inc(PBuf);
    Start := PBuf;
    while (PBuf^ in ['0'..'9']) do
      Inc(PBuf);
    if (PBuf = Start) then
      Result := 0
    else begin
      C := PBuf^;
      PBuf^ := #0;
      Result := StrToInt(Start);
      PBuf^ := C;
    end;
  end;


begin
  FScale := 1.0;
  FProportion := 1;
  FSpacing := 1.0;
  FZ := 0.0;
  FBlend := BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  FCol := $FFFFFFFF;


  if (Data = nil) then
    Exit;

  GetMem(Desc,Size + 1);
  Move(Data^,Desc^,Size);
  Desc[Size] := #0;
  Data := nil;

  PDesc := GetLine(Desc,LineBuf);
  if (StrComp(LineBuf,FNTHEADERTAG) <> 0) then
  begin
   System_Log('Font %s has incorrect format.');
    FreeMem(Desc);
    Exit;
  end;

  // Parse font description
  PDesc := GetLine(PDesc,LineBuf);
  while Assigned(PDesc) do
  begin
    if (StrLComp(LineBuf,FNTBITMAPTAG,Length(FNTBITMAPTAG)) = 0) then
    begin
//      S := image;

      PBuf := StrScan(LineBuf,'=');
      if (PBuf <> nil) then
       begin
        Inc(PBuf);
        S := Trim(PBuf);
      end;
     //  writeln(s);



      FTexture :=image;// pHGE.Texture_Load(s);
      if (FTexture = nil) then
      begin
        FreeMem(Desc);
        Exit;
      end;
    end else if (StrLComp(LineBuf,FNTCHARTAG,Length(FNTCHARTAG)) = 0) then
    begin
      PBuf := StrScan(LineBuf,'=');

      if (PBuf = nil) then
        Continue;
      Inc(PBuf);
      while (PBuf^ = ' ') do
        Inc(PBuf);
      if (PBuf^ = '"') then
      begin
        Inc(PBuf);
        I := Ord(PBuf^);
        Inc(PBuf,2);
      end else begin
        I := 0;
        while (PBuf^ in ['0'..'9','A'..'F','a'..'f']) do
        begin
          Chr := PBuf^;
          if (Chr >= 'a') then
            Dec(Chr,Ord(Ord('a') - Ord(':')));
          if (Chr >= 'A') then
            Dec(Chr,Ord(Ord('A') - Ord(':')));
          Dec(Chr,Ord('0'));
          if (Chr > #$F) then
            Chr := #$F;
          I := (I shl 4) or Ord(Chr);
          Inc(PBuf);
        end;
        if (I < 0) or (I > 255) then
          Continue;
      end;
      X := GetParam;
      Y := GetParam;
      W := GetParam;
      H := GetParam;
      A := GetParam;
      C := GetParam;
      FLetters[I] := THGESprite.Create(FTexture,X,Y,W,H);

//      glips[i]:=setglip(FTexture,X,Y,W,H);

      FPre[I] := A;
      FPost[I] := C;
      if (H > FHeight) then
        FHeight := H;
    end;
    PDesc := GetLine(PDesc,LineBuf);
  end;
  FreeMem(Desc);
end;



constructor THGEFont.Create(const Filename: String);
var
  Data: Pointer;
  Size: Longword;
  Desc, PDesc, PBuf: PChar;
  LineBuf: array [0..255] of Char;
  S: String;
  Chr: Char;
  I, X, Y, W, H, A, C: Integer;

  function GetParam: Integer;
  var
    Start: PChar;
    C: Char;
  begin
    while (PBuf^ in [' ',',']) do
      Inc(PBuf);
    Start := PBuf;
    while (PBuf^ in ['0'..'9']) do
      Inc(PBuf);
    if (PBuf = Start) then
      Result := 0
    else begin
      C := PBuf^;
      PBuf^ := #0;
      Result := StrToInt(Start);
      PBuf^ := C;
    end;
  end;


begin
  FScale := 1.0;
  FProportion := 1;
  FSpacing := 1.0;
  FZ := 0.0;
  FBlend := BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  FCol := $FFFFFFFF;


 Resource_Load(Filename,@Size,data);
  if (Data = nil) then
    Exit;

  GetMem(Desc,Size + 1);
  Move(Data^,Desc^,Size);
  Desc[Size] := #0;
  Data := nil;

  PDesc := GetLine(Desc,LineBuf);
  if (StrComp(LineBuf,FNTHEADERTAG) <> 0) then
  begin
    System_Log('Font %s has incorrect format.');
    FreeMem(Desc);
    Exit;
  end;

  // Parse font description
  PDesc := GetLine(PDesc,LineBuf);
  while Assigned(PDesc) do
  begin
    if (StrLComp(LineBuf,FNTBITMAPTAG,Length(FNTBITMAPTAG)) = 0) then begin
      S := Filename;
      PBuf := StrScan(LineBuf,'=');
      if (PBuf <> nil) then begin
        Inc(PBuf);
        S := Trim(PBuf);
      end;

      s:=extractfilepath(filename)+s;


      FTexture := Texture_Load(S);
      if (FTexture = nil) then
      begin
        FreeMem(Desc);
        Exit;
      end;
    end else if (StrLComp(LineBuf,FNTCHARTAG,Length(FNTCHARTAG)) = 0) then
    begin
      PBuf := StrScan(LineBuf,'=');
      if (PBuf = nil) then
        Continue;
      Inc(PBuf);
      while (PBuf^ = ' ') do
        Inc(PBuf);
      if (PBuf^ = '"') then
      begin
        Inc(PBuf);
        I := Ord(PBuf^);
        Inc(PBuf,2);
      end else begin
        I := 0;
        while (PBuf^ in ['0'..'9','A'..'F','a'..'f']) do
        begin
          Chr := PBuf^;
          if (Chr >= 'a') then
            Dec(Chr,Ord(Ord('a') - Ord(':')));
          if (Chr >= 'A') then
            Dec(Chr,Ord(Ord('A') - Ord(':')));
          Dec(Chr,Ord('0'));
          if (Chr > #$F) then
            Chr := #$F;
          I := (I shl 4) or Ord(Chr);
          Inc(PBuf);
        end;
        if (I < 0) or (I > 255) then
          Continue;
      end;
      X := GetParam;
      Y := GetParam;
      W := GetParam;
      H := GetParam;
      A := GetParam;
      C := GetParam;
      FLetters[I] := THGESprite.Create(FTexture,X,Y,W,H);
      FPre[I] := A;
      FPost[I] := C;
      if (H > FHeight) then
        FHeight := H;
    end;
    PDesc := GetLine(PDesc,LineBuf);
  end;
  FreeMem(Desc);

//  batch:=TSpriteCloud.Create(FTexture);
end;

destructor THGEFont.Destroy;
var
  I: Integer;
begin
  for I := 0 to 255 do
    FLetters[I] := nil;
    if assigned(FTexture) then
    begin
    FTexture.Destroy;
     FTexture:= nil;
     end;
  inherited;
end;

function THGEFont.GetBlendMode: Integer;
begin
  Result := FBlend;
end;

function THGEFont.GetColor: Longword;
begin
  Result := FCol;
end;

function THGEFont.GetHeight: Single;
begin
  Result := FHeight;
end;

function THGEFont.GetLine(const FromFile, Line: PChar): PChar;
var
  I: Integer;
begin
  I := 0;
  if (FromFile[I] = #0) then begin
    Result := nil;
    Exit;
  end;

  while (not (FromFile[I] in [#0,#10,#13])) do begin
    Line[I] := FromFile[I];
    Inc(I);
  end;
  Line[I] := #0;

  while (FromFile[I] <> #0) and (FromFile[I] in [#10,#13]) do
    Inc(I);

  Result := @FromFile[I];
end;

function THGEFont.GetProportion: Single;
begin
  Result := FProportion;
end;

function THGEFont.GetRotation: Single;
begin
  Result := FRot;
end;

function THGEFont.GetScale: Single;
begin
  Result := FScale;
end;

function THGEFont.GetSpacing: Single;
begin
  Result := FSpacing;
end;

function THGEFont.GetSprite(const Chr: Char): THGESprite;
begin
  Result := FLetters[Ord(Chr)];
end;

function THGEFont.GetStringWidth(const S: String;
  const FirstLineOnly: Boolean = True): Single;
var
  I: Integer;
  LineW: Single;
  P: PChar;
begin
  Result := 0;
  P := PChar(S);
  while (P^ <> #0) do begin
    LineW := 0;
    while (not (P^ in [#0,#10,#13])) do begin
      I := Ord(P^);
      if (FLetters[I] = nil) then
        I := Ord('?');
      if Assigned(FLetters[I]) then
        LineW := LineW + FLetters[I].GetWidth + FPre[I] + FPost[I] + FTracking;
      Inc(P);
    end;
    if (LineW > Result) then
      Result := LineW;
    if (FirstLineOnly and (P^ in [#10,#13])) then
      Break;
    while (P^ in [#10,#13]) do
      Inc(P);
  end;
  Result := Result * FScale * FProportion;
end;

function THGEFont.GetTracking: Single;
begin
  Result := FTracking;
end;

function THGEFont.GetZ: Single;
begin
  Result := FZ;
end;


procedure THGEFont.PrintF(const X, Y: Single; const Align: Integer;
  const Format: String; const Args: array of const);
begin
  Render(X,Y,Align,SysUtils.Format(Format,Args));
end;

procedure THGEFont.PrintFB(const X, Y, W, H: Single; const Align: Integer;
  const Format: String; const Args: array of const);
var
  I, Lines: Integer;
  LineStart, PrevWord: PChar;
  Buf: String;
  PBuf: PChar;
  Chr: Char;
  TX, TY, WW, HH: Single;
begin
  Buf := SysUtils.Format(Format,Args);
  PBuf := PChar(Buf);
  Lines := 0;
  LineStart := PBuf;
  PrevWord := nil;
  while (True) do begin
    I := 0;
    while (not (PBuf[I] in [#0,#10,#13,' '])) do
      Inc(I);
    Chr := PBuf[I];
    PBuf[I] := #0;
    WW := GetStringWidth(LineStart);
    PBuf[I] := Chr;

    if (WW > W) then begin
      if (PBuf = LineStart) then begin
        PBuf[I] := #13;
        LineStart := @PBuf[I + 1];
      end else begin
        PrevWord^ := #13;
        LineStart := PrevWord + 1;
      end;
      Inc(Lines);
    end;

    if (PBuf[I] = #13) then begin
      PrevWord := @PBuf[I];
      LineStart := @PBuf[I + 1];
      PBuf := LineStart;
      Inc(Lines);
      Continue;
    end;

    if (PBuf[I] = #0) then begin
      Inc(Lines);
      Break;
    end;

    PrevWord := @PBuf[I];
    PBuf := @PBuf[I + 1];
  end;

  TX := X;
  TY := Y;
  HH := FHeight * FSpacing * FScale * Lines;

  case (Align and HGETEXT_HORZMASK) of
    HGETEXT_RIGHT:
      TX := TX + W;
    HGETEXT_CENTER:
      TX := TX + Trunc(W / 2);
  end;

  case (Align and HGETEXT_VERTMASK) of
    HGETEXT_BOTTOM:
      TY := TY + (H - HH);
    HGETEXT_MIDDLE:
      TY := TY + Trunc((H - HH) / 2);
  end;

  Render(TX,TY,Align,Buf);
end;

procedure THGEFont.Render(const X, Y: Single; const Algn: Integer;const S: String);
var
  I, J, Align: Integer;
  FX, FY: Single;
begin
  FX := X;
  FY := Y;
  Align := Algn and HGETEXT_HORZMASK;
  if (Align = HGETEXT_RIGHT) then
    FX := FX - GetStringWidth(S);
  if (Align = HGETEXT_CENTER) then
    FX := FX - Trunc(GetStringWidth(S) / 2);

  for J := 1 to Length(S) do
  begin
    if (S[J] in [#10,#13]) then
     begin
      FY := FY + Trunc(FHeight * FScale * FSpacing);
      FX := X;
      if (Align = HGETEXT_RIGHT) then
        FX := FX - GetStringWidth(Copy(S,J + 1,MaxInt));
      if (Align = HGETEXT_CENTER) then
        FX := FX - Trunc(GetStringWidth(Copy(S,J + 1,MaxInt)) / 2);
    end else
    begin
      I := Ord(S[J]);
      if (FLetters[I] = nil) then
        I := Ord('?');
      if Assigned(FLetters[I]) then
      begin
        FX := FX + FPre[I] * FScale * FProportion;
        FLetters[I].RenderEx(FX,FY,FRot,FScale * FProportion,FScale);
//        DrawImage(FTexture,fx,fy,glips[i].TexX1,glips[i].TexY1,glips[i].TexX2,glips[i].TexY2,FCol,Fblend);
        FX := FX + (FLetters[I].GetWidth + FPost[I] + FTracking) * FScale * FProportion;
      end;
    end;
  end;
end;

procedure THGEFont.SetBlendMode(const Blend: Integer);
var
  I: Integer;
begin
  FBlend := Blend;
  for I := 0 to 255 do
    if Assigned(FLetters[I]) then
      FLetters[I].SetBlendMode(Blend);
end;

procedure THGEFont.SetColor(const Col: Longword);
var
  I: Integer;
begin
  FCol := Col;
  for I := 0 to 255 do
    if Assigned(FLetters[I]) then
      FLetters[I].SetColor(Col);
end;

procedure THGEFont.SetProportion(const Prop: Single);
begin
  FProportion := Prop;
end;

procedure THGEFont.SetRotation(const Rot: Single);
begin
  FRot := Rot;
end;

procedure THGEFont.SetScale(const Scale: Single);
begin
  FScale := Scale;
end;

procedure THGEFont.SetSpacing(const Spacing: Single);
begin
  FSpacing := Spacing;
end;

procedure THGEFont.SetTracking(const Tracking: Single);
begin
  FTracking := Tracking;
end;

procedure THGEFont.SetZ(const Z: Single);
var
  I: Integer;
begin
  FZ := Z;
  for I := 0 to 255 do
    if Assigned(FLetters[I]) then
      FLetters[I].SetZ(Z);
end;



constructor THGESprite.Create(const Texture:TTEXTURE; const TexX, TexY, W, H: Single);
var
  TexX1, TexY1, TexX2, TexY2: Single;
begin
  FTX := TexX;
  FTY := TexY;
  FWidth := W;
  FHeight := H;



  if (Texture<>nil) then begin
    FTexWidth := Texture_GetWidth(Texture);
    FTexHeight :=Texture_GetHeight(Texture);
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;

  FQuad.Tex := Texture;

  TexX1 := TexX / FTexWidth;
  TexY1 := TexY / FTexHeight;
  TexX2 := (TexX + W) / FTexWidth;
  TexY2 := (TexY + H) / FTexHeight;

  FQuad.V[0].TX := TexX1; FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2; FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2; FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1; FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.0;
  FQuad.V[1].Z := 0.0;
  FQuad.V[2].Z := 0.0;
  FQuad.V[3].Z := 0.0;

  FQuad.V[0].Col := $ffffffff;
  FQuad.V[1].Col := $ffffffff;
  FQuad.V[2].Col := $ffffffff;
  FQuad.V[3].Col := $ffffffff;

  FQuad.Blend := BLEND_DEFAULT;
end;


function THGESprite.GetBlendMode: Integer;
begin
  Result := FQuad.Blend;
end;

function THGESprite.GetBoundingBox(const X, Y: Single;var Rect: THGERect): THGERect;
begin
  Rect.SetRect(X - FHotX,Y - FHotY,X - FHotX + FWidth,Y - FHotY + FHeight);
  Result := Rect;
end;

function THGESprite.GetBoundingBoxEx(const X, Y, Rot, HScale, VScale: Single;var Rect: THGERect): THGERect;
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  Rect.Clear;

  TX1 := -FHotX * HScale;
  TY1 := -FHotY * VScale;
  TX2 := (FWidth - FHotX) * HScale;
  TY2 := (FHeight - FHotY) * VScale;

  if (Rot <> 0.0) then
  begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    Rect.Encapsulate(TX1 * CosT - TY1 * SinT + X,TX1 * SinT + TY1 * CosT + Y);
    Rect.Encapsulate(TX2 * CosT - TY1 * SinT + X,TX2 * SinT + TY1 * CosT + Y);
    Rect.Encapsulate(TX2 * CosT - TY2 * SinT + X,TX2 * SinT + TY2 * CosT + Y);
    Rect.Encapsulate(TX1 * CosT - TY2 * SinT + X,TX1 * SinT + TY2 * CosT + Y);
  end else begin
    Rect.Encapsulate(TX1 + X, TY1 + Y);
    Rect.Encapsulate(TX2 + X, TY1 + Y);
    Rect.Encapsulate(TX2 + X, TY2 + Y);
    Rect.Encapsulate(TX1 + X, TY2 + Y);
  end;

  Result := Rect;
end;

function THGESprite.GetColor(const I: Integer): Longword;
begin
  Result := FQuad.V[I].Col;
end;

procedure THGESprite.GetFlip(out X, Y: Boolean);
begin
  X := FXFlip;
  Y := FYFlip;
end;

function THGESprite.GetHeight: Single;
begin
  Result := FHeight;
end;

procedure THGESprite.GetHotSpot(out X, Y: Single);
begin
  X := FHotX;
  Y := FHotY;
end;

function THGESprite.GetTexture: TTEXTURE;
begin
  Result := FQuad.Tex;
end;

procedure THGESprite.GetTextureRect(out X, Y, W, H: Single);
begin
  X := FTX;
  Y := FTY;
  W := FWidth;
  H := FHeight;
end;

function THGESprite.GetWidth: Single;
begin
  Result := FWidth;
end;

function THGESprite.GetZ(const I: Integer): Single;
begin
  Result := FQuad.V[I].Z;
end;


procedure THGESprite.Render(const X, Y: Single);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  TempX1 := X - FHotX;
  TempY1 := Y - FHotY;
  TempX2 := X + FWidth - FHotX;
  TempY2 := Y + FHeight - FHotY;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

 Gfx_RenderQuad(FQuad);
end;

procedure THGESprite.Render4V(const X0, Y0, X1, Y1, X2, Y2, X3, Y3: Single);
begin
  FQuad.V[0].X := X0; FQuad.V[0].Y := Y0;
  FQuad.V[1].X := X1; FQuad.V[1].Y := Y1;
  FQuad.V[2].X := X2; FQuad.V[2].Y := Y2;
  FQuad.V[3].X := X3; FQuad.V[3].Y := Y3;

 Gfx_RenderQuad(FQuad);
end;

procedure THGESprite.RenderEx(const X, Y, Rot, HScale: Single; VScale: Single);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  if (VScale=0) then
    VScale := HScale;

  TX1 := -FHotX * HScale;
  TY1 := -FHotY * VScale;
  TX2 := (FWidth - FHotX) * HScale;
  TY2 := (FHeight - FHotY) * VScale;

  if (Rot <> 0.0) then begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    FQuad.V[0].X := TX1 * CosT - TY1 * SinT + X;
    FQuad.V[0].Y := TX1 * SinT + TY1 * CosT + Y;

    FQuad.V[1].X := TX2 * CosT - TY1 * SinT + X;
    FQuad.V[1].Y := TX2 * SinT + TY1 * CosT + Y;

    FQuad.V[2].X := TX2 * CosT - TY2 * SinT + X;
    FQuad.V[2].Y := TX2 * SinT + TY2 * CosT + Y;

    FQuad.V[3].X := TX1 * CosT - TY2 * SinT + X;
    FQuad.V[3].Y := TX1 * SinT + TY2 * CosT + Y;
  end else begin
    FQuad.V[0].X := TX1 + X; FQuad.V[0].Y := TY1 + Y;
    FQuad.V[1].X := TX2 + X; FQuad.V[1].Y := TY1 + Y;
    FQuad.V[2].X := TX2 + X; FQuad.V[2].Y := TY2 + Y;
    FQuad.V[3].X := TX1 + X; FQuad.V[3].Y := TY2 + Y;
  end;

  Gfx_RenderQuad(FQuad);
end;

procedure THGESprite.RenderStretch(const X1, Y1, X2, Y2: Single);
begin
  FQuad.V[0].X := X1; FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2; FQuad.V[1].Y := Y1;
  FQuad.V[2].X := X2; FQuad.V[2].Y := Y2;
  FQuad.V[3].X := X1; FQuad.V[3].Y := Y2;

  Gfx_RenderQuad(FQuad);
end;

procedure THGESprite.SetBlendMode(const Blend: Integer);
begin
  FQuad.Blend := Blend;
end;

procedure THGESprite.SetColor(const Col: dword; const I: Integer);
begin
  if (I <> -1) then
    FQuad.V[I].Col := Col
  else begin
    FQuad.V[0].Col := Col;
    FQuad.V[1].Col := Col;
    FQuad.V[2].Col := Col;
    FQuad.V[3].Col := Col;
  end;
end;

procedure THGESprite.SetFlip(const X, Y: Boolean; const HotSpot: Boolean = False);
var
  TX, TY: Single;
begin
  if (FHSFlip and FXFlip) then
    FHotX := Width - FHotX;
  if (FHSFlip and FYFlip) then
    FHotY := Height - FHotY;

  FHSFlip := HotSpot;

  if (FHSFlip and FXFlip) then
    FHotX := Width - FHotX;
  if (FHSFlip and FYFlip) then
    FHotY := Height - FHotY;

  if (X <> FXFlip) then begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[1].TX; FQuad.V[1].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[1].TY; FQuad.V[1].TY := TY;
    TX := FQuad.V[3].TX; FQuad.V[3].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[3].TY; FQuad.V[3].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
    FXFlip := not FXFlip;
  end;

  if(Y <>  FYFlip) then begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[3].TX; FQuad.V[3].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[3].TY; FQuad.V[3].TY := TY;
    TX := FQuad.V[1].TX; FQuad.V[1].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[1].TY; FQuad.V[1].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
    FYFlip := not FYFlip;
  end;
end;

procedure THGESprite.SetHotSpot(const X, Y: Single);
begin
  FHotX := X;
  FHotY := Y;
end;

procedure THGESprite.SetTexture(const Tex: TTEXTURE);
var
  TX1, TY1, TX2, TY2, TW, TH: Single;
begin
  FQuad.Tex := Tex;

  if (Tex<>nil) then begin
    TW := Texture_GetWidth(Tex);
    TH := Texture_GetHeight(Tex);
  end else begin
    TW := 1.0;
    TH := 1.0;
  end;

  if (TW <> FTexWidth) or (TH <> FTexHeight) then begin
    TX1 := FQuad.V[0].TX * FTexWidth;
    TY1 := FQuad.V[0].TY * FTexHeight;
    TX2 := FQuad.V[2].TX * FTexWidth;
    TY2 := FQuad.V[2].TY * FTexHeight;

    FTexWidth := TW;
    FTexHeight := TH;

    TX1 := TX1 / TW; TY1 := TY1 / TH;
    TX2 := TX2 / TW; TY2 := TY2 / TH;

    FQuad.V[0].TX := TX1; FQuad.V[0].TY := TY1;
    FQuad.V[1].TX := TX2; FQuad.V[1].TY := TY1;
    FQuad.V[2].TX := TX2; FQuad.V[2].TY := TY2;
    FQuad.V[3].TX := TX1; FQuad.V[3].TY := TY2;
  end;
end;

procedure THGESprite.SetTextureRect(const X, Y, W, H: Single;
  const AdjSize: Boolean = True);
var
  TX1, TY1, TX2, TY2: Single;
  BX, BY, BHS: Boolean;
begin
  FTX := X;
  FTY := Y;
  if (AdjSize) then begin
    FWidth := W;
    FHeight := H;
  end;

  TX1 := FTX / FTexWidth; TY1 := FTY / FTexHeight;
  TX2 := (FTX + W) / FTexWidth; TY2 := (FTY + H) / FTexHeight;

  FQuad.V[0].TX := TX1; FQuad.V[0].TY := TY1;
  FQuad.V[1].TX := TX2; FQuad.V[1].TY := TY1;
  FQuad.V[2].TX := TX2; FQuad.V[2].TY := TY2;
  FQuad.V[3].TX := TX1; FQuad.V[3].TY := TY2;

  BX := FXFlip; BY := FYFlip; BHS := FHSFlip;
  FXFlip := False; FYFlip := False;
  SetFlip(BX,BY,BHS);
end;

procedure THGESprite.SetZ(const Z: Single; const I: Integer);
begin
  if (I <> -1) then
    FQuad.V[I].Z := Z
  else begin
    FQuad.V[0].Z := Z;
    FQuad.V[1].Z := Z;
    FQuad.V[2].Z := Z;
    FQuad.V[3].Z := Z;
  end;
end;

procedure THGEAnimation.AnimationSetTextureRect(const X, Y, W, H: Single);
begin
  inherited;
  SetFrame(FCurFrame);
end;

constructor THGEAnimation.Create(const Texture: TTEXTURE;const NFrames: Integer; const FPS, X, Y, W, H: Single);
begin
  inherited Create(Texture,X,Y,W,H);
  FOrigWidth := Texture_GetWidth(Texture,True);
  FSinceLastFrame := -1;
  FSpeed := 1 / FPS;
  FFrames := NFrames;
  FMode := HGEANIM_FWD or HGEANIM_LOOP;
  FDelta := 1;
  SetFrame(0);
end;



function THGEAnimation.GetFrame: Integer;
begin
  Result := FCurFrame;
end;

function THGEAnimation.GetFrames: Integer;
begin
  Result := FFrames;
end;

function THGEAnimation.GetMode: Integer;
begin
  Result := FMode;
end;

function THGEAnimation.GetSpeed: Single;
begin
  Result := 1 / FSpeed;
end;

function THGEAnimation.IsPlaying: Boolean;
begin
  Result := FPlaying;
end;

procedure THGEAnimation.Play;
begin
  FPlaying := True;
  FSinceLastFrame := -1;
  SetMode(FMode);
end;

procedure THGEAnimation.Resume;
begin
  FPlaying := True;
end;

procedure THGEAnimation.SetFrame(const N: Integer);
var
  TX1, TY1, TX2, TY2: Single;
  XF, YF, HS: Boolean;
  NCols, I: Integer;
begin
  NCols := FOrigWidth div Trunc(Width);
  FCurFrame := N mod FFrames;
  if (FCurFrame < 0) then
    FCurFrame := FFrames + FCurFrame;


  TY1 := TY;
  TX1 := TX + FCurFrame * Width;
  if (TX1 > FOrigWidth - Width) then begin
    I := FCurFrame - (Trunc(FOrigWidth - TX) div Trunc(Width));
    TX1 := Width * (I mod NCols);
    TY1 := TY1 + (Height * (1 + (I div NCols)));
  end;

  TX2 := TX1 + Width;
  TY2 := TY1 + Height;

  TX1 := TX1 / TexWidth;
  TY1 := TY1 / TexHeight;
  TX2 := TX2 / TexWidth;
  TY2 := TY2 / TexHeight;

  FQuad.V[0].TX := TX1; FQuad.V[0].TY := TY1;
  FQuad.V[1].TX := TX2; FQuad.V[1].TY := TY1;
  FQuad.V[2].TX := TX2; FQuad.V[2].TY := TY2;
  FQuad.V[3].TX := TX1; FQuad.V[3].TY := TY2;

  XF := XFlip; YF := YFlip; HS := HSFlip;
  XFlip := False; YFlip := False;
  SetFlip(XF,YF,HS);
end;

procedure THGEAnimation.SetFrames(const N: Integer);
begin
  FFrames := N;
end;

procedure THGEAnimation.SetMode(const Mode: Integer);
begin
  FMode := Mode;
  if ((FMode and HGEANIM_REV) <> 0) then begin
    FDelta := -1;
    SetFrame(FFrames - 1);
  end else begin
    FDelta := 1;
    SetFrame(0);
  end;
end;

procedure THGEAnimation.SetSpeed(const FPS: Single);
begin
  FSpeed := 1 / FPS;
end;

procedure THGEAnimation.SetTexture(const Tex: TTEXTURE);
begin
  inherited;
  FOrigWidth := Texture_GetWidth(Tex,True);
end;

procedure THGEAnimation.Stop;
begin
  FPlaying := False;
end;

procedure THGEAnimation.Update(const DeltaTime: Single);
begin
  if (not FPlaying) then
    Exit;

  if (FSinceLastFrame = -1) then
    FSinceLastFrame := 0
  else
    FSinceLastFrame := FSinceLastFrame + DeltaTime;

  while (FSinceLastFrame >= FSpeed) do begin
    FSinceLastFrame := FSinceLastFrame - FSpeed;

    if (FCurFrame + FDelta = FFrames) then begin
      case FMode of
        HGEANIM_FWD,
        HGEANIM_REV or HGEANIM_PINGPONG:
          FPlaying := False;
        HGEANIM_FWD or HGEANIM_PINGPONG,
        HGEANIM_FWD or HGEANIM_PINGPONG or HGEANIM_LOOP,
        HGEANIM_REV or HGEANIM_PINGPONG or HGEANIM_LOOP:
          FDelta := -FDelta;
      end;
    end else if (FCurFrame + FDelta < 0) then begin
      case FMode of
        HGEANIM_REV,
        HGEANIM_FWD or HGEANIM_PINGPONG:
          FPlaying := False;
        HGEANIM_REV or HGEANIM_PINGPONG,
        HGEANIM_REV or HGEANIM_PINGPONG or HGEANIM_LOOP,
        HGEANIM_FWD or HGEANIM_PINGPONG or HGEANIM_LOOP:
          FDelta := -FDelta;
      end;
    end;

    if (FPlaying) then
      SetFrame(FCurFrame + FDelta);
  end;
end;



procedure THGEDistortionMesh.Clear(const Col: Longword; const Z: Single);
var
  I, J: Integer;
begin
  for J := 0 to FRows - 1 do
    for I := 0 to FCols - 1 do begin
      FDispArray[J * FCols + I].X := I * FCellW;
      FDispArray[J * FCols + I].Y := J * FCellH;
      FDispArray[J * FCols + I].Col := Col;
      FDispArray[J * FCols + I].Z := Z;
    end;
end;

constructor THGEDistortionMesh.Create(const Cols, Rows: Integer);
var
  I: Integer;
begin
  inherited Create;

  FRows := Rows;
  FCols := Cols;
  FQuad.Blend := BLEND_DEFAULT;
  //GetMem(FDispArray,Rows * Cols * SizeOf(HGEVertex));
  setlength(FDispArray,Rows * Cols * SizeOf(THGEVertex));
  for I := 0 to Rows * Cols - 1 do begin
    FDispArray[I].X := 0;
    FDispArray[I].Y := 0;
    FDispArray[I].TX := 0;
    FDispArray[I].TY := 0;
    FDispArray[I].Z := 0.0;
    FDispArray[I].Col := $FFFFFFFF;
  end;
end;


destructor THGEDistortionMesh.Destroy;
begin
  FreeMem(FDispArray);
  inherited;
end;

function THGEDistortionMesh.GetBlendMode: Integer;
begin
  Result := FQuad.Blend;
end;

function THGEDistortionMesh.GetColor(const Col, Row: Integer): Longword;
begin
  if (Row < FRows) and (Col < FCols) then
    Result := FDispArray[Row * FCols + Col].Col
  else
    Result := 0;
end;

function THGEDistortionMesh.GetCols: Integer;
begin
  Result := FCols;
end;

procedure THGEDistortionMesh.GetDisplacement(const Col, Row: Integer; out DX,
  DY: Single; const Ref: Integer);
begin
  if (Row < FRows) and (Col < FCols) then begin
    case Ref of
      HGEDISP_NODE:
        begin
          DX := FDispArray[Row * FCols + Col].X - Col * FCellW;
          DY := FDispArray[Row * FCols + Col].Y - Row * FCellH;
        end;
      HGEDISP_CENTER:
        begin
          DX := FDispArray[Row * FCols + Col].X - (FCellW * (FCols - 1) / 2);
          DY := FDispArray[Row * FCols + Col].Y - (FCellH * (FRows - 1) / 2);
        end;
    else
      begin
        DX := FDispArray[Row * FCols + Col].X;
        DY := FDispArray[Row * FCols + Col].Y;
      end;
    end;
  end;
end;

function THGEDistortionMesh.GetRows: Integer;
begin
  Result := FRows;
end;

function THGEDistortionMesh.GetTexture: TTEXTURE;
begin
  Result := FQuad.Tex;
end;

procedure THGEDistortionMesh.GetTextureRect(out X, Y, W, H: Single);
begin
  X := FTX;
  Y := FTY;
  W := FWidth;
  H := FHeight;
end;

function THGEDistortionMesh.GetZ(const Col, Row: Integer): Single;
begin
  if (Row < FRows) and (Col < FCols) then
    Result := FDispArray[Row * FCols + Col].Z
  else
    Result := 0;
end;


procedure THGEDistortionMesh.Render(const X, Y: Single);
var
  I, J, Idx: Integer;
begin
  for J := 0 to FRows - 2 do
    for I := 0 to FCols - 2 do begin
      Idx := J * FCols + I;

      FQuad.V[0].TX := FDispArray[Idx].TX;
      FQuad.V[0].TY := FDispArray[Idx].TY;
      FQuad.V[0].X := X+FDispArray[Idx].X;
      FQuad.V[0].Y := Y+FDispArray[Idx].Y;
      FQuad.V[0].Z := FDispArray[Idx].Z;
      FQuad.V[0].Col := FDispArray[Idx].Col;

      FQuad.V[1].TX := FDispArray[Idx+1].TX;
      FQuad.V[1].TY := FDispArray[Idx+1].TY;
      FQuad.V[1].X := X+FDispArray[Idx+1].X;
      FQuad.V[1].Y := Y+FDispArray[Idx+1].Y;
      FQuad.V[1].Z := FDispArray[Idx+1].Z;
      FQuad.V[1].Col := FDispArray[Idx+1].Col;

      FQuad.V[2].TX := FDispArray[Idx+FCols+1].TX;
      FQuad.V[2].TY := FDispArray[Idx+FCols+1].TY;
      FQuad.V[2].X := X+FDispArray[Idx+FCols+1].X;
      FQuad.V[2].Y := Y+FDispArray[Idx+FCols+1].Y;
      FQuad.V[2].Z := FDispArray[Idx+FCols+1].Z;
      FQuad.V[2].Col := FDispArray[Idx+FCols+1].Col;

      FQuad.V[3].TX := FDispArray[Idx+FCols].TX;
      FQuad.V[3].TY := FDispArray[Idx+FCols].TY;
      FQuad.V[3].X := X+FDispArray[Idx+FCols].X;
      FQuad.V[3].Y := Y+FDispArray[Idx+FCols].Y;
      FQuad.V[3].Z := FDispArray[Idx+FCols].Z;
      FQuad.V[3].Col := FDispArray[Idx+FCols].Col;

      Gfx_RenderQuad(FQuad);
    end;
end;

procedure THGEDistortionMesh.SetBlendMode(const Blend: Integer);
begin
  FQuad.Blend := Blend;
end;

procedure THGEDistortionMesh.SetColor(const Col, Row: Integer;
  const Color: Longword);
begin
  if (Row < FRows) and (Col < FCols) then
    FDispArray[Row * FCols + Col].Col := Color;
end;

procedure THGEDistortionMesh.SetDisplacement(const Col, Row: Integer; const DX,
  DY: Single; const Ref: Integer);
var
  XDelta, YDelta: Single;
begin
  if (Row < FRows) and (Col < FCols) then begin
    case Ref of
      HGEDISP_NODE:
        begin
          XDelta := DX + Col * FCellW;
          YDelta := DY + Row * FCellH;
        end;
      HGEDISP_CENTER:
        begin
          XDelta := DX + (FCellW * (FCols - 1) / 2);
          YDelta := DY + (FCellH * (FRows - 1) / 2);
        end;
    else
      begin
        XDelta := DX;
        YDelta := DY;
      end;
    end;
    FDispArray[Row * FCols + Col].X := XDelta;
    FDispArray[Row * FCols + Col].Y := YDelta;
  end;
end;

procedure THGEDistortionMesh.SetTexture(const Tex: TTEXTURE);
begin
  FQuad.Tex := Tex;
end;

procedure THGEDistortionMesh.SetTextureRect(const X, Y, W, H: Single);
var
  I, J: Integer;
  TW, TH: Single;
begin
  FTX := X;
  FTY := Y;
  FWidth := W;
  FHeight := H;
  if FQuad.Tex<>nil then
  begin
     TW := Texture_GetWidth(FQuad.Tex);
    TH := Texture_GetHeight(FQuad.Tex);


  end else
  begin
    TW := W;
    TH := H;
  end;



  FCellW := W / (FCols - 1);
  FCellH := H / (FRows - 1);

  for J := 0 to FRows - 1 do
    for I := 0 to FCols - 1 do
    begin
      FDispArray[J * FCols + I].TX := (X + I * FCellW) / TW;
      FDispArray[J * FCols + I].TY := (Y + J * FCellH) / TH;

      FDispArray[J * FCols + I].X := I * FCellW;
      FDispArray[J * FCols + I].Y := J * FCellH;
    end;
end;

procedure THGEDistortionMesh.SetZ(const Col, Row: Integer; const Z: Single);
begin
  if (Row < FRows) and (Col < FCols) then
    FDispArray[Row * FCols + Col].Z := Z;
end;

function InvSqrt(const X: Single): Single;
var
  I: Integer;
  F: Single absolute I;
begin
  F := X;
  I := $5f3759df - (I div 2);
  Result := F * (1.5 - 0.4999  * X * F * F);
end;

function HVDot(const A,B: hVector): Single;
begin
  Result := (A.X * B.X) + (A.Y * B.Y);
end;

function VectorMagnitude(v: hVector) : Single;
begin
  result := sqrt((v.x*v.x) + (v.y*v.y));
end;

function VectorDivS(const v: hVector; s: Single) : hVector;
begin
  result.x := v.x/s;
  result.y := v.y/s;

end;

function VectorScale( v: hVector;const Scalar: Single):hVector;
begin
  v.X := v.X * Scalar;
  v.Y := v.Y * Scalar;
  result:= v;
end;
function VectorIncrement( a,b: hVector):hVector;
begin
  a.X := a.X + b.x;
  a.Y := a.Y + b.y;
  result:= a;
end;




function VectorNormalize(const v: hVector) : hVector;
begin
  result := VectorDivS(v,VectorMagnitude(v));
end;


function VectorAngle(a,b: hVector): Single;
var
  S, T: HVector;
begin
    S := a;
    T := b;
    S:=VectorNormalize(s);
    T:=VectorNormalize(t);;
    Result := ArcCos(HVDot(s,T));
  //end else
   // Result := ArcTan2(Y,X);
end;

function VectorAngle1(a: hVector): Single;
var
  S, T: HVector;
begin
Result := ArcTan2(a.y,a.x);
end;

constructor THGEParticleSystem.Create(data:pointer;size:longword;FSprite:THGESprite);
var
  P: PByte;
begin

  if (data = nil) then      Exit;
  P := data;
  Inc(P,4);
  Move(P^,FInfo.Emission,SizeOf(THGEParticleSystemInfo) - 4);
  FInfo.Sprite := FSprite;
  FAge := -2;
  spaw:=0;
end;


constructor THGEParticleSystem.Create(const Filename: String;FSprite:THGESprite);
var
  PSI: pointer;
  P: PByte;
  size:longword;
begin
  Resource_Load(Filename,@size,PSI);
  if (PSI = nil) then      Exit;
  P := PSI;
  Inc(P,4);
  Move(P^,FInfo.Emission,SizeOf(THGEParticleSystemInfo) - 4);
  PSI := nil;
  FInfo.Sprite := FSprite;
  FAge := -2;
  spaw:=0;

end;


constructor THGEParticleSystem.Create(const PSI: THGEParticleSystemInfo);
begin
  Move(PSI.Emission,FInfo.Emission,SizeOf(THGEParticleSystemInfo) - 4);
  FInfo.Sprite := PSI.Sprite;
  FAge := -2;
end;

procedure THGEParticleSystem.Save(const Filename: String);
begin

end;

procedure THGEParticleSystem.Fire;
begin
  if (FInfo.Lifetime = -1) then
    FAge := -1
  else
    FAge := 0;
end;

procedure THGEParticleSystem.FireAt(const X, Y: Single);
begin
  Stop;
  MoveTo(X,Y);
  Fire;
end;

function THGEParticleSystem.GetAge: Single;
begin
  Result := FAge;
end;



function THGEParticleSystem.GetInfo: THGEParticleSystemInfo;
begin
  Result := FInfo;
end;

function THGEParticleSystem.GetParticlesAlive: Integer;
begin
  Result := FParticlesAlive;
end;

procedure THGEParticleSystem.GetPosition(out X, Y: Single);
begin
  X := FLocation.X;
  Y := FLocation.Y;
end;

procedure THGEParticleSystem.GetTransposition(out X, Y: Single);
begin
  X := FTX;
  Y := FTY;
end;


procedure THGEParticleSystem.MoveTo(const X, Y: Single;const MoveParticles: Boolean);
var
  I: Integer;
  DX, DY: Single;
begin
  if (MoveParticles) then begin
    DX := X - FLocation.X;
    DY := Y - FLocation.Y;
    for I := 0 to FParticlesAlive - 1 do begin
      FParticles[I].Location.X := FParticles[I].Location.X + DX;
      FParticles[I].Location.Y := FParticles[I].Location.Y + DY;
    end;
    FPrevLocation.X := FPrevLocation.X + DX;
    FPrevLocation.Y := FPrevLocation.Y + DY;
  end else begin
    if (FAge = -2) then begin
      FPrevLocation.X := X;
      FPrevLocation.Y := Y;
    end else begin
      FPrevLocation.X := FLocation.X;
      FPrevLocation.Y := FLocation.Y;
    end;
  end;
  FLocation.X := X;
  FLocation.Y := Y;
end;

function SetARGBColor(const Col: dword):HColor;
begin
  result.A := (Col shr 24) / 255;
  result.R := ((Col shr 16) and $FF) / 255;
  result.G := ((Col shr 8) and $FF) / 255;
  result.B := (Col and $FF) / 255;
end;

function GetColor(col:HColor):dword;
var
  R, G, B, XH, P1, P2, P3: Single;
  I: Integer;
begin
  Result :=
    Trunc(col.A * 255) shl 24 +
    Trunc(col.R * 255) shl 16 +
    Trunc(col.G * 255) shl 8 +
    Trunc(col.B * 255);
end;


procedure THGEParticleSystem.Render;
var
  I: Integer;
  Col: dword;
  Par: PHGEParticle;
begin
  Par := @FParticles[0];
  Col := FInfo.Sprite.GetColor();
  for I := 0 to FParticlesAlive - 1 do begin
  FInfo.Sprite.RenderEx(Par.Location.X + FTX,Par.Location.Y + FTY,Par.Spin * Par.Age,Par.Size);
  FInfo.Sprite.SetColor(GetColor(Par.Color));
    Inc(Par);
  end;
end;

procedure THGEParticleSystem.Stop(const KillParticles: Boolean);
begin
  FAge := -2;
  if (KillParticles) then
  begin
    FParticlesAlive := 0;
   end;
end;


procedure THGEParticleSystem.Transpose(const X, Y: Single);
begin
  FTX := X;
  FTY := Y;
end;


function RandomS( lo, hi : Single ) : Single;
begin
  result := ( random * ( hi - lo ) + lo );
end;
function RandomI( lo, hi : integer ) : integer;
begin
  result := ( random  ( hi - lo ) + lo );
end;


procedure THGEParticleSystem.Update(const DeltaTime: Single);
var
  I, ParticlesCreated: Integer;
  Ang, ParticlesNeeded: Single;
  Par: PHGEParticle;
  Accel, Accel2, V: hVector;
begin

  if (FAge >= 0) then
  begin
    FAge := FAge + DeltaTime;
    if (FAge >= FInfo.Lifetime) then
      FAge := -2;
  end;

  Par := @FParticles;

  I := 0;
  while (I < FParticlesAlive) do
  begin
    Par.Age := Par.Age + DeltaTime;
    if (Par.Age >= Par.TerminalAge)  then
    begin
      Dec(FParticlesAlive);
      Move(FParticles[FParticlesAlive],Par^,SizeOf(THGEParticle));
      Continue;
    end;

    if (par.Color.a<0.0) then
    begin
    par.Age:=-2;
    end;

    Accel.x := Par.Location.x - FLocation.x;
    Accel.y := Par.Location.y - FLocation.y;




    Accel:=VectorNormalize(Accel);
    Accel2 := Accel;
    Accel.x:=Accel.x*Par.RadialAccel;
    Accel.y:=Accel.y*Par.RadialAccel;


    Ang := Accel2.X;
    Accel2.X := -Accel2.Y;
    Accel2.Y := Ang;




    Accel2.x:=Accel2.x*Par.TangentialAccel;
    Accel2.y:=Accel2.y*Par.TangentialAccel;

    Par.Velocity.x:=Par.Velocity.x+(Accel.x + Accel2.x) * DeltaTime;
    Par.Velocity.y:=Par.Velocity.y+(Accel.y + Accel2.y) * DeltaTime;

    Par.Velocity.Y := Par.Velocity.Y + (Par.Gravity * DeltaTime);

    Par.Location.x:=Par.Location.x+(Par.Velocity.x * DeltaTime);
    Par.Location.y:=Par.Location.y+(Par.Velocity.y * DeltaTime);


    Par.Spin := Par.Spin + (Par.SpinDelta * DeltaTime);

    Par.Size := Par.Size + (Par.SizeDelta * DeltaTime);

    Par.Color.r := Par.Color.r + (Par.ColorDelta.r * DeltaTime);
    Par.Color.g := Par.Color.g + (Par.ColorDelta.g * DeltaTime);
    Par.Color.b := Par.Color.b + (Par.ColorDelta.b * DeltaTime);
    Par.Color.a := Par.Color.a + (Par.ColorDelta.a * DeltaTime);


    Inc(Par);
    Inc(I);
  end;


	// generate new particles
  if (FAge <> -2) then
   begin
    ParticlesNeeded := FInfo.Emission * DeltaTime + FEmissionResidue;
    ParticlesCreated := Trunc(ParticlesNeeded);
    FEmissionResidue := ParticlesNeeded - ParticlesCreated;

    Par := @FParticles[FParticlesAlive];

    for I := 0 to ParticlesCreated - 1 do
    begin
      if (FParticlesAlive >= MAX_PARTICLES) then
        Break;



      Par.Age := 0;
      Par.TerminalAge := RandomS(FInfo.ParticleLifeMin,FInfo.ParticleLifeMax);

      Par.Location.x := FPrevLocation.x + (FLocation.x - FPrevLocation.x)* RandomS(0.0,1.0);
      Par.Location.y := FPrevLocation.y + (FLocation.y - FPrevLocation.y)* RandomS(0.0,1.0);


      Par.Location.X := Par.Location.X + Randoms(-2.0,2.0);
      Par.Location.Y := Par.Location.Y + Randoms(-2.0,2.0);

      Ang := FInfo.Direction - M_PI_2 + randoms(0,FInfo.Spread)- FInfo.Spread / 2;

      if (FInfo.Relative) then
      begin
        V.x := FPrevLocation.x - FLocation.x;
        V.y := FPrevLocation.y - FLocation.y;
        Ang := Ang + (VectorAngle1(V) + M_PI_2);
      end;
      Par.Velocity.X := Cos(Ang);
      Par.Velocity.Y := Sin(Ang);
      Par.Velocity.x:=Par.Velocity.x*RandomS(FInfo.SpeedMin,FInfo.SpeedMax);
      Par.Velocity.y:=Par.Velocity.y*RandomS(FInfo.SpeedMin,FInfo.SpeedMax);


      Par.Gravity := RandomS(FInfo.GravityMin,FInfo.GravityMax);
      Par.RadialAccel :=RandomS(FInfo.RadialAccelMin,FInfo.RadialAccelMax);
      Par.TangentialAccel := RandomS(FInfo.TangentialAccelMin,FInfo.TangentialAccelMax);

      Par.Size := RandomS(FInfo.SizeStart,FInfo.SizeStart+ (FInfo.SizeEnd - FInfo.SizeStart) * FInfo.SizeVar);
      Par.SizeDelta := (FInfo.SizeEnd - Par.Size) / Par.TerminalAge;

      Par.Spin := RandomS(FInfo.SpinStart,FInfo.SpinStart+ (FInfo.SpinEnd - FInfo.SpinStart) * FInfo.SpinVar);
      Par.SpinDelta := (Finfo.SpinEnd - Par.Spin) / Par.TerminalAge;

      Par.Color.R := RandomS(FInfo.ColorStart.R,FInfo.ColorStart.R+ (FInfo.ColorEnd.R - FInfo.ColorStart.R) * FInfo.ColorVar);
      Par.Color.G := RandomS(FInfo.ColorStart.G,FInfo.ColorStart.G+ (FInfo.ColorEnd.G - FInfo.ColorStart.G) * FInfo.ColorVar);
      Par.Color.B := RandomS(FInfo.ColorStart.B,FInfo.ColorStart.B+ (FInfo.ColorEnd.B - FInfo.ColorStart.B) * FInfo.ColorVar);
      Par.Color.A := RandomS(FInfo.ColorStart.A,FInfo.ColorStart.A+ (FInfo.ColorEnd.A - FInfo.ColorStart.A) * FInfo.ColorVar);

      Par.ColorDelta.R := (FInfo.ColorEnd.R - Par.Color.R) / Par.TerminalAge;
      Par.ColorDelta.G := (FInfo.ColorEnd.G - Par.Color.G) / Par.TerminalAge;
      Par.ColorDelta.B := (FInfo.ColorEnd.B - Par.Color.B) / Par.TerminalAge;
      Par.ColorDelta.A := (FInfo.ColorEnd.A - Par.Color.A) / Par.TerminalAge;


      Inc(FParticlesAlive);
      Inc(Par);
    end;
  end;
  FPrevLocation := FLocation;
end;


destructor THGEParticleManager.Destroy;
begin
  KillAll;
  inherited;
end;

procedure THGEParticleManager.GetTransposition(out DX, DY: Single);
begin
  DX := FTX;
  DY := FTY;
end;

function THGEParticleManager.IsPSAlive(const PS: THGEParticleSystem): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to FNPS - 1 do
    if (FPSList[I] = PS) then
      Exit;
  Result := False;
end;

procedure THGEParticleManager.KillAll;
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do
    FPSList[I] := nil;
  FNPS := 0;
end;

procedure THGEParticleManager.KillPS(const PS: THGEParticleSystem);
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do begin
    if (FPSList[I] = PS) then begin
      FPSList[I] := FPSList[FNPS - 1];
      Dec(FNPS);
      Exit;
    end;
  end;
end;

procedure THGEParticleManager.Render;
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do
    FPSList[I].Render;
end;

function THGEParticleManager.SpawnPS(const PSI: THGEParticleSystemInfo; const X,  Y: Single): THGEParticleSystem;
begin
  if (FNPS = MAX_PSYSTEMS) then
    Result := nil
  else begin
    FPSList[FNPS] := THGEParticleSystem.Create(PSI);
    FPSList[FNPS].FireAt(X,Y);
    FPSList[FNPS].Transpose(FTX,FTY);
    Result := FPSList[FNPS];
    Inc(FNPS);
  end;
end;

procedure THGEParticleManager.Transpose(const X, Y: Single);
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do
    FPSList[I].Transpose(X,Y);
  FTX := X;
  FTY := Y;
end;

procedure THGEParticleManager.Update(const DT: Single);
var
  I: Integer;
begin
  I := 0;
  while (I < FNPS) do begin
    FPSList[I].Update(DT);
    if (FPSList[I].GetAge = -2) and (FPSList[I].GetParticlesAlive = 0) then
    begin
      FPSList[I] := FPSList[FNPS - 1];
      Dec(FNPS);
      Dec(I);
    end;
    Inc(I);
  end;
end;

procedure THGECanvas.SetColor(Color: Cardinal);
begin
  FQuad.V[0].Col := Color;
  FQuad.V[1].Col := Color;
  FQuad.V[2].Col := Color;
  FQuad.V[3].Col := Color;
end;

procedure THGECanvas.SetColor(Color1: Cardinal; Color2: Cardinal; Color3: Cardinal; Color4: Cardinal);
begin
  FQuad.V[0].Col := Color1;
  FQuad.V[1].Col := Color2;
  FQuad.V[2].Col := Color3;
  FQuad.V[3].Col := Color4;
end;






procedure THGECanvas.SetPattern(Texture: TTexture; PatternIndex: Integer);
var
  TexX1, TexY1, TexX2, TexY2: Single;
  Left, Right, Top, Bottom: Integer;
  PHeight, PWidth, RowCount, ColCount: Integer;
begin
  if Assigned(Texture) then begin
    FTexWidth := Texture_GetWidth(Texture);
    FTexHeight := Texture_GetHeight(Texture);
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;
  FQuad.Tex := Texture;

  PHeight := Texture.PatternHeight;
  PWidth := Texture.PatternWidth;
  ColCount := Texture.GetWidth(True) div PWidth;
  RowCount := Texture.GetHeight(True) div PHeight;

  if PatternIndex < 0 then PatternIndex := 0;
  if PatternIndex >= RowCount * ColCount then
     PatternIndex := RowCount * ColCount - 1 ;
  Left := (PatternIndex mod ColCount) * PWidth;
  Right := Left + PWidth;
  Top := (PatternIndex div ColCount) * PHeight;
  Bottom := Top + PHeight;
  //FTX := TexX;
  //FTY := TexY;
  FWidth := Right - Left;
  FHeight := Bottom - Top;

  TexX1 := Left / FTexWidth;
  TexY1 := Top / FTexHeight;
  TexX2 := (Left + FWidth) /FTexWidth;
  TexY2 := (Top + FHeight) /FTexHeight;

  FQuad.V[0].TX := TexX1; FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2; FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2; FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1; FQuad.V[3].TY := TexY2;
end;

procedure THGECanvas.SetMirror(MirrorX, MirrorY: Boolean);
var
  TX, TY: Single;
begin
  if (MirrorX) then
  begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[1].TX; FQuad.V[1].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[1].TY; FQuad.V[1].TY := TY;
    TX := FQuad.V[3].TX; FQuad.V[3].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[3].TY; FQuad.V[3].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
  end;

  if(MirrorY) then
  begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[3].TX; FQuad.V[3].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[3].TY; FQuad.V[3].TY := TY;
    TX := FQuad.V[1].TX; FQuad.V[1].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[1].TY; FQuad.V[1].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
  end;
end;

procedure THGECanvas.Draw(Image: TTexture; PatternIndex: Integer; X, Y: Single; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, PatternIndex);
  SetColor($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

    FQuad.V[0].z:=0.5;
    FQuad.V[1].z:=0.5;
    FQuad.V[2].z:=0.5;
    FQuad.V[3].z:=0.5;


  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;
procedure THGECanvas.Draw(Image: TTexture; PatternIndex: Integer; X, Y: Single;color:dword; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, PatternIndex);
  SetColor(color,color,color,color);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single;
      MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;

begin
  SetPattern(Image, PatternIndex);
  SetColor(Color1, Color2, Color3, Color4);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight* ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight* ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawEx(Image: TTexture; PatternIndex: Integer; X: Single; Y: Single; Scale: Single; DoCenter: Boolean; Color: Cardinal; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
         False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawColor1(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
         MirrorX, MirrorY, ARGB(Alpha, Red, Green, Blue), BlendMode);
end;

procedure THGECanvas.DrawColor1(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
    DoCenter: Boolean; Red, Green, Blue, Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
         False, False, ARGB(Alpha, Red, Green, Blue), BlendMode);
end;

procedure THGECanvas.DrawColor1(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Red, Green, Blue, Alpha: Byte; BlendMode: Integer);
begin
   DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
         False, False, ARGB(Alpha, Red, Green, Blue), BlendMode);
end;

procedure THGECanvas.DrawAlpha1(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
         MirrorX, MirrorY, ARGB(Alpha, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawAlpha1(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
    DoCenter: Boolean; Alpha: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;

  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
         False, False, ARGB(Alpha, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawAlpha1(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Alpha: Byte; Blendmode: Integer);
begin
   DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
         False, False, ARGB(Alpha, 255, 255, 255), BlendMode);
end;

procedure THGECanvas.DrawColor4(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
         MirrorX, MirrorY, Color1, Color2, Color3, Color4, BlendMode);
end;

procedure THGECanvas.DrawColor4(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
    DoCenter: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
   DrawEx(Image, PatternIndex, X, Y, CenterPosX, centerPosY, Scale, Scale,
         False, False, Color1, Color2, Color3, Color4, BlendMode);
end;

procedure THGECanvas.DrawColor4(Image: TTexture; PatternIndex: Integer; X, Y: Single;
   Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
begin
  DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
         False, False, Color1, Color2, Color3, Color4, BlendMode);
end;

procedure THGECanvas.DrawAlpha4(Image: TTexture; PatternIndex: Integer; X, Y, ScaleX, ScaleY: Single;
      DoCenter, MirrorX, MirrorY: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, ScaleX, ScaleY,
         MirrorX, MirrorY,
         ARGB(Alpha1,255,255,255), ARGB(Alpha2,255,255,255),ARGB(Alpha3,255,255,255),ARGB(Alpha4,255,255,255), BlendMode);
end;

procedure THGECanvas.DrawAlpha4(Image: TTexture; PatternIndex: Integer; X, Y, Scale: Single;
      DoCenter: Boolean; Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer);
var
  CenterPosX, CenterPosY: Single;
begin
  if DoCenter then
  begin
    CenterPosX := Image.PatternWidth div 2;
    CenterPosY := Image.PatternHeight div 2;
  end
  else
  begin
    CenterPosX := 0;
    CenterPosY := 0;
  end;
  DrawEx(Image, PatternIndex, X, Y, CenterPosX, CenterPosY, Scale, Scale,
         False, False,
         ARGB(Alpha1,255,255,255), ARGB(Alpha2,255,255,255),  ARGB(Alpha3,255,255,255), ARGB(Alpha4,255,255,255), BlendMode);
end;

procedure THGECanvas.DrawAlpha4(Image: TTexture; PatternIndex: Integer; X, Y: Single;
      Alpha1, Alpha2, Alpha3, Alpha4: Byte; BlendMode: Integer);
begin
   DrawEx(Image, PatternIndex, X, Y, 0, 0, 1, 1,
          False, False,
          ARGB(Alpha1,255,255,255),ARGB(Alpha2,255,255,255), ARGB(Alpha3,255,255,255), ARGB(Alpha4,255,255,255), BlendMode);
end;

procedure THGECanvas.Draw4V(Image:TTexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  FQuad.V[0].X := X1; FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2; FQuad.V[1].Y := Y2;
  FQuad.V[2].X := X3; FQuad.V[2].Y := Y3;
  FQuad.V[3].X := X4; FQuad.V[3].Y := Y4;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.Draw4V(Image:TTexture; PatternIndex: Integer; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single;
      MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
begin
  SetPattern(Image, PatternIndex);
  SetColor(Color1, Color2, Color3, Color4);
  FQuad.V[0].X := X1; FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2; FQuad.V[1].Y := Y2;
  FQuad.V[2].X := X3; FQuad.V[2].Y := Y3;
  FQuad.V[3].X := X4; FQuad.V[3].Y := Y4;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawStretch(Image: TTexture; PatternIndex: Integer; X1, Y1, X2, Y2: Single;MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
begin
   SetPattern(Image, PatternIndex);
   SetColor(Color);
   FQuad.V[0].X := X1; FQuad.V[0].Y := Y1;
   FQuad.V[1].X := X2; FQuad.V[1].Y := Y1;
   FQuad.V[2].X := X2; FQuad.V[2].Y := Y2;
   FQuad.V[3].X := X1; FQuad.V[3].Y := Y2;
   SetMirror(MirrorX, MirrorY);
   FQuad.Blend := BlendMode;
   Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawPart(Texture: TTexture; X, Y, SrcX, SrcY, Width, Height,
      ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
var
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;
begin
 // FTX := SrcX;
 // FTY := SrcY;
  FWidth := Width;
  FHeight := Height;

  if Assigned(Texture) then begin
    FTexWidth := Texture_GetWidth(Texture);
    FTexHeight := Texture_GetHeight(Texture);
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;

  FQuad.Tex := Texture;

  TexX1 := SrcX / FTexWidth;
  TexY1 := SrcY / FTexHeight;
  TexX2 := (SrcX + Width) / FTexWidth;
  TexY2 := (SrcY + Height) / FTexHeight;

  FQuad.V[0].TX := TexX1; FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2; FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2; FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1; FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.5;
  FQuad.V[1].Z := 0.5;
  FQuad.V[2].Z := 0.5;
  FQuad.V[3].Z := 0.5;
  SetColor(Color);
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight* ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;
  SetMirror(MirrorX, MirrorY);

  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawPart(Texture: TTexture; X, Y, SrcX, SrcY, Width, Height: Single;
   Color: Cardinal; BlendMode: Integer);
begin
  DrawPart(Texture,X, Y, SrcX, SrcY, Width, Height, 1,1,0,0, False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawRotate(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean;  Color: Cardinal; BlendMode: Integer);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
 // if (VScale=0) then
   // VScale := HScale;
  SetPattern(Image, PatternIndex);
  SetColor(Color);
  TX1 := -CenterX * ScaleX;
  TY1 := -CenterY * ScaleY;
  TX2 := (FWidth - CenterX) * ScaleX;
  TY2 := (FHeight - CenterY) * ScaleY;

  if (Angle <> 0.0) then begin
    CosT := Cos(Angle);
    SinT := Sin(Angle);

    FQuad.V[0].X := TX1 * CosT - TY1 * SinT + X;
    FQuad.V[0].Y := TX1 * SinT + TY1 * CosT + Y;

    FQuad.V[1].X := TX2 * CosT - TY1 * SinT + X;
    FQuad.V[1].Y := TX2 * SinT + TY1 * CosT + Y;

    FQuad.V[2].X := TX2 * CosT - TY2 * SinT + X;
    FQuad.V[2].Y := TX2 * SinT + TY2 * CosT + Y;

    FQuad.V[3].X := TX1 * CosT - TY2 * SinT + X;
    FQuad.V[3].Y := TX1 * SinT + TY2 * CosT + Y;
  end else begin
    FQuad.V[0].X := TX1 + X; FQuad.V[0].Y := TY1 + Y;
    FQuad.V[1].X := TX2 + X; FQuad.V[1].Y := TY1 + Y;
    FQuad.V[2].X := TX2 + X; FQuad.V[2].Y := TY2 + Y;
    FQuad.V[3].X := TX1 + X; FQuad.V[3].Y := TY2 + Y;
  end;
  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);
end;

procedure THGECanvas.DrawRotate(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle: Real; Color: Cardinal; BlendMode: Integer);
begin
  DrawRotate(Image, PatternIndex, X, Y, CenterX, CenterY, Angle, 1, 1,False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawRotateColor4(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY,
      Angle, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color1, Color2, Color3, Color4: Cardinal; BlendMode: Integer);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
 // if (VScale=0) then
   // VScale := HScale;
  SetPattern(Image, PatternIndex);
  SetColor(Color1, Color2, Color3, Color4);
  TX1 := -CenterX * ScaleX;
  TY1 := -CenterY * ScaleY;
  TX2 := (FWidth - CenterX) * ScaleX;
  TY2 := (FHeight - CenterY) * ScaleY;

  if (Angle <> 0.0) then begin
    CosT := Cos(Angle);
    SinT := Sin(Angle);

    FQuad.V[0].X := TX1 * CosT - TY1 * SinT + X;
    FQuad.V[0].Y := TX1 * SinT + TY1 * CosT + Y;

    FQuad.V[1].X := TX2 * CosT - TY1 * SinT + X;
    FQuad.V[1].Y := TX2 * SinT + TY1 * CosT + Y;

    FQuad.V[2].X := TX2 * CosT - TY2 * SinT + X;
    FQuad.V[2].Y := TX2 * SinT + TY2 * CosT + Y;

    FQuad.V[3].X := TX1 * CosT - TY2 * SinT + X;
    FQuad.V[3].Y := TX1 * SinT + TY2 * CosT + Y;
  end else begin
    FQuad.V[0].X := TX1 + X; FQuad.V[0].Y := TY1 + Y;
    FQuad.V[1].X := TX2 + X; FQuad.V[1].Y := TY1 + Y;
    FQuad.V[2].X := TX2 + X; FQuad.V[2].Y := TY2 + Y;
    FQuad.V[3].X := TX1 + X; FQuad.V[3].Y := TY2 + Y;
  end;
  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  Gfx_RenderQuad(FQuad);

end;

procedure THGECanvas.DrawRotateC(Image: TTexture; PatternIndex: Integer; X, Y, Angle,
      ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
begin
  DrawRotate(Image, PatternIndex, X, Y, Image.PatternWidth div 2, Image.PatternHeight div 2,
    Angle, ScaleX, ScaleY, MirrorX, MirrorY, Color, BlendMode);
end;

procedure THGECanvas.DrawRotateC(Image: TTexture; PatternIndex: Integer; X, Y, Angle: Single;
      Color: Cardinal; BlendMode: Integer);
begin
   DrawRotate(Image, PatternIndex, X, Y, Image.PatternWidth div 2, Image.PatternHeight div 2,
    Angle, 1, 1, False, False, Color, BlendMode);
end;

procedure THGECanvas.DrawWaveX(Image: TTexture; X, Y, Width, Height: Integer; Amp, Len,
      Phase: Integer; Color: Cardinal; BlendMode: Integer);
var
  I, J: Integer;
begin
  for J := 0 to Width  do
  begin
    I:=Trunc(J * Image.PatternWidth / Width);
    DrawPart(Image, X + J, Y + Amp * Sin((Phase + J) * PI * Width / Len / 256),
             I, 0, 1, Height, Color, BlendMode);
  end;
end;

procedure THGECanvas.DrawWaveY(Image: TTexture; X, Y, Width, Height: Integer; Amp, Len,
      Phase: Integer; Color: Cardinal; BlendMode: Integer);
var
  I, J: Integer;
begin
  for J := 0 to Height do
  begin
    I:=Trunc(J * Image.PatternHeight / Height);
    DrawPart(Image, X + Amp * Sin((Phase + J) * PI * Height / Len / 256), Y + J,
             0, I, Width, 1, Color, BlendMode);
  end;
end;

procedure THGERect.Clear;
begin
  FClean := True;
end;
procedure THGERect.draw(color:integer);
begin
 Gfx_RenderLine(x1,y1,x2,y1,color);
 Gfx_RenderLine(x1,y2,x2,y2,color);

 Gfx_RenderLine(x1,y1,x1,y2,color);
 Gfx_RenderLine(x2,y1,x2,y2,color);


end;

procedure THGERect.init(const AX1, AY1, AX2, AY2: Single);
begin
  SetRect(AX1,AY1,AX2,AY2);
end;

procedure THGERect.init(const Clean: Boolean);
begin
  SetRect(0,0,0,0);
  FClean := Clean;
end;

procedure THGERect.Encapsulate(const X, Y: Single);
begin
  if (FClean) then begin
    X1 := X;
    X2 := X;
    Y1 := Y;
    Y2 := Y;
    FClean := False;
  end else begin
    if (X < X1) then
      X1 := X;
    if (X > X2) then
      X2 := X;
    if (Y < Y1) then
      Y1 := Y;
    if (Y > Y2) then
      Y2 := Y;
  end;
end;

function THGERect.Intersect(const Rect: THGERect): Boolean;
begin
  Result := (Abs(X1 + X2 - Rect.X1 - Rect.X2) < (X2 - X1 + Rect.X2 - Rect.X1))
        and (Abs(Y1 + Y2 - Rect.Y1 - Rect.Y2) < (Y2 - Y1 + Rect.Y2 - Rect.Y1));
end;

function THGERect.IsClean: Boolean;
begin
  Result := FClean;
end;

procedure THGERect.SetRadius(const X, Y, R: Single);
begin
  X1 := X - R;
  X2 := X + R;
  Y1 := Y - R;
  Y2 := Y + R;
  FClean := False;
end;

procedure THGERect.SetRect(const AX1, AY1, AX2, AY2: Single);
begin
  X1 := AX1;
  Y1 := AY1;
  X2 := AX2;
  Y2 := AY2;
  FClean := False;
end;

function THGERect.TextPoint(const X, Y: Single): Boolean;
begin
  Result := (X >= X1) and (X < X2) and (Y >= Y1) and (Y < Y2);
end;



constructor THGEImages.Create();
begin
  SearchDirty:= False;
end;

destructor THGEImages.Destroy();
begin
  RemoveAll();
end;

function THGEImages.GetItem(Index: Integer): TTexture;
begin
  if (Index >= 0)and(Index < Length(Images)) then
    Result:= Images[Index] else Result:= nil;
end;

function THGEImages.GetItemCount(): Integer;
begin
  Result:= Length(Images);
end;

function THGEImages.IndexOf(Element: TTexture): Integer;
var
 I: Integer;
begin
  Result:= -1;

  for I:= 0 to Length(Images) - 1 do
    if (Images[i] = Element) then
    begin
      Result:= I;
      Break;
    end;
end;

procedure THGEImages.RemoveAll();
begin
  SetLength(Images, 0);
  SearchDirty:= True;
end;

procedure THGEImages.Remove(Index: Integer);
var
 I: Integer;
begin
  if (Index < 0)or(Index >= Length(Images)) then Exit;
  for I:= Index to Length(Images) - 2 do
    Images[I]:= Images[I + 1];
  SetLength(Images, Length(Images) - 1);
  SearchDirty:= True;
end;

procedure THGEImages.InitSearchObjects();
var
 I: Integer;
begin
  if (Length(Images) <> Length(SearchObjects)) then
    SetLength(SearchObjects, Length(Images));
  for I:= 0 to Length(Images) - 1 do
    SearchObjects[I]:= I;
end;

procedure THGEImages.SwapSearchObjects(Index1, Index2: Integer);
var
 Aux: Integer;
begin
  Aux:= SearchObjects[Index1];
  SearchObjects[Index1]:= SearchObjects[Index2];
  SearchObjects[Index2]:= Aux;
end;

function THGEImages.CompareSearchObjects(Obj1, Obj2: TTexture): Integer;
begin
  Result:= CompareText(Obj1.Name, Obj2.Name);
end;

function THGEImages.SplitSearchObjects(Start, Stop: Integer): Integer;
var
  Left, Right: Integer;
  Pivot: TTexture;
begin
  Left := Start + 1;
  Right:= Stop;
  Pivot:= Images[SearchObjects[Start]];
  while (Left <= Right) do
  begin
    while (Left <= Stop)and(CompareSearchObjects(Images[SearchObjects[Left]],
    Pivot) < 0) do Inc(Left);

    while (Right > Start)and(CompareSearchObjects(Images[SearchObjects[Right]],
    Pivot) >= 0) do Dec(Right);

    if (Left < Right) then SwapSearchObjects(Left, Right);
  end;

  SwapSearchObjects(Start, Right);
  Result:= Right;
end;


procedure THGEImages.SortSearchObjects(Start, Stop: Integer);
var
 SplitPt: integer;
begin
  if (Start < Stop) then
  begin
    SplitPt:= SplitSearchObjects(Start, Stop);
    SortSearchObjects(Start, SplitPt - 1);
    SortSearchObjects(SplitPt + 1, Stop);
  end;
end;


procedure THGEImages.UpdateSearchObjects();
begin
  InitSearchObjects();
  SortSearchObjects(0, Length(SearchObjects) - 1);
  SearchDirty:= False;
end;

function THGEImages.IndexOf(const Name: string): Integer;
var
 Lo, Hi, Mid: Integer;
begin
  if (SearchDirty) then UpdateSearchObjects();
  Result:= -1;
  Lo:= 0;
  Hi:= Length(SearchObjects) - 1;
  while (Lo <= Hi) do
  begin
    Mid:= (Lo + Hi) div 2;
    if (CompareText(Images[SearchObjects[Mid]].Name, Name) = 0) then
    begin
      Result:= SearchObjects[Mid];
      Break;
    end;
    if (CompareText(Images[SearchObjects[Mid]].Name, Name) > 0) then
      Hi:= Mid - 1 else Lo:= Mid + 1;
  end;
end;

function THGEImages.GetImage(const Name: string): TTexture;
var
 Index: Integer;
begin
  Index:= IndexOf(Name);
  if (Index <> -1) then Result:= Images[Index] else Result:= nil;
end;


procedure THGEImages.LoadFromFile(FileName: string);
var
  Index: Integer;
begin
  Index:= Length(Images);
  SetLength(Images, Index + 1);
  Images[Index] := Texture_Load(FileName);
 // Images[Index].Name := file_GetName(filename);//ExtractFileName(MidStr(FileName, 0, Length(FileName)-4));
  Images[Index].PatternWidth := Images[Index].GetWidth(True);
  Images[Index].PatternHeight := Images[Index].GetHeight(True);
  SearchDirty:= True;
end;

procedure THGEImages.LoadFromFile(FileName: string; PatternWidth, PatternHeight: Integer);
var
  Index: Integer;
begin
  Index:= Length(Images);
  SetLength(Images, Index + 1);
  Images[Index] := Texture_Load(FileName);
//  Images[Index].Name :=file_GetName(filename);// ExtractFileName(MidStr(FileName, 0, Length(FileName)-4));
  Images[Index].PatternWidth := PatternWidth;
  Images[Index].PatternHeight := PatternHeight;
  SearchDirty:= True;
end;

procedure THGEImages.Load(FileName: string);
var
  Index: Integer;
begin
  Index:= Length(Images);
  SetLength(Images, Index + 1);
  Images[Index] := Texture_Load(FileName);
//  Images[Index].Name := file_GetName(filename);//ExtractFileName(MidStr(FileName, 0, Length(FileName)-4));
  Images[Index].PatternWidth := Images[Index].GetWidth(True);
  Images[Index].PatternHeight := Images[Index].GetHeight(True);
  SearchDirty:= True;
end;

procedure THGEImages.Load(FileName: string; PatternWidth, PatternHeight: Integer);
var
  Index: Integer;
begin
  Index:= Length(Images);
  SetLength(Images, Index + 1);
  Images[Index] := Texture_Load(FileName);
//  Images[Index].Name :=file_GetName(filename);// ExtractFileName(MidStr(FileName, 0, Length(FileName)-4));
  Images[Index].PatternWidth := PatternWidth;
  Images[Index].PatternHeight := PatternHeight;
  SearchDirty:= True;
end;


{  TTileMapSprite  }
procedure THGETileMap.SaveToStream(Stream  : TStream);
var
  i:integer;
  tile:TTile;
begin
  WriteStr(stream,FImage.filename);
  Stream.Write(Width     , SizeOf(integer));
  Stream.Write(Height    , SizeOf(integer));
  Stream.Write(FMapWidth , SizeOf(integer));
  Stream.Write(FMapHeight, SizeOf(integer));
  Stream.Write(FNumTiles , SizeOf(integer));

             // showmessage(inttostr(FMapWidth)+'<>'+inttostr(FMapHeight)+'<>'+inttostr(FNumTiles));


for i:=0 to FNumTiles-1 do
begin
  // Stream.Write(FMap[i]  , SizeOf(TTile));

  tile:=FMap[i];
   // MirrorX, MirrorY: Boolean;
   //  id:integer;
    // Solid:boolean;

  Stream.Write(tile.id  , SizeOf(integer));
  Stream.Write(tile.MirrorX  , SizeOf(boolean));
  Stream.Write(tile.MirrorY  , SizeOf(boolean));
  Stream.Write(tile.Solid  , SizeOf(boolean));



//  Stream.Write(tile  , SizeOf(TTile));

end;


end;
procedure THGETileMap.LoadFromStream(Stream  : TStream);
var
  fname:string;
  i:integer;
  tile:TTile;
begin
  ReadStr(stream,fname);


  FImage:=TTexture.Create(fname);



  Stream.Read(Width  , SizeOf(integer));
  Stream.Read(Height  , SizeOf(integer));
  Stream.Read(FMapWidth  , SizeOf(integer));
  Stream.Read(FMapHeight  , SizeOf(integer));


  SetMapSize(FMapWidth,FMapHeight);
  Stream.Read(FNumTiles  , SizeOf(integer));



 // showmessage(inttostr(FMapWidth)+'<>'+inttostr(FMapHeight)+'<>'+inttostr(FNumTiles));
  

   for i:=0 to FNumTiles-1 do
   begin

  Stream.read(tile.id  , SizeOf(integer));
  Stream.Read(tile.MirrorX  , SizeOf(boolean));
  Stream.Read(tile.MirrorY  , SizeOf(boolean));
  Stream.Read(tile.Solid  , SizeOf(boolean));
  FMap[i]:=tile;

//    Stream.Read(FMap[i]  , SizeOf(TTile));
   end;






   VisibleWidth:= FMapWidth * width;
   VisibleHeight:=FMapHeight * Height;




  FImage.PatternHeight:=Height;
  FImage.PatternWidth:=Width;
  FContX:=  FImage.PatternWidth  div  Width;
  FContY:=  FImage.PatternHeight div  Height;



end;
procedure THGETileMap.SaveToFile(FileName: String);
var Stream: TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmCreate);
  SaveToStream(Stream);
  Stream.Free;
end;

//------------------------------------------------------------------------------
procedure THGETileMap.LoadFromFile(FileName: String);
var Stream: TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmOpenRead);
  LoadFromStream(Stream);
  Stream.Free;
end;


constructor THGETileMap.Create();
begin
     X := 0;
     Y := 0;

     
  Width:=0;
  Height:=0;
  FMapWidth:=0;
  FMapHeight:=0;
  FNumTiles:=0;
  
     FRed := 255;
     FGreen := 255;
     FBlue := 255;
     FAlpha := 255;
     FScaleX := 1;
     FScaleY := 1;
     FDoTile:=false;
     FDoCenter := False;
     FBlendMode := Blend_Default;
     SetMapSize(0, 0);
end;
constructor THGETileMap.Create(worldw,worldh,tilew,tileh:integer;texture:TTexture);
var
  px,py:Integer;
begin


   VisibleWidth:= worldw * tilew;
   VisibleHeight:=worldh * tileh;




   SetMapSize(worldw,worldh);
   FDoTile:=false;


   for px:=0 to worldw-1 do
   for py:=0 to worldh-1 do
   SetTile(px,py,-1);



   FImage:=texture;
   FImage.PatternWidth:=tilew;
   FImage.PatternHeight:=tileh;


   FContX:=  FImage.GetWidth  div  tilew;
   FContY:=  FImage.GetHeight div  tileh;


  // FNumTiles:=FContx*FContY;
   FNumTiles:=worldw*worldh;

   // writeln(fcontx,'<>',fconty,'<>',fnumtiles);


     X := 0;
     Y := 0;

     Width := tilew;
     Height:= tileh;

     FRed := 255;
     FGreen := 255;
     FBlue := 255;
     FAlpha := 255;
     FScaleX := 1;
     FScaleY := 1;
     FDoCenter := False;
     FBlendMode := Blend_Default;


end;



destructor THGETileMap.Destroy;
begin
     SetMapSize(0, 0);


end;


function Mod2(i, i2: Integer): Integer;
begin
     Result := i mod i2;
     if Result < 0 then
        Result := i2 + Result;
end;

procedure THGETileMap.SetViewPort(w,h:integer);
begin
 self.VisibleWidth:=w;
 self.VisibleHeight:=h;
end;

procedure THGETileMap.Render;
var
    c:TTile;
   _x, _y, cx, cy, cx2, cy2,  ChipWidth, ChipHeight: Integer;
   StartX, StartY, EndX, EndY, StartX_, StartY_, OfsX, OfsY, dWidth, dHeight: Integer;
begin
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;

      //  glEnable(GL_BLEND);
    //   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



     ChipWidth  := Width;
     ChipHeight := Height;

     dWidth  := (VisibleWidth + ChipWidth) div ChipWidth + 1;
     dHeight := (VisibleHeight + ChipHeight) div ChipHeight + 1;

     _x :=0;// Trunc(-scrollx - X);
     _y :=0;// Trunc(-scrolly - Y);

     OfsX := _x mod ChipWidth;
     OfsY := _y mod ChipHeight;

     StartX := _x div ChipWidth;
     StartX_ := 0;

     if StartX < 0 then
     begin
          StartX_ := -StartX;
          StartX := 0;
     end;

     StartY := _y div ChipHeight;
     StartY_ := 0;

     if StartY < 0 then
     begin
          StartY_ := -StartY;
          StartY := 0;
     end;

     EndX := Min(StartX + FMapWidth - StartX_, dWidth);
     EndY := Min(StartY + FMapHeight - StartY_, dHeight);

     if FDoTile then
     begin
          for cy := -1 to dHeight do
          begin
               cy2 := Mod2((cy - StartY + StartY_), FMapHeight);
               for cx := -1 to dWidth do
               begin
                    cx2 := Mod2((cx - StartX + StartX_), FMapWidth);
                    c := Cells[cx2, cy2];

                    if c.id >= 0 then
                       FCanvas.DrawColor1(
                       FImage,
                       c.id,
                       cx * ChipWidth + OfsX,
                       cy * ChipHeight + OfsY,
                       FScaleX, FScaleY, FDoCenter,
                       c.MirrorX,c.MirrorY,
                       FRed, FGreen, FBlue, FAlpha, FBlendMode);
                    
               end;
          end;
     end
     else
     begin
          for cy := StartY to EndY - 1 do
          begin
               for cx := StartX to EndX - 1 do
               begin
                  //  c := Cells[cx - StartX + StartX_, cy - StartY + StartY_];

                 c:= GetCell(cx - StartX + StartX_, cy - StartY + StartY_);

                    if c.id >= 0 then

                         FCanvas.DrawColor1(
                         FImage,
                         c.id,
                         cx * ChipWidth + OfsX ,
                         cy * ChipHeight + OfsY,
                         FScaleX, FScaleY, FDoCenter,
                         c.MirrorX, c.MirrorY,
                         FRed, FGreen, FBlue, FAlpha, FBlendmode);
                      
               end;
          end;
     end;
end;


function THGETileMap.GetCell(X, Y: Integer):TTile;
var
  tt:TTile;
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
         Result := FMap[x+ (Y * FMapWidth) ]
        else
         Result := TT;
end;

type
  PBoolean = ^Boolean;

function THGETileMap.GetCollisionMapItem(X, Y: Integer): Boolean;
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
           result:=   FCollisionMap[x+(Y * FMapWidth)]
     else
         Result := False;
end;



procedure THGETileMap.SetCell(X, Y: Integer; Value: TTile);
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
         FMap[X + (Y * FMapWidth)]:=value
end;
procedure THGETileMap.SetTile(X, Y: Integer; Value:integer);
var
  Tile:TTile;
begin
  tile:=GetCell(x,y);
  tile.id:=value;
  SetCell(x,y,tile);
end;

procedure THGETileMap.SetTileFlipX(X, Y: Integer; Value:boolean);
var
  Tile:TTile;
begin
  tile:=GetCell(x,y);
  tile.MirrorX:=value;
  SetCell(x,y,tile);
end;
procedure THGETileMap.SetTileFlipY(X, Y: Integer; Value:boolean);
var
  Tile:TTile;
begin
  tile:=GetCell(x,y);
  tile.MirrorY:=value;
  SetCell(x,y,tile);
end;


procedure THGETileMap.SetCollisionMapItem(X, Y: Integer; Value: Boolean);
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
     FCollisionMap[x+(Y * FMapWidth)]:=value;
end;



procedure THGETileMap.SetMapSize(AMapWidth, AMapHeight: Integer);
begin
     FMapW := Width * AMapWidth;
     FMapH := Height * AMapHeight;

     FMapWidth := AMapWidth;
     FMapHeight := AMapHeight;


     SetLength(FMap, FMapWidth * FMapHeight );
     SetLength(FCollisionMap, FMapWidth * FMapHeight );

    { if (FMapWidth <> AMapWidth) or (FMapHeight <> AMapHeight) then
     begin
          if (AMapWidth <= 0) or (AMapHeight <= 0) then
          begin
               AMapWidth := 0;
               AMapHeight := 0;
          end;

          FMapWidth := AMapWidth;
          FMapHeight := AMapHeight;



          SetLength(FMap, FMapWidth * FMapHeight );
          SetLength(FCollisionMap, FMapWidth * FMapHeight );
     end;}
end;

end.

