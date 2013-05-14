unit Unit_objects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,global, Grids,
  ExtDlgs, JvExForms, JvBaseThumbnail, JvThumbViews,dglopengl, math,
  JvExExtCtrls, JvExtComponent, JvPanel, JvOfficeColorPanel,hge, JvBaseDlg,
  JvSelectDirectory;

type
  TForm4 = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    CheckBox3: TCheckBox;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    JvOfficeColorPanel1: TJvOfficeColorPanel;
    btn1: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure JvThumbView1Change(Sender: TObject);
      procedure Button2Click(Sender: TObject);
    procedure JvOfficeColorPanel1ColorButtonClick(Sender: TObject);
    procedure JvOfficeColorPanel1ColorChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;


var
  Form4: TForm4;

implementation

uses Unit1;


{$R *.dfm}



procedure TForm4.CheckBox1Click(Sender: TObject);
begin
objflipx:=checkbox1.Checked;
if (assigned(select_obj)) then
begin
  select_obj.FlipX:=objflipx;

end;

end;

procedure TForm4.CheckBox2Click(Sender: TObject);
begin
objflipy:=checkbox2.Checked;
if (assigned(select_obj)) then
begin
  select_obj.FlipY:=objflipy;

end;

end;

procedure TForm4.ScrollBar1Change(Sender: TObject);
begin
objangle:=ScrollBar1.Position;

   label1.Caption:=inttostr(trunc((objangle)));
if (assigned(select_obj)) then
begin
  select_obj.angle:=objangle;

end;


end;

procedure TForm4.CheckBox3Click(Sender: TObject);
begin
snap_objects:=checkbox3.Checked;
end;

procedure TForm4.JvThumbView1Change(Sender: TObject);
begin
//image_index:=JvThumbView1.Selected+1;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
{
OpenPictureDialog1.InitialDir:= ExtractFilePath(ParamStr(0))+'Sprites';

if OpenPictureDialog1.Execute then
begin
  level.LoadImage(OpenPictureDialog1.FileName);
  JvThumbView1.AddFromFile(OpenPictureDialog1.FileName);
  glBindTexture(GL_TEXTURE_2D, 0);
end;
}
end;

procedure TForm4.JvOfficeColorPanel1ColorButtonClick(Sender: TObject);
var
  color:cardinal;
  r,g,b:byte;
begin
color:=  JvOfficeColorPanel1.SelectedColor;
gridcolor:=ARGB(255,b,g,r);

end;

procedure TForm4.JvOfficeColorPanel1ColorChange(Sender: TObject);
var
  color:cardinal;
  r,g,b:byte;
begin
color:=  JvOfficeColorPanel1.SelectedColor;
COLOR_UnRGB(color,r,g,b);
gridcolor:=ARGB(255,b,g,r);


       gridr:=r/255;
       gridg:=g/255;
       gridb:=b/255;

end;


procedure FileSearch(const PathName, FileName : string) ;
var
 Rec : TSearchRec;
 ffinal,Path : string;

 begin
 Path := IncludeTrailingPathDelimiter(PathName) ;
 if FindFirst (Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
 try
 repeat
// form4.Memo1.lines.Add(Path + Rec.Name) ;
ffinal:=Path + Rec.Name;
  level.LoadImage(ffinal);
//  form4.JvThumbView1.AddFromFile(ffinal);


 until FindNext(Rec) <> 0;
 finally
 FindClose(Rec) ;
 end;
 end;


procedure TForm4.Button5Click(Sender: TObject);
var
  FileToFind:string;
begin
  glBindTexture(GL_TEXTURE_2D, 0);
end;



procedure TForm4.Button1Click(Sender: TObject);
begin
gridw:=strtoint(edit1.Text);
gridh:=strtoint(edit2.Text);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
edit1.Text:=inttostr(gridw);
edit2.Text:=inttostr(gridh);

end;

procedure TForm4.btn1Click(Sender: TObject);
begin
//  gridw:=strtoint(edit1.Text);
//gridh:=strtoint(edit2.Text);

close;
end;

end.
