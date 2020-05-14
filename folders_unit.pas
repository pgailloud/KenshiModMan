unit folders_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function GetSteamFolder: string;
function GetKenshiFolder: String;
function GetKenshiWorkshopFolder: string;

procedure DetectFolders;




implementation

uses registry, regexpr, fpjson;

var steamfolder: string;
var KenshiFolder: string;
var WorkshopFolder: string;

//Recuperation du dossier Steam via sa clé de registre Windows
function GetSteamFolder: string;
var Reg: TRegistry;
  resultat: String;
begin
    Result := '';
    Reg := TRegistry.Create;
    Reg.RootKey:= HKEY_LOCAL_MACHINE;

    //on teste si on est sur un Windows 64 bits si oui on prend le chemin "emulé" du registe windows 32 bits.
    Reg.Access:=Reg.Access or KEY_WOW64_64KEY;
    if Reg.OpenKeyReadOnly('\SOFTWARE\Valve\Steam') then
      resultat := Reg.ReadString('InstallPath')
    else
      if Reg.OpenKeyReadOnly('\SOFTWARE\WOW6432Node\Valve\Steam') then
             resultat := Reg.ReadString('InstallPath');
    Reg.free;
    GetSteamFolder := resultat;
end;

procedure DetectFolders;
var SteamLibraries,
    vdffile: Tstringlist;
    i: integer;
    regexp: TRegExpr;
begin
     steamfolder := GetSteamFolder;
     //Get Library List
  SteamLibraries := Tstringlist.Create;
  //Default Library
  SteamLibraries.Add(SteamFolder);

  //Additionnal Libraries
  vdffile := Tstringlist.Create;
  vdffile.LoadFromFile(SteamFolder + '\steamapps\libraryfolders.vdf');

  regexp := TRegExpr.Create;
  regexp.expression := '\t"\d+"\t\t"(.*)"';
  for i := 0 to vdffile.Count - 1 do
  begin
    // Check each line on a regex to check folders name
    if regexp.Exec(vdfFile.Strings[i]) then
    begin
      SteamLibraries.Add(StringReplace(regexp.Match[1],'\\','\',[rfReplaceAll]));
    end;
  end;

  //And now check all these folders to find where is Kenshi !
  for i := 0 to SteamLibraries.Count-1 do
    begin
      if FileExists(SteamLibraries.Strings[i] + '\steamapps\appmanifest_233860.acf') then
      begin
        KenshiFolder := SteamLibraries.Strings[i] + '\steamapps\common\Kenshi';
        WorkShopFolder := SteamLibraries.Strings[i] + '\steamapps\workshop\content\233860';
      end;
    end;

  vdffile.Free;
  regexp.Free;
  SteamLibraries.Free;
end;


//Recupration du dossier de Kenshi via son fichier Manifest dans le dossier de Steam
function GetKenshiFolder: String;
begin
     getKenshiFolder := kenshifolder;
end;


//Recuperation du dossier workshop de Kenshi
function GetKenshiWorkshopFolder: string;
begin
    GetKenshiWorkshopFolder := WorkshopFolder;
end;

end.

