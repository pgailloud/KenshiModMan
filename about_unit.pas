unit about_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TdlgAbout }

  TdlgAbout = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    lblVersion: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  dlgAbout: TdlgAbout;

implementation
uses FileInfo;

{$R *.frm}

{ TdlgAbout }

procedure TdlgAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TdlgAbout.FormCreate(Sender: TObject);
begin

end;

procedure TdlgAbout.FormShow(Sender: TObject);
Var fileverinfo: TFileVersionInfo;
begin
     fileverinfo := TFileVersionInfo.Create(nil);
     try
    FileVerInfo.ReadFileInfo;
    lblVersion.caption := 'Version : ' +  FileVerInfo.VersionStrings.Values['FileVersion'];
  finally
    FileVerInfo.Free;
  end;
end;

end.
