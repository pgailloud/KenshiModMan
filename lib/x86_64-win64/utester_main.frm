object Form1: TForm1
  Left = 514
  Height = 421
  Top = 260
  Width = 678
  Caption = 'Kenshi Tester'
  ClientHeight = 421
  ClientWidth = 678
  OnCreate = FormCreate
  LCLVersion = '6.9'
  object ListView1: TListView
    Left = 0
    Height = 273
    Top = 56
    Width = 664
    Columns = <    
      item
        Caption = 'Name'
        Width = 200
      end    
      item
        Caption = 'Description'
        Width = 300
      end    
      item
        Caption = 'Version'
        Width = 55
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 0
    Height = 25
    Top = 16
    Width = 120
    Caption = 'List Steam Mods'
    OnClick = Button1Click
    TabOrder = 1
  end
  object Button2: TButton
    Left = 240
    Height = 25
    Top = 16
    Width = 75
    Caption = 'Read Next'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 136
    Height = 25
    Top = 16
    Width = 75
    Caption = 'Read All'
    OnClick = Button3Click
    TabOrder = 3
  end
end
