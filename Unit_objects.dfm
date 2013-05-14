object Form4: TForm4
  Left = 507
  Top = 103
  BorderIcons = [biMinimize]
  BorderStyle = bsSingle
  Caption = 'Objects'
  ClientHeight = 382
  ClientWidth = 392
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 392
    Height = 382
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'Transform'
      ImageIndex = 1
      object Label1: TLabel
        Left = 56
        Top = 272
        Width = 27
        Height = 13
        Caption = 'Angle'
      end
      object RadioGroup1: TRadioGroup
        Left = 16
        Top = 16
        Width = 129
        Height = 105
        Caption = 'Object Mode'
        ItemIndex = 0
        Items.Strings = (
          'Place Objects'
          'Delete Objects'
          'Move Objects')
        TabOrder = 0
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 176
        Width = 97
        Height = 17
        Caption = 'Mirror X'
        TabOrder = 1
        OnClick = CheckBox1Click
      end
      object CheckBox2: TCheckBox
        Left = 16
        Top = 216
        Width = 97
        Height = 17
        Caption = 'Mirror Y'
        TabOrder = 2
        OnClick = CheckBox2Click
      end
      object ScrollBar1: TScrollBar
        Left = 16
        Top = 296
        Width = 121
        Height = 17
        Max = 360
        Min = -360
        PageSize = 0
        TabOrder = 3
        OnChange = ScrollBar1Change
      end
      object CheckBox3: TCheckBox
        Left = 15
        Top = 140
        Width = 106
        Height = 18
        Caption = 'Snap to Grid'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = CheckBox3Click
      end
      object GroupBox1: TGroupBox
        Left = 176
        Top = 20
        Width = 201
        Height = 285
        Caption = 'Grid'
        TabOrder = 5
        object Edit1: TEdit
          Left = 8
          Top = 13
          Width = 41
          Height = 21
          TabOrder = 0
          Text = '32'
        end
        object Edit2: TEdit
          Left = 8
          Top = 38
          Width = 41
          Height = 21
          TabOrder = 1
          Text = '32'
        end
        object Button1: TButton
          Left = 72
          Top = 24
          Width = 89
          Height = 41
          Caption = 'Set'
          TabOrder = 2
          OnClick = Button1Click
        end
      end
      object JvOfficeColorPanel1: TJvOfficeColorPanel
        Left = 200
        Top = 120
        Width = 152
        Height = 162
        SelectedColor = clDefault
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
        TabOrder = 6
        Properties.NoneColorCaption = 'No Color'
        Properties.DefaultColorCaption = 'Automatic'
        Properties.CustomColorCaption = 'Other Colors...'
        Properties.NoneColorHint = 'No Color'
        Properties.DefaultColorHint = 'Automatic'
        Properties.CustomColorHint = 'Other Colors...'
        Properties.DefaultColorColor = clWhite
        Properties.NoneColorFont.Charset = DEFAULT_CHARSET
        Properties.NoneColorFont.Color = clWindowText
        Properties.NoneColorFont.Height = -11
        Properties.NoneColorFont.Name = 'Tahoma'
        Properties.NoneColorFont.Style = []
        Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
        Properties.DefaultColorFont.Color = clWindowText
        Properties.DefaultColorFont.Height = -11
        Properties.DefaultColorFont.Name = 'Tahoma'
        Properties.DefaultColorFont.Style = []
        Properties.CustomColorFont.Charset = DEFAULT_CHARSET
        Properties.CustomColorFont.Color = clWindowText
        Properties.CustomColorFont.Height = -11
        Properties.CustomColorFont.Name = 'Tahoma'
        Properties.CustomColorFont.Style = []
        OnColorChange = JvOfficeColorPanel1ColorChange
        OnColorButtonClick = JvOfficeColorPanel1ColorButtonClick
      end
      object btn1: TButton
        Left = 168
        Top = 320
        Width = 75
        Height = 25
        Caption = 'Ok'
        TabOrder = 7
        OnClick = btn1Click
      end
    end
  end
end
