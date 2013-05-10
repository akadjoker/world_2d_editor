unit Unit_Images;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, JvExForms, JvBaseThumbnail, JvThumbViews, ExtDlgs,
  JvBaseDlg, JvSelectDirectory, ExtCtrls;

type
  TForm3 = class(TForm)
    PopupMenu1: TPopupMenu;
    AddFile1: TMenuItem;
    AddDir1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    JvSelectDirectory1: TJvSelectDirectory;
    Panel1: TPanel;
    JvThumbView1: TJvThumbView;
    N1: TMenuItem;
    Delete1: TMenuItem;
    procedure AddFile1Click(Sender: TObject);
    procedure JvThumbView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddDir1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
uses global,dglopengl;

{$R *.dfm}

procedure TForm3.AddFile1Click(Sender: TObject);
begin
OpenPictureDialog1.InitialDir:= ExtractFilePath(ParamStr(0))+'Sprites';

if OpenPictureDialog1.Execute then
begin
  level.LoadImage(OpenPictureDialog1.FileName);
  JvThumbView1.AddFromFile(OpenPictureDialog1.FileName);
  glBindTexture(GL_TEXTURE_2D, 0);
end;
end;

procedure TForm3.JvThumbView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if JvThumbView1.Count<=0 then exit;

//image_index:=JvThumbView1.Selected;

if (JvThumbView1.Selected<>-1) then
begin
globalimage:=Level.GetImage(JvThumbView1.Selected);
caption:='Images '+'Index :'+inttostr(JvThumbView1.Selected)+' - w:'+inttostr(globalimage.PatternWidth)+' - h:'+inttostr(globalimage.PatternHeight);
end;



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
  form3.JvThumbView1.AddFromFile(ffinal);


 until FindNext(Rec) <> 0;
 finally
 FindClose(Rec) ;
 end;
 end;



procedure TForm3.AddDir1Click(Sender: TObject);
var
  FileToFind:string;
begin
if (JvSelectDirectory1.Execute) then
begin
//FileSearch(JvSelectDirectory1.Directory,'*.*');
//FileSearch(JvSelectDirectory1.Directory,'*.bmp');
FileSearch(JvSelectDirectory1.Directory,'*.tga');
FileSearch(JvSelectDirectory1.Directory,'*.jpeg');
FileSearch(JvSelectDirectory1.Directory,'*.png');


end;
  glBindTexture(GL_TEXTURE_2D, 0);
end;




procedure TForm3.Delete1Click(Sender: TObject);
begin
JvThumbView1.Delete( JvThumbView1.Selected);
Level.RemoveImage(Level.GetImage(JvThumbView1.Selected+1));

end;

end.
