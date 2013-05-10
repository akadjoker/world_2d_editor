object Form3: TForm3
  Left = 453
  Top = 137
  Width = 655
  Height = 507
  Caption = 'Images '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 639
    Height = 469
    Align = alClient
    Caption = 'Panel1'
    PopupMenu = PopupMenu1
    TabOrder = 0
    object JvThumbView1: TJvThumbView
      Left = 1
      Top = 1
      Width = 637
      Height = 467
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      Align = alClient
      BevelInner = bvSpace
      BevelOuter = bvRaised
      TabOrder = 0
      TabStop = True
      OnMouseDown = JvThumbView1MouseDown
      AlignView = vtNormal
      AutoScrolling = True
      ThumbGap = 4
      AutoHandleKeyb = True
      MinMemory = True
      MaxWidth = 200
      MaxHeight = 200
      Size = 100
      ScrollMode = smBoth
      Sorted = False
      AsButtons = False
      TitlePlacement = tpNone
      Filter = 
        'All (*.dib;*.gif;*.cur;*.pcx;*.ani;*.jpg;*.jpeg;*.bmp;*.ico;*.em' +
        'f;*.wmf)|*.dib;*.gif;*.cur;*.pcx;*.ani;*.jpg;*.jpeg;*.bmp;*.ico;' +
        '*.emf;*.wmf|Device Independent Bitmap (*.dib)|*.dib|CompuServe G' +
        'IF Image (*.gif)|*.gif|Cursor files (*.cur)|*.cur|PCX Image (*.p' +
        'cx)|*.pcx|ANI Image (*.ani)|*.ani|JPEG Image File (*.jpg)|*.jpg|' +
        'JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp|Icons (*.i' +
        'co)|*.ico|Enhanced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.w' +
        'mf'
      ThumbColor = clNone
      ShowShadow = False
      ShadowColor = clBlack
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 504
    Top = 176
    object AddFile1: TMenuItem
      Caption = 'Add File'
      OnClick = AddFile1Click
    end
    object AddDir1: TMenuItem
      Caption = 'Add Dir'
      OnClick = AddDir1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.BMP;*.pcx;*.jpg;*.jpeg;*.bmp;*.tga;*.png)|*.pcx;*.jpg;*.j' +
      'peg;*.bmp;*.tga;*.png;|PCX Image (*.pcx)|*.pcx|JPEG Image File (' +
      '*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.b' +
      'mp|Targa(*.tga)|*.tga|Portable (*.png)|*.png'
    Title = 'Select Image'
    Left = 528
    Top = 32
  end
  object JvSelectDirectory1: TJvSelectDirectory
    Left = 448
    Top = 32
  end
end
