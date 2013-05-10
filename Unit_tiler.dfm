object Form7: TForm7
  Left = 404
  Top = 109
  Width = 574
  Height = 396
  Cursor = crSizeAll
  Caption = 'Tiler'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 339
    Width = 558
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end>
  end
  object timer: TThreadedTimer
    Interval = 1
    OnTimer = timerTimer
    Left = 120
    Top = 64
  end
end
