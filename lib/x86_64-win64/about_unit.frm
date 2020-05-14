object dlgAbout: TdlgAbout
  Left = 383
  Height = 221
  Top = 258
  Width = 371
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 221
  ClientWidth = 371
  OnCreate = FormCreate
  OnShow = FormShow
  LCLVersion = '7.0'
  object Label1: TLabel
    Left = 8
    Height = 47
    Top = 8
    Width = 354
    Caption = 'Kenshi Mod Manager'
    Font.CharSet = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -35
    Font.Name = 'Segoe UI'
    Font.Pitch = fpVariable
    Font.Quality = fqDraft
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object lblVersion: TLabel
    Left = 8
    Height = 15
    Top = 56
    Width = 82
    Caption = 'Version 0.8 Beta'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 8
    Height = 30
    Top = 136
    Width = 260
    Caption = 'Still in Beta, I''m not responsible if your computer '#13#10'melt or Beep Die after using this software.'
    ParentColor = False
  end
  object Label4: TLabel
    Left = 8
    Height = 45
    Top = 72
    Width = 228
    Caption = '(c) 2019-2020 Pascal Gailloud - Freeware'#13#10#13#10'App icon by icon8 (http://www.icon8.com)'
    ParentColor = False
  end
  object Button1: TButton
    Left = 280
    Height = 25
    Top = 184
    Width = 75
    Caption = 'OK'
    Default = True
    OnClick = Button1Click
    TabOrder = 0
  end
end
