object Form6: TForm6
  Left = 326
  Top = 124
  Width = 312
  Height = 307
  BorderStyle = bsSizeToolWin
  Caption = 'New World'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 59
    Height = 13
    Caption = 'World Widht'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 62
    Height = 13
    Caption = 'World Height'
  end
  object Button1: TButton
    Left = 96
    Top = 224
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 104
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '800'
  end
  object Edit2: TEdit
    Left = 104
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '600'
  end
end
