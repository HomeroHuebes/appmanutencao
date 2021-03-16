object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 443
  ClientWidth = 672
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 61
    Top = 32
    Width = 68
    Height = 13
    Caption = 'n'#186' de Threads'
  end
  object Label2: TLabel
    Left = 76
    Top = 83
    Width = 53
    Height = 13
    Caption = 'Tempo(ms)'
  end
  object edtQtdeThreads: TEdit
    Left = 135
    Top = 29
    Width = 65
    Height = 21
    TabOrder = 0
    Text = '1'
    OnKeyPress = edtQtdeThreadsKeyPress
  end
  object edtTempo: TEdit
    Left = 135
    Top = 80
    Width = 97
    Height = 21
    TabOrder = 1
    Text = '1000'
    OnKeyPress = edtTempoKeyPress
  end
  object memoLog: TMemo
    Left = 0
    Top = 151
    Width = 672
    Height = 275
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object btnExecuteThreads: TButton
    Left = 263
    Top = 73
    Width = 105
    Height = 35
    Caption = 'Executar'
    TabOrder = 3
    OnClick = btnExecuteThreadsClick
  end
  object progress: TProgressBar
    Left = 0
    Top = 426
    Width = 672
    Height = 17
    Align = alBottom
    Max = 0
    TabOrder = 4
  end
end
