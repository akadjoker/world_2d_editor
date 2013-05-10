unit Unit_grid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvFullColorSpaces, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, JvOfficeColorPanel, JvFullColorCtrls, JvDialogs;

type
  TForm2 = class(TForm)
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses hge,global;

{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
close;
end;

end.
