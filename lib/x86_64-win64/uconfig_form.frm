object dlgConfig: TdlgConfig
  Left = 383
  Height = 327
  Top = 258
  Width = 551
  BorderStyle = bsDialog
  Caption = 'Configuration'
  ClientHeight = 327
  ClientWidth = 551
  OnShow = FormShow
  LCLVersion = '7.0'
  object chkUseSteam: TCheckBox
    Left = 200
    Height = 19
    Top = 16
    Width = 168
    Caption = 'Use Steam version of Kenshi'
    OnChange = chkUseSteamChange
    TabOrder = 0
  end
  object Button1: TButton
    Left = 464
    Height = 25
    Top = 288
    Width = 75
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnDetect: TButton
    Left = 408
    Height = 25
    Top = 16
    Width = 131
    Caption = 'Auto-Detect Folders'
    OnClick = btnDetectClick
    TabOrder = 2
    Visible = False
  end
  object Button3: TButton
    Left = 376
    Height = 25
    Top = 288
    Width = 75
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 8
    Height = 192
    Top = 8
    Width = 176
    Caption = 'Visible Columns'
    ClientHeight = 172
    ClientWidth = 172
    TabOrder = 4
    object chkSource: TCheckBox
      Left = 16
      Height = 19
      Hint = 'From where the Mod is token.'
      Top = 48
      Width = 56
      Caption = 'Source'
      TabOrder = 0
    end
    object chkTitle: TCheckBox
      Left = 16
      Height = 19
      Top = 69
      Width = 42
      Caption = 'Title'
      TabOrder = 1
    end
    object chkName: TCheckBox
      Left = 16
      Height = 19
      Top = 93
      Width = 52
      Caption = 'Name'
      TabOrder = 2
    end
    object ChkCname: TCheckBox
      Left = 16
      Height = 19
      Hint = 'If the mod have an empty title, it will show his name.'
      Top = 117
      Width = 105
      Caption = 'Consolided Title'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object chkVersion: TCheckBox
      Left = 16
      Height = 19
      Top = 141
      Width = 59
      Caption = 'Version'
      TabOrder = 4
    end
    object CheckBox1: TCheckBox
      Left = 16
      Height = 19
      Top = 0
      Width = 62
      Caption = 'Enabled'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 5
    end
    object CheckBox2: TCheckBox
      Left = 16
      Height = 19
      Top = 24
      Width = 79
      Caption = 'Load Order'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 6
    end
  end
  object GroupBox2: TGroupBox
    Left = 200
    Height = 153
    Top = 48
    Width = 345
    Caption = 'Folders'
    ClientHeight = 133
    ClientWidth = 341
    TabOrder = 5
    object lblSteamKenshi: TLabel
      Left = 16
      Height = 15
      Top = 72
      Width = 168
      Caption = 'Kenshi Steam Workshop folder: '
      ParentColor = False
      Visible = False
    end
    object edtSWFolder: TDirectoryEdit
      Left = 16
      Height = 23
      Top = 88
      Width = 312
      Directory = 'edtSWFolder'
      ShowHidden = False
      ButtonWidth = 23
      NumGlyphs = 1
      MaxLength = 0
      TabOrder = 0
      Visible = False
      Text = 'edtSWFolder'
    end
    object Label2: TLabel
      Left = 16
      Height = 15
      Top = 8
      Width = 74
      Caption = 'Kenshi Folder:'
      ParentColor = False
    end
    object edtKenshiFolder: TDirectoryEdit
      Left = 16
      Height = 23
      Top = 24
      Width = 312
      Directory = 'edtKenshiFolder'
      ShowHidden = False
      ButtonWidth = 23
      NumGlyphs = 1
      MaxLength = 0
      TabOrder = 1
      Text = 'edtKenshiFolder'
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Height = 57
    Top = 216
    Width = 537
    Caption = 'Misc'
    ClientHeight = 37
    ClientWidth = 533
    TabOrder = 6
    object chkSaveLaunch: TCheckBox
      Left = 16
      Height = 19
      Top = 8
      Width = 269
      Caption = 'Save Load Order when launching Kenshi or FCS'
      TabOrder = 0
    end
    object ChkPreciseDrop: TCheckBox
      Left = 16
      Height = 19
      Top = 32
      Width = 159
      Caption = 'Use Precise Drag and Drop'
      TabOrder = 1
      Visible = False
    end
  end
end
