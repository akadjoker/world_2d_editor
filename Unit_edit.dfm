object Form5: TForm5
  Left = 342
  Top = 170
  Width = 365
  Height = 266
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeToolWin
  Caption = 'Edit Mode'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 12
    Width = 59
    Height = 13
    Caption = 'World Width'
  end
  object Label2: TLabel
    Left = 160
    Top = 44
    Width = 62
    Height = 13
    Caption = 'World Height'
  end
  object lbl1: TLabel
    Left = 160
    Top = 80
    Width = 50
    Height = 13
    Caption = 'Grid Width'
  end
  object lbl2: TLabel
    Left = 160
    Top = 112
    Width = 53
    Height = 13
    Caption = 'Grid Height'
  end
  object Button1: TButton
    Left = 136
    Top = 188
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 24
    Top = 43
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit2'
  end
  object Button2: TButton
    Left = 248
    Top = 28
    Width = 75
    Height = 25
    Caption = 'Set'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 148
    Width = 97
    Height = 17
    Caption = 'Draw Tiles'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 160
    Top = 148
    Width = 97
    Height = 17
    Caption = 'Draw Grid'
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = CheckBox2Click
  end
  object edt1: TEdit
    Left = 24
    Top = 78
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'edt1'
  end
  object edt2: TEdit
    Left = 24
    Top = 106
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'edt2'
  end
  object btn1: TButton
    Left = 248
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Set'
    TabOrder = 8
    OnClick = btn1Click
  end
end
