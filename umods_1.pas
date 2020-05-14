unit umods_1;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, lazlogger;

type

 TModRecord = Record
    Active_Index: integer;
    Steam_version: integer;
    User_version: integer;
    Steam_update: integer;
    Name: string;
    Author: string;
    Description: string;
    Dependencies: string;
    References: string;
    Workshop_id: string;
    Folder: string;
 end;


  PModsRec = ^Tmod_record;

  AMods = array of TModRecord;

  TModList = class
    Items: Amods;

    procedure AddFromSteam(
  end;


var modlist: TList;

      CONST MOD_NOT_IMPLEMENTED = -4;
            MOD_NOT_FOUND = -3;
            MOD_NOT_INIT = -2;
            MOD_NOT_USED = -1;


implementation
uses umain;


procedure UpdatelistFromSteamWorkshop();

   function getModFolder(workshoppath: string; ModID: string): string;
   var modFile: TsearchRec;
       resultat: string;
   begin
      resultat := '';
      if FindFirst(workshoppath + '\' + ModID + '\*.mod', faAnyFile, modFile)<>-1 then
      begin
         resultat := leftstr(modFile.name, length(modfile.name)-4);
      end;
      FindClose(Modfile);
      getModFolder := resultat;
   end;

var
     info : TSearchRec;
     directory: string;
begin
     directory := umain.iniSteamWorkshopFolder;

     If FindFirst (directory + '\*.*',faAnyFile,Info)<>-1 then
     begin
      Repeat
        With Info do
          begin
            If (Attr and faDirectory) = faDirectory then
            begin
                 if (name <> '.') and (name <> '..') then
                 begin
                    if getModFolder(directory, name) <> '' then
                    begin
                       Modlist.add(TMod.create(getModFolder(directory, name)));
                    end;
                 end;
            end;
          end;
      Until FindNext(info)<>0;
     end;
    FindClose(Info);
  end;


{ TMod }

constructor TMod.create(modname: string);
begin
    FName := modname;
end;

destructor TMod.destroy;
begin
    inherited;
end;

end.

