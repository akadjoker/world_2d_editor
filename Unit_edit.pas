unit Unit_edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Unit_objects,global,hgeclasses;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    edt1: TEdit;
    edt2: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
wordlw:=strtoint(edit1.Text);
worldh:=strtoint(edit2.Text);
gridw:=strtoint(edt1.Text);
gridh:=strtoint(edt2.Text);

close;
end;

procedure TForm5.RadioGroup2Click(Sender: TObject);
begin
    {
case RadioGroup2.ItemIndex of

0:
begin
Unit_objects.Form4.RadioGroup1.Enabled:=true;
objects_mode:=true;

end;
1:
begin
  objects_mode:=false;
Unit_objects.Form4.RadioGroup1.Enabled:=false;

end;
2:
begin
  objects_mode:=false;
Unit_objects.Form4.RadioGroup1.Enabled:=false;


end;
end;
}
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
wordlw:=strtoint(edit1.Text);
worldh:=strtoint(edit2.Text);
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
edit1.Text:=inttostr(wordlw);
edit2.Text:=inttostr(worldh);

edt1.Text:=inttostr(gridw);
edt2.Text:=inttostr(gridh);

end;

procedure TForm5.Button3Click(Sender: TObject);
begin
    if (assigned(tilemap)) then
    begin
       tilemap.SaveToFile('E:\proj\world_2d_editor\Tiles\savemap.txt');

    end;

end;

procedure TForm5.Button4Click(Sender: TObject);
begin
    if (assigned(tilemap)) then
    begin
      tilemap.Destroy;

    end;
    tilemap:=THGETileMap.Create;
    tilemap.LoadFromFile('E:\proj\world_2d_editor\Tiles\savemap.txt');


end;

procedure TForm5.btn1Click(Sender: TObject);
begin
gridw:=strtoint(edt1.Text);
gridh:=strtoint(edt2.Text);

end;

procedure TForm5.CheckBox2Click(Sender: TObject);
begin
drawgrid:=CheckBox2.Checked;
end;

end.

