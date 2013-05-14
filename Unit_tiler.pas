unit Unit_tiler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,dglopengl, ThdTimer,global,hge,HGEClasses, ComCtrls;

type
  TForm7 = class(TForm)
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;


  gridx,gridy, mx,my:integer;
  TilesAcross:integer;
implementation

uses Unit_tilemap;

{$R *.dfm}

procedure Line(x,y,x2,y2:integer);
begin
  form7.Canvas.MoveTo(x,y);
  form7.Canvas.LineTo(x2,y2);

end;

procedure TForm7.FormShow(Sender: TObject);
begin
             tileimagew:=Width;
             tileimageh:=Height;

TilesAcross:=(tileimagew div tilew) * (tileimageh div tileh);

if (assigned( tileimage)) then
begin
  tileimagew:=tileimage.GetWidth();
  tileimageh:=tileimage.GetHeight();
  TilesAcross:=(tileimagew div tilew);
  Width:=tileimagew;
  Height:=tileimageh;

 // caption:='Tiler - Total of Tiles'+ inttostr(TilesAcross);

end;




end;

procedure TForm7.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
mx:=x;
my:=y;
Repaint;

StatusBar1.Panels[0].Text:='Index:'+IntToStr(TileSelect);


end;

procedure TForm7.FormPaint(Sender: TObject);

var
 finalx,finaly,px,py, x,y:integer;
begin


  // tilew:=24;
  // tileh:=24;


   if mx>=(tileimagew-tilew) then mx:=(tileimagew-tilew);
   if my>=(tileimageh-tileh) then my:=(tileimageh-tileh);


    gridx:=mx div tilew ;
    gridy:=my div tileh ;

//    if gridx>=(tileimagew div tilew)-tilew then gridx:=(tileimagew div tilew)-tilew;
 //   if gridy>=(tileimageh div tileh)-tileh then gridy:=(tileimageh div tileh)-tileh;




     finalx:=gridx mod tilew ;
     finaly:=gridy mod tileh ;

     px:=finalx * tilew;
     py:=finaly * tileh;



    TileSelect:=finalx+finaly*TilesAcross;


      Canvas.Brush.Style:=bsClear;
      Canvas.Pen.Color:=clblack;
      Canvas.Brush.Color:=clblack;
      Canvas.FillRect(ClientRect);
      Canvas.Pen.Style:=psDot;


     // Canvas.Rectangle(0,0,tileimagew,tileimageh);


   Canvas.CopyRect(rect(0,0,form8.image1.Width,form8.image1.Height),form8.image1.Canvas,rect(0,0,form8.image1.Width,form8.image1.Height));
   Canvas.Pen.Color:=clred;

      for x:=0 to (tileimagew div tilew) do
      begin

      line(x*tilew,0,x*tilew,tileimageh);
      end;
      for y:=0 to (tileimageh div tileh)  do
      begin
        line(0,y*tileh,tileimagew,y*tileh);
    //   Gfx_RenderLine(0,y*tileh,tileimagew,y*tileh,gridcolor);
      end;



        Canvas.Pen.Color:=cllime;
       // Canvas.Rectangle(px,py,px+tilew,py+tileh);
       line(px,py,px+tilew,py);
       line(px,py+tileh,px+tilew,py+tileh);

       line(px+tilew,py,px+tilew,py+tileh);
       line(px,py,px,py+tileh);


    //  Gfx_RenderRect(px,py,tilew,tileh,1,0,1);


 // form7.Image1.Canvas.CopyRect(rect(0,0,120,120),image1.Canvas,rect(0,0,120,120));


end;

end.
