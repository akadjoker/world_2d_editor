object Form1: TForm1
  Left = 330
  Top = 92
  Width = 957
  Height = 576
  Caption = 'No limits 2d level Editor By Luis Santos AKA DJOKER'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 941
    Height = 518
    Cursor = crCross
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    OnMouseMove = Panel1MouseMove
    OnMouseUp = Panel1MouseUp
    object StatusBar1: TStatusBar
      Left = 1
      Top = 498
      Width = 939
      Height = 19
      Panels = <
        item
          Text = '1'
          Width = 190
        end
        item
          Text = '2'
          Width = 180
        end
        item
          Text = '3'
          Width = 50
        end>
    end
  end
  object timer: TThreadedTimer
    Interval = 1
    OnTimer = timerTimer
    Left = 184
    Top = 96
  end
  object timer2: TThreadedTimer
    Interval = 1
    Left = 775
    Top = 40
  end
  object MainMenu1: TMainMenu
    Left = 216
    Top = 24
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ExportXML1: TMenuItem
        Caption = 'Export XML'
        OnClick = ExportXML1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object World1: TMenuItem
      Caption = 'World'
      object Grid1: TMenuItem
        Caption = 'Propertis'
        OnClick = Grid1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
    end
    object iles1: TMenuItem
      Caption = 'Tiles'
      object LoadLayer1: TMenuItem
        Caption = 'Load Layer'
        OnClick = LoadLayer1Click
      end
      object Editor1: TMenuItem
        Caption = 'Editor'
        OnClick = Editor1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object ool1: TMenuItem
        Caption = 'Tool'
        OnClick = ool1Click
      end
    end
    object Objects1: TMenuItem
      Caption = 'Objects'
      object Edit1: TMenuItem
        Caption = 'Edit'
        OnClick = Edit1Click
      end
    end
    object Images1: TMenuItem
      Caption = 'Images'
      object Add2: TMenuItem
        Caption = 'Add'
        OnClick = Add2Click
      end
    end
    object EditMode2: TMenuItem
      Caption = 'World Mode'
      object Object1: TMenuItem
        Caption = 'Object'
        Checked = True
        OnClick = Object1Click
      end
      object Tiles2: TMenuItem
        Caption = 'Tiles'
        OnClick = Tiles2Click
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 56
    Top = 64
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.BMP;*.pcx;*.jpg;*.jpeg;*.bmp;*.tga;*.png)|*.pcx;*.jpg;*.j' +
      'peg;*.bmp;*.tga;*.png;|PCX Image (*.pcx)|*.pcx|JPEG Image File (' +
      '*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.b' +
      'mp|Targa(*.tga)|*.tga|Portable (*.png)|*.png'
    Title = 'Select Image'
    Left = 320
    Top = 168
  end
end
