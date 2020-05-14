object Form1: TForm1
  Left = 387
  Height = 371
  Top = 230
  Width = 547
  ActiveControl = JvWizardInteriorPage2
  Caption = 'First Run Setup'
  ClientHeight = 371
  ClientWidth = 547
  LCLVersion = '6.9'
  object JvWizard1: TJvWizard
    Left = 0
    Height = 371
    Top = 0
    Width = 547
    ActivePage = JvWizardInteriorPage2
    ButtonBarHeight = 42
    ButtonStart.Caption = 'To &Start Page'
    ButtonStart.NumGlyphs = 1
    ButtonStart.Width = 85
    ButtonLast.Caption = 'To &Last Page'
    ButtonLast.NumGlyphs = 1
    ButtonLast.Width = 85
    ButtonBack.Caption = '< &Back'
    ButtonBack.NumGlyphs = 1
    ButtonBack.Width = 75
    ButtonNext.Caption = '&Next >'
    ButtonNext.NumGlyphs = 1
    ButtonNext.Width = 75
    ButtonFinish.Caption = '&Finish'
    ButtonFinish.NumGlyphs = 1
    ButtonFinish.Width = 75
    ButtonCancel.Caption = 'Annuler'
    ButtonCancel.NumGlyphs = 1
    ButtonCancel.ModalResult = 2
    ButtonCancel.Width = 75
    ButtonHelp.Caption = '&Aide'
    ButtonHelp.NumGlyphs = 1
    ButtonHelp.Width = 75
    ShowRouteMap = False
    object JvWizardWelcomePage1: TJvWizardWelcomePage
      Header.Title.Color = clNone
      Header.Title.Text = 'Welcome'
      Header.Title.Anchors = [akTop, akLeft, akRight]
      Header.Title.Font.Height = -16
      Header.Title.Font.Style = [fsBold]
      Header.SubTitle.Color = clNone
      Header.SubTitle.Text = 'Welcome to the Setup of Kenshi Mod Manager'
      Header.SubTitle.Anchors = [akTop, akLeft, akRight, akBottom]
      object Label1: TLabel
        Left = 176
        Height = 247
        Top = 73
        Width = 360
        AutoSize = False
        Caption = 'This wizard will help you configure the program to your liking.'#13#10
        ParentColor = False
      end
    end
    object JvWizardInteriorPage1: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = 'License Agreement'
      Header.Title.Anchors = [akTop, akLeft, akRight]
      Header.Title.Font.Height = -16
      Header.Title.Font.Style = [fsBold]
      Header.SubTitle.Color = clNone
      Header.SubTitle.Text = 'the necessary bla bla'
      Header.SubTitle.Anchors = [akTop, akLeft, akRight, akBottom]
      object Memo1: TMemo
        Left = 8
        Height = 120
        Top = 88
        Width = 536
        Lines.Strings = (
          'MIT License'
          ''
          'Copyright (c) 2020 Pascal Gailloud'
          ''
          'Permission is hereby granted, free of charge, to any person obtaining a copy'
          'of this software and associated documentation files (the "Software"), to deal'
          'in the Software without restriction, including without limitation the rights'
          'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell'
          'copies of the Software, and to permit persons to whom the Software is'
          'furnished to do so, subject to the following conditions:'
          ''
          'The above copyright notice and this permission notice shall be included in all'
          'copies or substantial portions of the Software.'
          ''
          'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR'
          'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,'
          'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE'
          'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER'
          'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,'
          'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE'
          'SOFTWARE.'
        )
        ReadOnly = True
        TabOrder = 0
      end
      object Label2: TLabel
        Left = 8
        Height = 15
        Top = 72
        Width = 91
        Caption = 'Program License:'
        ParentColor = False
      end
      object Label3: TLabel
        Left = 8
        Height = 15
        Top = 224
        Width = 71
        Caption = 'Additionnaly:'
        ParentColor = False
      end
      object Memo2: TMemo
        Left = 8
        Height = 66
        Top = 248
        Width = 536
        Lines.Strings = (
          '1. You are NOT allowed to use this program to copy and reupload mods not made by you.'
        )
        ReadOnly = True
        TabOrder = 1
      end
    end
    object JvWizardInteriorPage2: TJvWizardInteriorPage
      Header.Title.Color = clNone
      Header.Title.Text = 'Kenshi '
      Header.Title.Anchors = [akTop, akLeft, akRight]
      Header.Title.Font.Height = -16
      Header.Title.Font.Style = [fsBold]
      Header.SubTitle.Color = clNone
      Header.SubTitle.Text = 'Subtitle'
      Header.SubTitle.Anchors = [akTop, akLeft, akRight, akBottom]
      Caption = 'JvWizardInteriorPage2'
    end
  end
end
