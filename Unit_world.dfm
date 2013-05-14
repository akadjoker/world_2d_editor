object Form6: TForm6
  Left = 343
  Top = 196
  Width = 290
  Height = 313
  BorderStyle = bsSizeToolWin
  Caption = 'Tiles Tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 144
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btn1Click
  end
  object grp1: TGroupBox
    Left = 16
    Top = 8
    Width = 249
    Height = 201
    Caption = 'Fiil'
    TabOrder = 1
    object lbl1: TLabel
      Left = 24
      Top = 16
      Width = 56
      Height = 13
      Caption = 'Tile Number'
    end
    object lbl2: TLabel
      Left = 16
      Top = 54
      Width = 33
      Height = 13
      Caption = 'From X'
    end
    object lbl3: TLabel
      Left = 120
      Top = 53
      Width = 21
      Height = 13
      Caption = 'To X'
    end
    object lbl4: TLabel
      Left = 15
      Top = 83
      Width = 33
      Height = 13
      Caption = 'From Y'
    end
    object lbl5: TLabel
      Left = 120
      Top = 83
      Width = 21
      Height = 13
      Caption = 'To Y'
    end
    object btn2: TButton
      Left = 136
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Fill Range'
      TabOrder = 0
      OnClick = btn2Click
    end
    object edt1: TEdit
      Left = 96
      Top = 16
      Width = 57
      Height = 21
      TabOrder = 1
      Text = '-1'
    end
    object edt2: TEdit
      Left = 56
      Top = 51
      Width = 57
      Height = 21
      TabOrder = 2
      Text = 'edt2'
    end
    object edt3: TEdit
      Left = 160
      Top = 51
      Width = 73
      Height = 21
      TabOrder = 3
      Text = 'edt3'
    end
    object edt4: TEdit
      Left = 56
      Top = 83
      Width = 57
      Height = 21
      TabOrder = 4
      Text = 'edt4'
    end
    object edt5: TEdit
      Left = 160
      Top = 83
      Width = 73
      Height = 21
      TabOrder = 5
      Text = 'edt5'
    end
    object btn4: TButton
      Left = 32
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Fill All'
      TabOrder = 6
      OnClick = btn4Click
    end
  end
  object btn3: TButton
    Left = 56
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btn3Click
  end
end
