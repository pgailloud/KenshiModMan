object dlgConfig: TdlgConfig
  Left = 409
  Height = 269
  Top = 219
  Width = 370
  BorderStyle = bsDialog
  Caption = 'Configuration'
  ClientHeight = 269
  ClientWidth = 370
  LCLVersion = '6.9'
  object chkUseSteam: TCheckBox
    Left = 16
    Height = 19
    Top = 64
    Width = 168
    Caption = 'Use Steam version of Kenshi'
    TabOrder = 0
  end
  object Label1: TLabel
    Left = 32
    Height = 15
    Top = 88
    Width = 168
    Caption = 'Kenshi Steam Workshop folder: '
    ParentColor = False
  end
  object edtSWFolder: TDirectoryEdit
    Left = 32
    Height = 23
    Top = 104
    Width = 312
    Directory = 'edtSWFolder'
    ShowHidden = False
    ButtonWidth = 23
    NumGlyphs = 1
    MaxLength = 0
    TabOrder = 1
    Text = 'edtSWFolder'
  end
  object Label2: TLabel
    Left = 16
    Height = 15
    Top = 16
    Width = 74
    Caption = 'Kenshi Folder:'
    ParentColor = False
  end
  object edtKenshiFolder: TDirectoryEdit
    Left = 16
    Height = 23
    Top = 32
    Width = 328
    Directory = 'edtKenshiFolder'
    ShowHidden = False
    ButtonWidth = 23
    NumGlyphs = 1
    MaxLength = 0
    TabOrder = 2
    Text = 'edtKenshiFolder'
  end
  object Button1: TButton
    Left = 288
    Height = 25
    Top = 240
    Width = 75
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnDetect: TButton
    Left = 32
    Height = 25
    Top = 136
    Width = 131
    Caption = 'Auto-Detect Folders'
    OnClick = btnDetectClick
    TabOrder = 4
  end
  object Button3: TButton
    Left = 208
    Height = 25
    Top = 240
    Width = 75
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 5
  end
end
