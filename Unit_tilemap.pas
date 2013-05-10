unit Unit_tilemap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs,hge,global,dglopengl,hgeclasses;

type
  TForm8 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

uses Unit_tiler;

{$R *.dfm}

procedure TForm8.Button2Click(Sender: TObject);
begin
  tilew:=strtoint(edit1.Text);
  tileh:=strtoint(edit2.Text);

  tileimage.PatternWidth:=tilew;
  tileimage.PatternHeight:=tileh;

  tilemap:=THGETileMap.Create(wordlw div tilew,worldh div tileh,tilew,tileh,tileimage);
 // tilemap:=THGETileMap.Create(wordlw,worldh ,tilew,tileh,tileimage);
  close;


end;

procedure TForm8.Button1Click(Sender: TObject);
begin
 OpenPictureDialog1.InitialDir:= ExtractFilePath(ParamStr(0))+'Tiles';

if OpenPictureDialog1.Execute then
begin
  form8.Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
 // form7.Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);


  tileimage:=nil;
  tileimage:=TTexture.Create(OpenPictureDialog1.FileName);

  caption:=inttostr(tileimage.PatternWidth)+'<>'+inttostr(tileimage.PatternHeight);
   glBindTexture(GL_TEXTURE_2D, 0);
  //level.LoadImage(OpenPictureDialog1.FileName);

  tilefile:=OpenPictureDialog1.FileName;

    tilew:=strtoint(edit1.Text);
    tileh:=strtoint(edit2.Text);

    tileimage.PatternWidth:=tilew;
    tileimage.PatternHeight:=tileh;
end;
end;

end.
