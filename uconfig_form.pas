unit uconfig_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  ComCtrls, ExtCtrls;

type

  { TdlgConfig }

  TdlgConfig = class(TForm)
    Button1: TButton;
    btnDetect: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    chkSaveLaunch: TCheckBox;
    ChkPreciseDrop: TCheckBox;
    chkSource: TCheckBox;
    chkTitle: TCheckBox;
    chkName: TCheckBox;
    ChkCname: TCheckBox;
    chkVersion: TCheckBox;
    chkUseSteam: TCheckBox;
    edtKenshiFolder: TDirectoryEdit;
    edtSWFolder: TDirectoryEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    lblSteamKenshi: TLabel;
    procedure btnDetectClick(Sender: TObject);
    procedure chkUseSteamChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  dlgConfig: TdlgConfig;

implementation
uses folders_unit;

{$R *.frm}

{ TdlgConfig }

procedure TdlgConfig.btnDetectClick(Sender: TObject);
begin
   DetectFolders;
   edtKenshiFolder.Directory := GetKenshiFolder;
   edtSWFolder.Directory:=GetKenshiWorkshopFolder;
end;

procedure TdlgConfig.chkUseSteamChange(Sender: TObject);
begin
  lblSteamKenshi.Visible := chkUseSteam.Checked;
  edtSWFolder.Visible := chkUseSteam.Checked;
  btnDetect.visible := chkUseSteam.Checked;
end;

procedure TdlgConfig.FormShow(Sender: TObject);
begin
  lblSteamKenshi.Visible := chkUseSteam.Checked;
  edtSWFolder.Visible := chkUseSteam.Checked;
  btnDetect.visible := chkUseSteam.Checked;
end;

end.
