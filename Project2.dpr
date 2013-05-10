program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  global in 'global.pas',
  Unit_grid in 'Unit_grid.pas' {Form2},
  Unit_objects in 'Unit_objects.pas' {Form4},
  Unit_edit in 'Unit_edit.pas' {Form5},
  Unit_world in 'Unit_world.pas' {Form6},
  Unit_Images in 'Unit_Images.pas' {Form3},
  Unit_tiler in 'Unit_tiler.pas' {Form7},
  Unit_tilemap in 'Unit_tilemap.pas' {Form8};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.
