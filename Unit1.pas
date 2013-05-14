unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ThdTimer,dglopengl,hge,HGEClasses, ComCtrls,
  Menus, StdCtrls,global,Unit_edit,graphicex,Unit_objects, JvBaseDlg, JvImageDlg, XPMan, ExtDlgs;

type

TwordlMode=(ModeObjects,ModeTiles);


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
    Objects1: TMenuItem;
    Edit1: TMenuItem;
    Images1: TMenuItem;
    Add2: TMenuItem;
    iles1: TMenuItem;
    LoadLayer1: TMenuItem;
    Editor1: TMenuItem;
    EditMode2: TMenuItem;
    Object1: TMenuItem;
    Tiles2: TMenuItem;
    N5: TMenuItem;
    ool1: TMenuItem;
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
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Object1Click(Sender: TObject);
    procedure Tiles2Click(Sender: TObject);
    procedure ool1Click(Sender: TObject);
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

   shiftkey:Boolean=false;
   ctrlkey:Boolean=false;


   worldmode:TwordlMode;

   lastx,lasty:single;
   distx,disty:single;



implementation

uses Unit_grid, Unit_Images, Unit_tiler, Unit_tilemap, Unit_world;

{$R *.dfm}

 {
RC = wglCreateContext( DC1 );
wglMakeCurrent( DC1, RC );
wglMakeCurrent( DC2, RC );
}



procedure TForm1.FormCreate(Sender: TObject);
begin
InitOpenGL;

distx:=0;

disty:=0;

worldmode:=ModeObjects;


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

   wordlw:=40*32;
   worldh:=40*32;
   worldx:=0;//wordlw/2;
   worldy:=0;//worldh/2;

      glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


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
 boundw,boundh:Single;
begin
  FScreenWidth:=panel1.Width;
  FScreenHeight:=panel1.Height;

  wglMakeCurrent(dc1, rc1);

    glClearColor(0,0,0.4,1);
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);




    //boundh:=(Height+gridh)-worldh;

  //  if (worldh<form1.Height) then

  //  boundh:=(worldh+gridh*2)-Form1.Height; //224
 //   boundh:=(worldh+gridh)-Form1.Height;

 //   boundh:=(Form1.Height+gridh);







    if worldy<=-(Height/2) then worldy:=--(Height/2)
    else
    if worldy>=(worldh-(Height/2)) then  worldy:=(worldh-(Height/2));

//    if worldy>=(worldh+(Height-gridh)) then worldy:=(worldh+(Height-gridh));






    if worldx<=-(Width/2) then worldx:=-(Width/2)
    else
    //f worldx>=boundw then  worldx:=boundw;

     if worldx>=(wordlw-(Width/2))  then worldx:=(wordlw-(Width/2));


  //  Caption:=IntToStr(Trunc(worldx))+'<>'+IntToStr(Trunc(wordlw))+'=='+IntToStr(Trunc(worldy))+'<>'+IntToStr(Trunc(boundh));
  //  Caption:=IntToStr(Trunc(worldy))+'<>'+IntToStr(Trunc(boundh))+'<>'+IntToStr(Trunc(worldh));


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



if (worldmode=ModeObjects) then
begin
  objects_mode:=true;
  
case Unit_objects.Form4.RadioGroup1.ItemIndex of
0:begin      //place
if (assigned( globalimage)) and (objects_mode) then
begin
//  DrawEx(globalimage,0,objx-(globalimage.PatternWidth/2),objy-(globalimage.PatternHeight/2),0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);
DrawEx(globalimage,0,objx,objy,0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);

//  DrawEx(globalimage,0,posx_grid,posy_grid,0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);
//  DrawEx(globalimage,0,posx_global,posy_global,0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);


end;
end;
1:begin  //delete
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


end else ///if (worldmode=ModeObjects) ///
if (worldmode=ModeTiles) then
begin
  objects_mode:=false;
  if (assigned(tilemap)) then
    begin
      if (shiftkey) then tilemap.SetTile(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),TileSelect);
      if (mousepress) then tilemap.SetTile(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),TileSelect);
      if (ctrlkey) then tilemap.SetTile(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),-1);
    end;

end;




{
 case form5.RadioGroup2.ItemIndex of
 0://objects
 begin


case Unit_objects.Form4.RadioGroup1.ItemIndex of
0:begin
if (assigned( globalimage)) and (objects_mode) then
begin
//  DrawEx(globalimage,0,objx-(globalimage.PatternWidth/2),objy-(globalimage.PatternHeight/2),0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);
DrawEx(globalimage,0,objx,objy,0,0,objscale,objscale,objflipx,objflipy,$FFFFFFFF,BLEND_DEFAULT);

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
      if (shiftkey) then tilemap.SetTile(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),TileSelect);
     if (mousepress) then tilemap.SetTile(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),TileSelect);
    // if (mousepress) then tilemap.SetTile(Trunc(posx_global),Trunc(posy_global),TileSelect);

    end;

end;
end;

}

    if (assigned(tilemap)) then
    begin
     if form5.CheckBox1.Checked then tilemap.Render;
    end;

       level.Render;


       if (drawgrid) then
       begin
      for x:=0 to (wordlw div gridw) do
      begin
      Gfx_RenderLine(x*gridw,0,x*gridw,worldh,gridcolor);
      end;
     for y:=0 to (worldh div gridh)  do
     begin
      Gfx_RenderLine(0,y*gridh,wordlw,y*gridh,gridcolor);
     end;
     end;
     Gfx_RenderRect(-1,-1,wordlw-1,worldh-1,0,0,1);

    Gfx_RenderRect(objx,objy,gridw,gridh,1,0,1);
   //   Gfx_RenderRect(trunc(tilex_grid+(worldx/tilew)),trunc(tiley_grid+(worldy/tileh)),gridh,1,1,0);

     // Gfx_RenderRect(posx_global,posy_global,gridw,gridh,1,0,1);





      Gfx_EndBatch;
     //   glBindTexture(GL_TEXTURE_2D, 0);
      
    SwapBuffers(DC1);
  //  wglMakeCurrent(0,0);


    System_Loop;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//caption:=inttostr(key);

if (Key=16) then
shiftkey:=True;

if (Key=17)then
ctrlkey:=True;


if (key=37)then worldx:=worldx-gridw;
if key=39 then worldx:=worldx+gridw;

if (key=38)then  worldy:=worldy-gridh;
if (key=40) then worldy:=worldy+gridh;




if (worldmode=ModeTiles) then
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

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var
    len:Single;
begin
mousex:=x;
mousey:=y;
if (mousemidpress) then
begin
distx:=lastx-mousex;
disty:=lasty-mousey;


 len := sqrt(distx * distx + disty * disty);
distx :=distx/ len;
disty :=disty/ len;

worldx:=worldx+distx*5;
worldy:=worldy+disty*5;

end;


end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
lastx:=x;
lasty:=y;

//mousex:=x;
//mousey:=y;

if Button=mbLeft then mousepress:=true;

if Button=mbMiddle  then mousemidpress:=True;




if ( worldmode=ModeObjects) then
begin

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
  mousemidpress:=false;
mousex:=x;
mousey:=y;



if (worldmode=ModeObjects) then
begin

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
end;//ModeObjects;




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

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
shiftkey:=False;
ctrlkey:=False;
end;

procedure TForm1.Object1Click(Sender: TObject);
begin
Object1.Checked:=True;
Tiles2.Checked:=False;
worldmode:=ModeObjects;



end;

procedure TForm1.Tiles2Click(Sender: TObject);
begin
Object1.Checked:=false;
Tiles2.Checked:=true;
worldmode:=ModeTiles;

end;

procedure TForm1.ool1Click(Sender: TObject);
begin
form6.show;
end;

end.
