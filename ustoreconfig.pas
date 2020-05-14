unit uStoreConfig;

{$mode objfpc}{$H+}

interface



uses
  Classes, SysUtils, inifiles;

var
    INI: TIniFile;
    iniKenshiFolder: String;
    iniUseSteam: boolean;
    iniSteamWorkshopFolder: String;

    iniSourceVisible: boolean;
    iniTitleVisible: boolean;
    iniNameVisible: boolean;
    iniCNameVisible: boolean;
    iniVersionVisible: boolean;

    iniSaveLaunch: boolean;
    iniPreciseDnD: boolean;

CONST
    INI_SECTION = 'General';
    INI_COLUMNS_SECTION = 'Columns';
    INI_FILE = 'KMM.ini';

procedure ReadConfig();
procedure WriteConfig();

implementation

procedure ReadConfig();
begin
  INI := TIniFile.Create(INI_FILE);
  iniKenshiFolder := INI.ReadString(INI_SECTION, 'KenshiFolder', GetCurrentDir);

  iniUseSteam := INI.ReadBool(INI_SECTION,'UseSteam', false);
  if iniUseSteam then
  begin
    iniSteamWorkshopFolder:=INI.ReadString(INI_SECTION,'Steamworkshopfolder', '');
  end;

  iniSourceVisible := INI.ReadBool(INI_COLUMNS_SECTION,'Source', true);
  iniTitleVisible := INI.ReadBool(INI_COLUMNS_SECTION,'Title', false);
  iniNameVisible := INI.ReadBool(INI_COLUMNS_SECTION,'Name', false);
  iniCNameVisible := INI.ReadBool(INI_COLUMNS_SECTION,'CName', true);
  iniVersionVisible := INI.ReadBool(INI_COLUMNS_SECTION,'Version', true);

  iniSaveLaunch := INI.ReadBool(INI_SECTION,'SaveOnLaunch', false);
//  iniPreciseDnD := INI.ReadBool(INI_SECTION,'PreciseDnD', true);

  INI.free;
end;

procedure WriteConfig();
begin
  INI := TIniFile.Create(INI_FILE);
  INI.WriteString(INI_SECTION,'KenshiFolder', iniKenshiFolder);
  INI.WriteBool(INI_SECTION,'UseSteam', iniUseSteam);
  INI.WriteString(INI_SECTION,'Steamworkshopfolder', iniSteamWorkshopFolder);

  INI.WriteBool(INI_COLUMNS_SECTION,'Source', iniSourceVisible);
  INI.WriteBool(INI_COLUMNS_SECTION,'Title', iniTitleVisible);
  INI.WriteBool(INI_COLUMNS_SECTION,'Name', iniNameVisible);
  INI.WriteBool(INI_COLUMNS_SECTION,'CName', iniCNameVisible);
  INI.WriteBool(INI_COLUMNS_SECTION,'Version', iniVersionVisible);

  INI.WriteBool(INI_SECTION,'SaveOnLaunch', iniVersionVisible);
//  INI.WriteBool(INI_SECTION,'PreciseDnD', iniVersionVisible);

  INI.Free;
end;

end.
