object fSettings: TfSettings
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 265
  ClientWidth = 446
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    446
    265)
  PixelsPerInch = 96
  TextHeight = 13
  object lbURLList: TLabel
    Left = 8
    Top = 93
    Width = 113
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1089#1089#1099#1083#1086#1082
  end
  object ledThreadsCount: TLabeledEdit
    Left = 168
    Top = 8
    Width = 65
    Height = 21
    EditLabel.Width = 105
    EditLabel.Height = 13
    EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1090#1086#1082#1086#1074
    LabelPosition = lpLeft
    MaxLength = 5
    NumbersOnly = True
    TabOrder = 0
    Text = '1'
    OnChange = ledThreadsCountChange
  end
  object ledMaxSpeed: TLabeledEdit
    Left = 168
    Top = 35
    Width = 65
    Height = 21
    EditLabel.Width = 155
    EditLabel.Height = 13
    EditLabel.Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1082#1086#1088#1086#1089#1090#1100' (kbps)'
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 1
    Text = '4000'
  end
  object mURLList: TMemo
    Left = 0
    Top = 112
    Width = 446
    Height = 153
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitWidth = 458
    ExplicitHeight = 156
  end
  object tbThreadsCount: TTrackBar
    Left = 248
    Top = 8
    Width = 190
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Max = 10000
    Min = 1
    Position = 1
    TabOrder = 3
    OnChange = tbThreadsCountChange
  end
end
