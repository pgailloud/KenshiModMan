unit mods_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type
  TModRecord = record
    id: integer;
    active: boolean;
    index: integer;
    sw_updated: boolean;
    sw_version: integer;
    version: integer;
    author: string;
    description: string;
    dependancies: string;
    references: string;
    sw_id: string;
    mod_name: string;
    folder: string;
  end;

  ModsArray = Array of TModRecord;

  TModsList = class
     Items: ModsArray;

     //Decrepated Procs
     //procedure Add(modid: integer; modfolder, modtitle: string; modstate: shortint); //
     //procedure GetById(index: integer; var ModRec: TModRecord); //
     //function GetByFolder(folder: string): TModRecord; //
     //function GetindexById(index: integer): integer;
     //function GetindexByFolder(folder: string): integer;
     //procedure LoadFromWorkShop();
     //procedure LoadFromKenshiFolder();
     //function CopyToKenshiFolder(index: integer): boolean;
     //function BackupMod(index:integer): boolean;

     //New Procs
     procedure AddFromSteam(modname: string; Id: string);
     procedure AddFromUserFolder(modname: string; folder: string);

     procedure UpdateFromSteam(modname: string; id: string);
     procedure UpdateFromUserFolder(modname: string; folder: string);

     procedure GetBySteamId(index: string; var ModRec: TModRecord);
     function GetByModName(modname: String): TModRecord;

     function GetIdBySteamID(steamID: String): integer;
     function GetIdByModName(modname: String): integer;

     procedure LoadWorkShopMods();
     procedure LoadUserMods();

     constructor create();
     destructor destroy(); override;
  end;

  CONST MOD_NOT_IMPLEMENTED = -4;
        MOD_NOT_FOUND = -3;
        MOD_NOT_INIT = -2;
        MOD_NOT_USED = -1;

implementation
uses umain, Laz2_DOM, laz2_XMLRead, folders_unit, shellAPI, regexpr, dateutils, fileutil, dialogs;

constructor TModsList.create();
begin
   inherited;
   setlength(Items, 0);
end;

destructor TModsList.destroy();
begin

   Items := nil;
   inherited;
end;

{procedure TModsList.Add(modid: integer; modfolder, modtitle: string; modstate: shortint);
begin

     setLength(items, length(items)+1);
     with items[length(items)-1] do
     begin
       SteamID:=modid;
       title:=modtitle;
       folder:=modfolder;
       state := modstate;
       modindex:=length(items);
     end;
end;}

{procedure TModsList.GetById(index: integer; var ModRec: TModRecord);
var i: integer;
begin

  ModRec.State:= -1;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].SteamID = index) then
      begin
         ModRec := items[i];
         break;
      end;
    end;
end;   }

{function TModsList.GetByFolder(folder: string): TModRecord;
var i: integer;
    defRec : TModRecord;
begin
   defRec.State := -1;
   GetByFolder := defRec;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].folder = folder) then
      begin
         GetByFolder := items[i];
         break;
      end;
    end;
end;}

{function TModsList.GetindexById(index: integer): integer;
var i: integer;
begin

  GetindexById := -1;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].SteamID = index) then
      begin
         GetindexById := i;
         break;
      end;
    end;
end;}

{function TModsList.GetindexByFolder(folder: string): integer;
var i: integer;
begin

   GetindexByFolder := -1;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].folder = folder) then
      begin
         GetindexByFolder := i;
         break;
      end;
    end;
end;}

{procedure TModsList.LoadFromWorkShop();

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

  function GetModTitle(workshoppath: string; modId: string): string;
  var resultat: string;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := '';
      if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
      begin
         ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
         TitleNode := modInfoFile.DocumentElement.FindNode('title');

         resultat := TitleNode.TextContent;

      end;
      FindClose(Modfile);
      GetModTitle := resultat;
  end;

  function GetModVersion(workshoppath: string; modId: string): TdateTime;
  var resultat: TdateTime;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := -2;
      if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
      begin
         ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
         TitleNode := modInfoFile.DocumentElement.FindNode('lastUpdate');

         resultat := DomDateToDateTime(TitleNode.TextContent);

      end;
      FindClose(Modfile);
      GetModVersion := resultat;
  end;

  procedure GetSteamMods();
  var
     info : TSearchRec;
     directory: string;
  begin
      directory := GetKenshiWorkshopFolder();

      If FindFirst (directory + '\*.*',faAnyFile,Info)<>-1 then
      begin
      Repeat
        With Info do
          begin
            If (Attr and faDirectory) = faDirectory then
            begin
                 if (name <> '.') and (name <> '..') then
                 begin

                    if getModFolder(directory, name) <> '' then //If a mod is removed from steam, the folder is left empty
                    begin

                         if GetindexByFolder(getModFolder(directory, name))>-1 then
                         begin
                              items[GetindexByFolder(getModFolder(directory, name))].State:=3;
                         end else
                         begin
                           add(strtoint(name), getModFolder(directory, name), getModTitle(directory, name), 1);
                           items[Length(Items)-1].SteamLastUpdate := GetModVersion(directory, name);
                         end;
                    end;
                 end;
            end;
          end;
      Until FindNext(info)<>0;
      end;
    FindClose(Info);
  end;
begin
     GetSteamMods();
end;}

{procedure TModsList.LoadFromKenshiFolder();

  function GetModTitle(workshoppath: string; modId: string): string;
  var resultat: string;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := '';
      try
         if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
          begin
             ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
             TitleNode := modInfoFile.DocumentElement.FindNode('title');

             if titlenode <> nil then
                resultat := TitleNode.TextContent
             else
               resultat := 'Nameless Mod';

          end;
      Except
        on E : Exception do
           resultat := 'NameLess Mod';
      end;

      FindClose(Modfile);
      GetModTitle := resultat;
  end;

  function GetModVersion(workshoppath: string; modId: string): TdateTime;
  var resultat: TdateTime;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := -2;
      try
         if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
          begin
             ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
             TitleNode := modInfoFile.DocumentElement.FindNode('lastUpdate');

             if titlenode <> nil then
                resultat := DomDateToDateTime(TitleNode.TextContent)
             else
               resultat := 0;

          end;
      Except
        on E : Exception do
           resultat := -1;
      end;

      FindClose(Modfile);
      GetModVersion := resultat;
  end;

  Procedure GetKenshiMods();
  var
       info : TSearchRec;
       directory: string;
       cmp: integer;
    begin
      directory := GetKenshiFolder();

      If FindFirst (directory + '\mods\*.*',faDirectory,Info)<>-1 then
      begin
      Repeat
        With Info do
          begin
            If (Attr and faDirectory) = faDirectory then
            begin
                 if (name <> '.') and (name <> '..') then
                 begin
                     if GetindexByFolder(name)>-1 then
                     begin
                          items[GetindexByFolder(name)].LocalUpdate:=GetModVersion(directory + '\mods', name);


                          cmp := CompareDateTime(items[GetindexByFolder(name)].LocalUpdate, items[GetindexByFolder(name)].SteamLastUpdate);
                          if cmp <0 then
                          begin
                             items[GetindexByFolder(name)].State:=5
                          end else if cmp > 0 then
                             items[GetindexByFolder(name)].State:=4
                          else
                             items[GetindexByFolder(name)].State:=3;

                          //if DomDateToDateTime(items[GetindexByFolder(name)].LocalVersion) > DomDateToDateTime(items[GetindexByFolder(name)].SteamVersion) then
                          //   items[GetindexByFolder(name)].State:=5
                          //else if items[GetindexByFolder(name)].LocalVersion <> items[GetindexByFolder(name)].SteamVersion then
                          //    items[GetindexByFolder(name)].State:=4
                          //else
                          //  items[GetindexByFolder(name)].State:=3;
                          //if items[GetindexByFolder(name)].LocalVersion <> items[GetindexByFolder(name)].SteamVersion then
                          //   items[GetindexByFolder(name)].State:=4
                          //else
                          //    items[GetindexByFolder(name)].State:=3;

                     end else
                     begin
                       add(-1, name, getModTitle(directory + '\mods', name), 2);
                       items[Length(items)-1].LocalUpdate:= GetModVersion(directory + '\mods', name);
                     end;
                 end;
            end;
          end;
      Until FindNext(info)<>0;
      end;
    FindClose(Info);
  end;
begin
   GetKenshiMods();
end;}


procedure TModslist.AddFromSteam(modname: string; Id: string);
begin
     //TODO: Ajouter verification si mod deja dans la liste
     setLength(items, length(items)+1);
     with items[length(items)-1] do
     begin
       id:=length(items);
       active:=false;
       index:= MOD_NOT_USED;
       sw_updated:=false;
       sw_version := MOD_NOT_INIT;
       version := MOD_NOT_IMPLEMENTED;
       author := 'Not Readed';
       description := 'Not Readed';
       dependancies:= '';
       references:= '';
       sw_id := id;
       mod_name := modname;
       folder := id;
     end;
end;

procedure TModslist.AddFromUserFolder(modname: string; folder: string);
var modexist: boolean;
begin
     modexist := false;
     //TODO PRIORITAIRE: Ajouter verification si mod deja dans la liste
     if modexist then
     begin
        //TODO : Modification du mod existant (normalement mod ajouté de steam)
     end
     else
     begin
        setLength(items, length(items)+1);
        with items[length(items)-1] do
        begin
            id:=length(items);
            active:=false;
            index:=MOD_NOT_USED;
            sw_updated:=false;
            sw_version := MOD_NOT_INIT;
            version := MOD_NOT_IMPLEMENTED;
            author := 'Not Readed';
            description := 'Not Readed';
            dependancies:= '';
            references:= '';
            sw_id := '';
            mod_name := modname;
            folder := modname;
        end;
     end;

end;


procedure TModslist.UpdateFromSteam(modname: string; id: string);
var index: integer;
begin
    index := GetIdBySteamID(id);
    if index <> MOD_NOT_FOUND then
        with items[index] do
        begin
            sw_updated:=false;
            sw_version := MOD_NOT_INIT;
            author := 'Not Readed';
            description := 'Not Readed';
            dependancies:= '';
            references:= '';
            sw_id := id;
            mod_name := modname;
            folder := id;
        end;
end;

procedure TModslist.UpdateFromUserFolder(modname: string; folder: string);
var index: integer;
begin
    index := GetIdByModName(modname);
    if index <> MOD_NOT_FOUND then
        with items[index] do
        begin
            version := MOD_NOT_IMPLEMENTED;
            author := 'Not Readed';
            description := 'Not Readed';
            dependancies:= '';
            references:= '';
            mod_name := modname;
            folder := modname;
        end;
end;


procedure TModsList.GetBySteamId(index: string; var ModRec: TModRecord);
var i: integer;
begin
   ModRec.Index:= MOD_NOT_FOUND;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].sw_id = index) then
      begin
         ModRec := items[i];
         break;
      end;
    end;
end;

function TModsList.GetByModName(modname: string): TModRecord;
var i: integer;
    defRec : TModRecord;
begin
    defRec.State := MOD_NOT_FOUND;
   GetByModName := defRec;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].mod_name = modname) then
      begin
         GetByModName := items[i];
         break;
      end;
    end;
end;


function TModsList.GetIdBySteamID(steamID: string): integer;
var i: integer;
begin
  GetIdBySteamID := MOD_NOT_FOUND;

   for i := 0 to length(items)-1 do
    begin
      if (items[i].sw_id = steamID) then
      begin
         GetIdBySteamID := i;
         break;
      end;
    end;
end;

function TModsList.GetIdByModName(modname: string): integer;
var i: integer;
begin

   GetIdByModName := MOD_NOT_FOUND;
   for i := 0 to length(items)-1 do
    begin
      if (items[i].mod_name = modname) then
      begin
         GetIdByModName := i;
         break;
      end;
    end;
end;


procedure TModsList.LoadWorkShopMods();

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

  function GetModTitle(workshoppath: string; modId: string): string;
  var resultat: string;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := '';
      if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
      begin
         ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
         TitleNode := modInfoFile.DocumentElement.FindNode('title');

         resultat := TitleNode.TextContent;

      end;
      FindClose(Modfile);
      GetModTitle := resultat;
  end;

  function GetModVersion(workshoppath: string; modId: string): TdateTime;
  var resultat: TdateTime;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := -2;
      if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
      begin
         ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
         TitleNode := modInfoFile.DocumentElement.FindNode('lastUpdate');

         resultat := DomDateToDateTime(TitleNode.TextContent);

      end;
      FindClose(Modfile);
      GetModVersion := resultat;
  end;

  procedure GetSteamMods();
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

                    if getModFolder(directory, name) <> '' then //If a mod is removed from steam, the folder is left empty
                    begin
                         UpdateFromSteam();
                         if GetIdBymodname(getModFolder(directory, name)) <> MOD_NOT_FOUND then
                         begin
                              items[GetindexByFolder(getModFolder(directory, name))].State:=3;
                         end else
                         begin
                           add(strtoint(name), getModFolder(directory, name), getModTitle(directory, name), 1);
                           items[Length(Items)-1].SteamLastUpdate := GetModVersion(directory, name);
                         end;
                    end;
                 end;
            end;
          end;
      Until FindNext(info)<>0;
      end;
    FindClose(Info);
  end;
begin
     GetSteamMods();
end;

procedure TModsList.LoadUserMods();

  function GetModTitle(workshoppath: string; modId: string): string;
  var resultat: string;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := '';
      try
         if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
          begin
             ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
             TitleNode := modInfoFile.DocumentElement.FindNode('title');

             if titlenode <> nil then
                resultat := TitleNode.TextContent
             else
               resultat := 'Nameless Mod';

          end;
      Except
        on E : Exception do
           resultat := 'NameLess Mod';
      end;

      FindClose(Modfile);
      GetModTitle := resultat;
  end;

  function GetModVersion(workshoppath: string; modId: string): TdateTime;
  var resultat: TdateTime;
      modFile: TsearchRec;
      modInfoFile: TXMLDocument;
      titleNode: TDOMNode;
  begin
      resultat := -2;
      try
         if FindFirst(workshoppath + '\' + ModID + '\*.info', faAnyFile, modFile)<>-1 then
          begin
             ReadXMLFile(ModInfoFile, workshoppath + '\' + ModID + '\' + modFile.Name);
             TitleNode := modInfoFile.DocumentElement.FindNode('lastUpdate');

             if titlenode <> nil then
                resultat := DomDateToDateTime(TitleNode.TextContent)
             else
               resultat := 0;

          end;
      Except
        on E : Exception do
           resultat := -1;
      end;

      FindClose(Modfile);
      GetModVersion := resultat;
  end;

  Procedure GetKenshiMods();
  var
       info : TSearchRec;
       directory: string;
       cmp: integer;
    begin
      directory := GetKenshiFolder();

      If FindFirst (directory + '\mods\*.*',faDirectory,Info)<>-1 then
      begin
      Repeat
        With Info do
          begin
            If (Attr and faDirectory) = faDirectory then
            begin
                 if (name <> '.') and (name <> '..') then
                 begin
                     if GetindexByFolder(name)>-1 then
                     begin
                          items[GetindexByFolder(name)].LocalUpdate:=GetModVersion(directory + '\mods', name);


                          cmp := CompareDateTime(items[GetindexByFolder(name)].LocalUpdate, items[GetindexByFolder(name)].SteamLastUpdate);
                          if cmp <0 then
                          begin
                             items[GetindexByFolder(name)].State:=5
                          end else if cmp > 0 then
                             items[GetindexByFolder(name)].State:=4
                          else
                             items[GetindexByFolder(name)].State:=3;

                          //if DomDateToDateTime(items[GetindexByFolder(name)].LocalVersion) > DomDateToDateTime(items[GetindexByFolder(name)].SteamVersion) then
                          //   items[GetindexByFolder(name)].State:=5
                          //else if items[GetindexByFolder(name)].LocalVersion <> items[GetindexByFolder(name)].SteamVersion then
                          //    items[GetindexByFolder(name)].State:=4
                          //else
                          //  items[GetindexByFolder(name)].State:=3;
                          //if items[GetindexByFolder(name)].LocalVersion <> items[GetindexByFolder(name)].SteamVersion then
                          //   items[GetindexByFolder(name)].State:=4
                          //else
                          //    items[GetindexByFolder(name)].State:=3;

                     end else
                     begin
                       add(-1, name, getModTitle(directory + '\mods', name), 2);
                       items[Length(items)-1].LocalUpdate:= GetModVersion(directory + '\mods', name);
                     end;
                 end;
            end;
          end;
      Until FindNext(info)<>0;
      end;
    FindClose(Info);
  end;
begin
   GetKenshiMods();
end;


function TModsList.CopyToKenshiFolder(index: integer): boolean;
begin
    Raise Exception.create('Not Yet Implemented');
end;

function TModsList.BackupMod(index: integer): boolean;
begin
    Raise Exception.create('Not Yet Implemented');
end;


end.

