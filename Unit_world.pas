unit Unit_world;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,global, StdCtrls;

type
  TForm6 = class(TForm)
    btn1: TButton;
    grp1: TGroupBox;
    btn2: TButton;
    edt1: TEdit;
    lbl1: TLabel;
    btn3: TButton;
    edt2: TEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    edt3: TEdit;
    lbl4: TLabel;
    edt4: TEdit;
    lbl5: TLabel;
    edt5: TEdit;
    btn4: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  tileindex:Integer;

implementation

{$R *.dfm}

procedure TForm6.btn1Click(Sender: TObject);
begin
close;

end;

procedure TForm6.btn2Click(Sender: TObject);
var
  x,y:Integer;
begin
if (not assigned(tilemap)) then Exit;
tileindex:=strtoint(edt1.text);

for x:=StrToInt(edt2.Text) to StrToInt(edt3.Text) do
for y:=StrToInt(edt4.Text) to StrToInt(edt5.Text) do
tilemap.SetTile(x,y,tileindex);


end;

procedure TForm6.btn3Click(Sender: TObject);
var
  x,y:Integer;
begin
    if (not assigned(tilemap)) then Exit;
for x:=0 to tilemap.FMapWidth-1 do
for y:=0 to tilemap.FMapHeight-1 do
tilemap.SetTile(x,y,-1);


end;

procedure TForm6.btn4Click(Sender: TObject);
var
  x,y:Integer;
begin
    if (not assigned(tilemap)) then Exit;

tileindex:=strtoint(edt1.text);
for x:=0 to tilemap.FMapWidth-1 do
for y:=0 to tilemap.FMapHeight-1 do
tilemap.SetTile(x,y,tileindex);

end;

procedure TForm6.FormShow(Sender: TObject);
begin
  edt2.Text:='0';
  edt2.Text:='0';
  edt3.Text:='0';
  edt4.Text:='0';
  if (not assigned(tilemap)) then Exit;

  edt3.Text:=IntToStr(tilemap.FMapWidth);
  edt5.Text:=IntToStr(tilemap.FMapHeight);
end;

end.
