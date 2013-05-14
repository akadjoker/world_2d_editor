unit global;

interface
uses math,windows,SYSUTILS,CLASSES,HGE,HGEClasses,DGLOPENGL;

  const
  CRLF = #13#10;

type

GMObject=class
 protected
 PRIVATE
 PUBLIC
   isselect:boolean;
   FBound:THGERect;
   Width,Height,HScale,VScale,depth,red,green,blue,alpha,angle,x,y:single;
   layer,blend:integer;
   PivotX,PivotY:single;
   Active,FlipX,FlipY:boolean;
   FSprite:THGESprite;
   gameid:string;
   id:integer;

    constructor Create(const Texture: TTEXTURE;TexX, TexY, W, H: Single;name:string);
    destructor Destroy;
    procedure Render;

    function Select(x,y:single):boolean;

 END;

    THGEGMObjectList = class( TList )
  protected
    function Get( Index : Integer ) : GMObject;
    procedure Put( Index : Integer; Item : GMObject );
    function IndexOf(Item: Pointer): Integer; overload;
  public
     function Find   (const Name: string): GMObject;
     function IndexOf(const Name: String): Integer;     overload;
     property Items[ Index : Integer ] : GMObject read Get write Put; default;
  end;
    THGEImageList = class( TList )
  protected
    function Get( Index : Integer ) : TTexture;
    procedure Put( Index : Integer; Item : TTexture );
    function IndexOf(Item: Pointer): Integer; overload;
  public
     function Find   (const Name: string): TTexture;
     function IndexOf(const Name: String): Integer;     overload;
    property Items[ Index : Integer ] : TTexture read Get write Put; default;
  end;

  TLevel=Class
  private

  NeedSort:boolean;

  procedure Sort;

  public
      GameObjects:THGEGMObjectList;
      Images : THGEImageList;

     procedure ClearImages;
    procedure ClearGameObjects;

    procedure AddObject( Item : GMObject );
    procedure RemoveObject( Item : GMObject );

   function GetImage(index:integer):TTexture;overload;
   function GetImage(name:string):TTexture;overload;


    procedure RemoveImage( Item : TTexture );
    procedure AddImage( Item : TTexture );

    procedure LoadImage(fname:string);

    function CreateObj(img:TTexture;x,y:single;name:string):GMObject;

    
    Procedure LoadFromStream(Stream  : TStream);
    Procedure SaveToStream  (Stream  : TStream);
    Procedure LoadFromFile  (FileName: String);
    Procedure SaveToFile    (FileName: String);

    procedure SaveXML(fname:string);

    function Select(x,y:integer):GMObject;


    constructor Create();
    destructor Destroy;
    procedure Render;

  end;


var
      FScreenWidth,FScreenHeight:integer;
    glenabled:boolean=false;
    scrolx,scroly:single;
   worldscale,worldx,worldy:single;
   wordlw,worldh:integer;
   gridw,gridh:integer;
   mousex,mousey:integer;
   keymovex,keymovey:single;
       level:TLevel;

       drawgrid:Boolean=True;
       snap_objects:boolean=true;
       gridcolor:cardinal;
       gridr,gridg,gridb:single;
//       image_index:integer;

       posx_global:single;
       posy_global:single;

       posx_grid:single;
       posy_grid:single;
       globalimage:TTexture=nil;
       tilex_grid:single;
       tiley_grid:single;
       tilefile:string;



       objx,objy,objscale,objangle:single;
       objflipx,objflipy:boolean;

       objects_mode:boolean=true;

       select_obj:GMObject;
       mousepress:boolean;
       mousemidpress:Boolean;


       tilepicture:Tbitmap;
             tileimage:TTexture=nil;
             tilew,tileh:integer;
             TileSelect,TilesAcross,tileimagew,tileimageh:integer;

             tilemap:THGETileMap;


   procedure Defaults;
   procedure scroll_wordl(room_viewport_hborder,room_viewport_vborder,room_viewport_width,room_viewport_height,tu_viewport_instx,tu_viewport_insty:single) ;
   procedure DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);


       procedure  Setup2DScene( AWidth,  AHeight:integer; ANearZ,  AFarZ:single );
 procedure SetClipping(X, Y, W, H: Integer);
 procedure SetTransform(scale,x,y,rot:single);



implementation
uses glutils,Unit_objects;



procedure DrawEx(Image: TTexture; PatternIndex: Integer; X, Y, CenterX, CenterY, ScaleX, ScaleY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);
var
      FQuad: THGEQuad;
      FWidth, FHeight: Single;
      FTexWidth, FTexHeight: Integer;


procedure SetMirror(MirrorX, MirrorY: Boolean);
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


procedure SetPattern(Texture: TTexture; PatternIndex: Integer);
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

procedure SetColor(Color: Cardinal);
begin
  FQuad.V[0].Col := Color;
  FQuad.V[1].Col := Color;
  FQuad.V[2].Col := Color;
  FQuad.V[3].Col := Color;
end;

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

procedure Defaults;
begin
  gridcolor:=$FFFFFFFF;
  gridw:=32;
  gridh:=32;
     worldscale:=1;
   worldx:=0;
   worldy:=0;
   wordlw:=5000;
   worldh:=5000;
    keymovex:=0;
    keymovey:=0;
//    image_index:=0;
    objx:=0;
    objy:=0;
    objscale:=1;
    objangle:=0;
    tilew:=24;
    tileh:=24;


end;

    procedure  Setup2DScene( AWidth,  AHeight:integer; ANearZ,  AFarZ:single );
begin
  glDisable( GL_DEPTH_TEST );
  glMatrixMode( GL_PROJECTION );
  glLoadIdentity();
  glOrtho( 0, AWidth, AWidth, 0, ANearZ, AFarZ);
  glMatrixMode( GL_MODELVIEW );
  glLoadIdentity();
  glViewPort( 0, 0, AWidth, AWidth );
end;


  procedure SetClipping(X, Y, W, H: Integer);
  begin
  glViewPort(x,y,w,h);
  end;
 procedure SetTransform(scale,x,y,rot:single);
begin
    glMatrixMode( GL_PROJECTION );
    glLoadIdentity();
    glViewport(0,0,trunc(FScreenWidth), trunc(FScreenHeight));
    glOrtho( 0, FScreenWidth, FScreenHeight, 0, -100.0, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glScalef(scale,scale,1.0);
    glTranslatef(-x + (FScreenWidth/2.0),-y + (FScreenHeight/2.0),0.0);
    glRotatef(rot,0.0,0.0,1.0);
    glTranslatef(-(FScreenWidth/2.0),-(FScreenHeight/2.0),0.0);
end;

procedure scroll_wordl(room_viewport_hborder,room_viewport_vborder,room_viewport_width,room_viewport_height,tu_viewport_instx,tu_viewport_insty:single) ;
var
  _h,_v:single;
begin


    _h := min(room_viewport_hborder, room_viewport_width / 2);
		_v := min(room_viewport_vborder, room_viewport_height / 2);
		// hborder:
		if (tu_viewport_instx < worldx + _h)then worldx := tu_viewport_instx - _h;
		if (tu_viewport_instx > worldx + room_viewport_width - _h) then worldx := tu_viewport_instx - room_viewport_width + _h;
		// vborder:
		if (tu_viewport_insty < worldy + _v) then worldy := tu_viewport_insty - _v;
		if (tu_viewport_insty > worldy + room_viewport_height - _v)then worldy:= tu_viewport_insty - room_viewport_height + _v;
		// limits:
	worldx := max(0, min(worldx, wordlw - room_viewport_width)) ;
		worldy := max(0, min(worldy, worldh - room_viewport_height)) ;
end;

function CompareLayer( Item1, Item2 : GMObject ) : Integer;
begin
  if Item1.layer < Item2.layer then
    Result := -1
  else if Item1.layer > Item2.layer then
    Result := 1
  else
    Result := 0;
end;

constructor TLevel.Create();
begin

  Images := THGEImageList.Create;
  GameObjects:=THGEGMObjectList.Create;
  NeedSort:=false;
end;
destructor TLevel.Destroy;
begin
  ClearImages;
  ClearGameObjects;
  GameObjects.Destroy;
  Images.Destroy;

end;
procedure TLevel.Render;
var
  i, max : integer;
  TempSpr: GMObject;
begin

  if GameObjects.Count > 0 then
  begin
    i := 0;
    max := GameObjects.Count;
    repeat
      if (GameObjects[ i ].Active=false) then
      begin
        TempSpr := GameObjects[ i ];
        RemoveObject( TempSpr );
        TempSpr.Destroy;
        dec( Max );
      end
      else
      begin
        GameObjects[ i ].Render;
        inc( i );
      end;
    until i >= Max;
  end;
  if NeedSort then
  begin
    Sort;
    NeedSort := false;
  end;


end;

procedure TLevel.Sort;
begin
  GameObjects.Sort( @CompareLayer );
end;

procedure TLevel.RemoveObject( Item : GMObject );
begin
GameObjects.Remove(Item)
end;


procedure TLevel.ClearGameObjects;
var
  TempSpr : GMObject;
begin
  while GameObjects.Count > 0 do
  begin
    TempSpr := GameObjects[ 0 ];
    RemoveObject( TempSpr );
    TempSpr.Free;
  end;
  GameObjects.Clear;
end;


procedure TLevel.LoadImage(fname:string);
var
  tex:TTexture;
begin
  tex:=TTexture.Create(fname);
  tex.name:=file_GetName(fname);
  globalimage:=tex;
  AddImage(tex);
end;
procedure TLevel.SaveToStream(Stream  : TStream);
var
  i:integer;
   obj:GMObject;
   tilemapexits:boolean;
begin


  Stream.Write(wordlw  , SizeOf(integer));
  Stream.Write(worldh  , SizeOf(integer));
  Stream.Write(gridw  , SizeOf(integer));
  Stream.Write(gridh  , SizeOf(integer));
  Stream.Write(Images.Count , SizeOf(integer));
  for i:=0 to Images.Count-1 do
  begin
    WriteStr(Stream,Images.Items[i].filename);
    WriteStr(Stream,Images.Items[i].name);
  end;

  Stream.Write( GameObjects.Count , SizeOf(integer));
  for i:=0 to GameObjects.Count-1 do
  begin
    obj:=GameObjects.Items[i];
    WriteStr(Stream,obj.gameid);
    Stream.Write(obj.id  , SizeOf(integer));
    Stream.Write(obj.layer  , SizeOf(integer));
    Stream.Write(obj.x  , SizeOf(single));
    Stream.Write(obj.y  , SizeOf(single));
    Stream.Write(obj.angle  , SizeOf(single));
    Stream.Write(obj.HScale  , SizeOf(single));
    Stream.Write(obj.VScale  , SizeOf(single));
    Stream.Write(obj.Width  , SizeOf(single));
    Stream.Write(obj.Height  , SizeOf(single));
    Stream.Write(obj.PivotX  , SizeOf(single));
    Stream.Write(obj.PivotY  , SizeOf(single));
    Stream.Write(obj.FlipX  , SizeOf(boolean));
    Stream.Write(obj.FlipY  , SizeOf(boolean));
  end;
     tilemapexits:=false;
    if (assigned(tilemap)) then
    begin
       tilemapexits:=true;
       Stream.Write(tilemapexits  , SizeOf(boolean));
       tilemap.SaveToStream(Stream);
    end else Stream.Write(tilemapexits  , SizeOf(boolean));


end;
procedure TLevel.LoadFromStream(Stream  : TStream);
var
  i:integer;
   obj:GMObject;
   imgcount:integer;
   objcount:INTEGER;
   gameid,imagestr,imgname:string;
   tex:TTexture;
   tilemapexits:boolean;
begin


  Stream.Read(wordlw  , SizeOf(integer));
  Stream.Read(worldh  , SizeOf(integer));
  Stream.Read(gridw  , SizeOf(integer));
  Stream.Read(gridh  , SizeOf(integer));
  Stream.Read(imgcount , SizeOf(integer));
  for i:=0 to imgcount-1 do
  begin
      ReadStr(Stream,imagestr);
      ReadStr(Stream,imgname);
      LoadImage(imagestr);
  end;

  Stream.Read( objcount , SizeOf(integer));
  for i:=0 to objcount-1 do
  begin
    
    ReadStr(Stream,imgname);
    tex:=GetImage(imgname);
    obj:=GMObject.Create(tex,0,0,tex.PatternWidth,tex.PatternHeight,imgname);
    Stream.Read(obj.id  , SizeOf(integer));
    Stream.Read(obj.layer  , SizeOf(integer));
    Stream.Read(obj.x  , SizeOf(single));
    Stream.Read(obj.y  , SizeOf(single));
    Stream.Read(obj.angle  , SizeOf(single));
    Stream.Read(obj.HScale  , SizeOf(single));
    Stream.Read(obj.VScale  , SizeOf(single));
    Stream.Read(obj.Width  , SizeOf(single));
    Stream.Read(obj.Height  , SizeOf(single));
    Stream.Read(obj.PivotX  , SizeOf(single));
    Stream.Read(obj.PivotY  , SizeOf(single));
    Stream.Read(obj.FlipX  , SizeOf(boolean));
    Stream.Read(obj.FlipY  , SizeOf(boolean));
    AddObject(obj);
  end;


       Stream.Read(tilemapexits  , SizeOf(boolean));
       if (tilemapexits) then
       begin
       tilemap:=THGETileMap.Create;
       tilemap.LoadFromStream(Stream);
       end;


end;
procedure TLevel.SaveToFile(FileName: String);
var Stream: TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmCreate);
  SaveToStream(Stream);
  Stream.Free;
end;

Function FtoS(f:single):String;
Begin
  Str(f:4:3, Result);
End;

Function IntToStr(n : Integer):String;
Begin
  Str(n, Result);
End;
Function bolToStr(n : boolean):String;
Begin
  if n then result:='True' else result :='False';
End;


Function StoI(s:String):Integer;
Var
  e:Integer;
Begin
  Val(s, Result, e);
End;


procedure TLevel.SaveXML(fname:string);
var

s:string;
  str:Tstringlist;
count, x,y, i:integer;
   obj:GMObject;
begin
  str:=Tstringlist.Create;

 // str.Add('<?xml version="1.0"?>');

str.Add(' <!--This Document is generated by No Limites 2D World Editor By Luis Santos AKA Djoker!-->');

//  str.Add('<level width="'+inttostr(wordlw)+'" height="'+inttostr(worldh)+' gridw="'+inttostr(gridw)+'" gridh="'+inttostr(gridh)+'"">');
str.Add('<level>');

{
str.Add('<Bounds '+
'WorldWidth="'+inttostr(wordlw)+'" '+
'WorldHeight="'+inttostr(worldh)+'" '+
'GridWidth="'+inttostr(gridw)+'" '+
'GridHeight="'+inttostr(gridh)+'"/>');
 }


str.Add('<LevelDefaultSize>');
str.Add('<WorldWidth>'+inttostr(wordlw)+'</WorldWidth>');
str.Add('<WorldHeight>'+inttostr(worldh)+'</WorldHeight>');
str.Add('<GridWidth>'+inttostr(gridw)+'</GridWidth>');
str.Add('<GridHeight>'+inttostr(gridh)+'</GridHeight>');
str.Add('</LevelDefaultSize>');




    str.Add('<Images>');
  for i:=0 to Images.Count-1 do
  begin
     // str.Add('<Path>'+Images.Items[i].filename+'</Path>');
     // str.Add('<Name>'+Images.Items[i].name+'</Name>');
      str.Add('<Image '+
      'Name="'+Images.Items[i].name+'" '+
      'Full="'+Images.Items[i].filename+'"/>');


  end;
    str.Add('</Images>');


str.Add('<Entities>');

  for i:=0 to GameObjects.Count-1 do
  begin
    obj:=GameObjects.Items[i];

   // str.Add('<'+obj.gameid+' '+
   str.Add('<Object '+
    'Name="'+obj.gameid+'" '+
    'Id="'+inttostr(obj.id)+'" '+
    'Layer="'+inttostr(obj.layer)+'" '+
    'X="'+ftos(obj.x)+'" '+
    'Y="'+ftos(obj.y)+'" '+
    'Angle="'+ftos(obj.angle)+'" '+
    'HScale="'+ftos(obj.HScale)+'" '+
    'VScale="'+ftos(obj.VScale)+'" '+
    'PivotX="'+ftos(obj.PivotX)+'" '+
    'PivotY="'+ftos(obj.PivotY)+'" '+
    'FlipX="'+boltostr(obj.FlipX)+'" '+
    'FlipY="'+boltostr(obj.FlipY)+'"/>');

  end;

str.Add('</Entities>');

   if (assigned(tilemap)) then
    begin
    str.Add('<TileMap>');

    {
    str.Add('<Setup '+
    'MapImage="'+tilemap.FImage.name+'" '+
    'MapWidth="'+inttostr(tilemap.fMapWidth)+'" '+
    'MapHeight="'+inttostr(tilemap.fMapHeight)+'" '+
    'TileWidth="'+inttostr(tilemap.Width)+'" '+
    'TileHeight="'+inttostr(tilemap.Height)+'"/>');
     }



    str.Add('<Map>');
    str.Add('<MapImage>'+tilemap.FImage.filename+'</MapImage>');
    str.Add('<MapWidth>'+inttostr(tilemap.fMapWidth)+'</MapWidth>');
    str.Add('<MapHeight>'+inttostr(tilemap.fMapHeight)+'</MapHeight>');
    str.Add('<TileWidth>'+inttostr(tilemap.Width)+'</TileWidth>');
    str.Add('<TileHeight>'+inttostr(tilemap.Height)+'</TileHeight>');
    str.Add('</Map>');



    str.Add('<Tileset>');


        count:=0;
        s:='';

       for y:=0 to  tilemap.FMapHeight-1 do
       begin
       if (y>0) then          s:=S+CRLF;
       for x:=0 to  tilemap.FMapWidth-1 do
       begin
           S := S+inttostr(tilemap.GetCell(x,y).id)+',';
        end;
      end;


     {
    for i:=0 to tilemap.FNumTiles-1 do
    begin
    S := S+inttostr(tilemap.FMap[i].id)+',';
    Inc(Count);
    If (Count>tilemap.FMapWidth) Then
    Begin
    s:=S+CRLF;
    Count:=0;
    End;
    end;
    }

     S := copy(S, 1, Pred(Length(S)));
     str.Add(s);
     str.Add('</Tileset>');
     str.Add('</TileMap>');
    end;



  str.Add('</level>');




  str.SaveToFile(fname);
  str.Destroy;
end;


//------------------------------------------------------------------------------
procedure TLevel.LoadFromFile(FileName: String);
var Stream: TFileStream;
begin
  Stream:= TFileStream.Create(FileName, fmOpenRead);
  LoadFromStream(Stream);
  Stream.Free;
end;


procedure TLevel.ClearImages;
var
  TempSpr : TTexture;
begin
  while Images.Count > 0 do
  begin
    TempSpr := Images[ 0 ];
    RemoveImage( TempSpr );
    TempSpr.Destroy;


  end;
  Images.Clear;
end;

function TLevel.GetImage(name:string):TTexture;
begin
result:=images.Find(name);
end;

function TLevel.GetImage(index:integer):TTexture;
begin
result:=images.Get(index)
end;



procedure TLevel.AddImage( Item : TTexture );
begin
Images.Add( Item );
end;


procedure TLevel.RemoveImage( Item : TTexture );
begin
  Images.Remove( Item );
end;

procedure TLevel.AddObject( Item : GMObject );
begin
GameObjects.Add(Item);
NeedSort:=true;
end;
function TLevel.CreateObj(img:TTexture;x,y:single;name:string):GMObject;
var
 obj:GMObject;
begin
 obj:=GMObject.Create(img,0,0,img.PatternWidth,img.PatternHeight,name);
 obj.id:=GameObjects.Count+1;
 obj.Width:=img.PatternWidth;
 obj.Height:=img.PatternHeight;
 obj.PivotX:= obj.Width /2;
 obj.PivotY:=obj.Height/2;
 obj.x:=x+obj.PivotX;
 obj.y:=y+obj.PivotY;

 result:=obj;
 AddObject(obj);
end;
function TLevel.Select(x,y:integer):GMObject;
var
  i, max : integer;
  TempSpr: GMObject;
begin
  result:=nil;
  if GameObjects.Count > 0 then
  begin
    i := 0;
    max := GameObjects.Count;
    repeat
              TempSpr := GameObjects[ i ];
           //   TempSpr.isselect:=false;
              if (TempSpr.Select(x,y)) then
              begin
                result:=TempSpr;
             //   result.isselect:=true;
                break;
              end;
        inc( i );
    until i >= Max;
  end;
end;

//*******************************************************    


function THGEGMObjectList.Get( Index : Integer ) : GMObject;
begin
  Result := inherited Get( Index );
end;

procedure THGEGMObjectList.Put( Index : Integer; Item : GMObject );
begin
  inherited Put( Index, Item );
end;
function THGEGMObjectList.IndexOf(Item: Pointer): Integer;
begin
  Result:=inherited IndexOf(Item);
end;
function THGEGMObjectList.IndexOf(const Name: String): Integer;
var x: Integer;
begin
  Result:=-1;
  For x:=0 to Count - 1 do
  IF Items[x].GameId = Name then begin
    Result:=x;
    Exit;
  end;
end;
function THGEGMObjectList.Find(const Name: string): GMObject;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then begin
    result:=Items[Index]
  end else begin
    raise Exception.Create('Game Object '+Name+ ' not found ');
  end;
end;

//***********************
constructor GMObject.Create(const Texture: TTEXTURE;TexX, TexY, W, H: Single;name:string);
begin
 HScale:=1;
 VScale:=1;
 red:=1;
 green:=1;
 blue:=1;
 alpha:=1;
 angle:=0;
 PivotX:=0;
 PivotY:=0;
 depth:=0.0;
 layer:=0;
 blend:=BLEND_DEFAULT;
 GameId:=name;
 Active:=true;
 FSprite:=THGESprite.Create(texture,Texx,Texy,w,h);
 isselect:=false;


    end;
    destructor GMObject.Destroy;
    begin
         FSprite.Destroy;
    end;
    procedure GMObject.Render;
    var
      rotation:Single;
    begin
      rotation:=angle/180 * pi;
    FSprite.SetHotSpot(Pivotx,Pivoty);
    FSprite.SetFlip(FlipX,FlipY);
    FSprite.RenderEx(x,y,rotation,HScale,VScale);
    FSprite.GetBoundingBoxEx(x,y,rotation,HScale,VScale,FBound);
    if isselect then
    FBound.draw($FF00FFFF);


    end;
    function GMObject.Select(x,y:single):boolean;
    begin
      result:=FBound.TextPoint(x,y);
    end;


    

// THGESpriteList ---------------------------------------
function THGEImageList.Get( Index : Integer ) : TTexture;
begin
  Result := inherited Get( Index );
end;

procedure THGEImageList.Put( Index : Integer; Item : TTexture );
begin
  inherited Put( Index, Item );
end;
function THGEImageList.IndexOf(Item: Pointer): Integer;
begin
  Result:=inherited IndexOf(Item);
end;
function THGEImageList.IndexOf(const Name: String): Integer;
var x: Integer;
begin
  Result:=-1;
  For x:=0 to Count - 1 do
  IF Items[x].Name = Name then begin
    Result:=x;
    Exit;
  end;
end;
function THGEImageList.Find(const Name: string): TTexture;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then begin
    result:=Items[Index]
  end else begin
    raise Exception.Create('Image  '+Name+ ' not found ');
  end;
end;


end.
