object Form5: TForm5
  Left = 342
  Top = 170
  Width = 707
  Height = 415
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeToolWin
  Caption = 'Edit Mode'
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
    Left = 160
    Top = 72
    Width = 59
    Height = 13
    Caption = 'World Width'
  end
  object Label2: TLabel
    Left = 160
    Top = 104
    Width = 62
    Height = 13
    Caption = 'World Height'
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 16
    Width = 441
    Height = 41
    Caption = 'Edit Mode'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'Objects'
      'Paths'
      'Tiles')
    TabOrder = 0
    OnClick = RadioGroup2Click
  end
  object Button1: TButton
    Left = 176
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 24
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit2'
  end
  object Button2: TButton
    Left = 248
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Set'
    TabOrder = 4
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 152
    Width = 97
    Height = 17
    Caption = 'Draw Tiles'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 144
    Top = 152
    Width = 97
    Height = 17
    Caption = 'Draw Grid'
    TabOrder = 6
  end
  object Button3: TButton
    Left = 24
    Top = 272
    Width = 75
    Height = 25
    Caption = 'savetilemap'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 120
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Memo1: TMemo
    Left = 280
    Top = 144
    Width = 361
    Height = 193
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 9
  end
end
