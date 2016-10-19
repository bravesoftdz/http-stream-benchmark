object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'HTTP Stream Benchmark'
  ClientHeight = 414
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 590
    Height = 75
    Align = alTop
    TabOrder = 0
    object bStartStop: TBitBtn
      Left = 424
      Top = 14
      Width = 155
      Height = 44
      Caption = #1057#1090#1072#1088#1090
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      OnClick = bStartStopClick
    end
  end
  object pcMainDock: TPageControl
    Left = 0
    Top = 75
    Width = 590
    Height = 339
    Align = alClient
    DockSite = True
    TabOrder = 1
    ExplicitLeft = 104
    ExplicitTop = 136
    ExplicitWidth = 289
    ExplicitHeight = 193
  end
end
