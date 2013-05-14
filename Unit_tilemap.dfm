object Form8: TForm8
  Left = 508
  Top = 112
  Width = 715
  Height = 535
  Caption = 'Tile Layer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 576
    Top = 12
    Width = 45
    Height = 13
    Caption = 'Tile width'
  end
  object Label2: TLabel
    Left = 578
    Top = 37
    Width = 49
    Height = 13
    Caption = 'Tile height'
  end
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 561
    Height = 489
    AutoSize = True
    IncrementalDisplay = True
  end
  object Button1: TButton
    Left = 600
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Load Tile'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 632
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '24'
  end
  object Edit2: TEdit
    Left = 632
    Top = 32
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '24'
  end
  object Button2: TButton
    Left = 600
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = Button2Click
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
