unit uMods;

{$mode delphi}{$H+}
{$IFOPT D+} {$DEFINE DEBUG} {$ENDIF}

interface

uses
  Classes, SysUtils, generics.collections, generics.defaults, lazlogger;

type

 TmodSource = (msSteam, msKenshiFolder, msMissing);

 TModSubList = record
   rawData: string;
   DataList: Tstringlist;
   HasMissing: boolean;
   missingList: TStringlist;
 end;

 { TMod }

 TMod = class
     private
       FActive: boolean;
       FActive_index: integer;
       FSource: TmodSource;
       FHasSteamMod: boolean;
       FSteam_version: integer;
       FHasUserMod: boolean;
       FUser_version: integer;
       FAuthor: string;
       FDescription: string;
       FWorkshop_id: string;
       FName: string;
       FXMLName: string;
       FXMLTitle: String;
       FFolder: string;
       FSteamModFile: string;
       FUserModfile: string;
       function GetVersion: Integer;
       function HasSteamUpdate: boolean;
       procedure initProperties();
       procedure ReadModHeaderFile();
       procedure ReadModInfoFile();
       function GetModConsolidedName: string;
     published
       property Active: boolean read FActive write FActive;
       property Active_Index: integer read FActive_index write FActive_Index;
       property Source: Tmodsource read Fsource;
       property Version: integer read GetVersion;
       property SteamVersion: integer read FSteam_version;
       property UserVersion: integer read FUser_version;
       property SteamUpdate: boolean read HasSteamUpdate;
       property Author: String read FAuthor;
       property Description: String read FDescription;
       property WorkshopID: String read FWorkshop_id;
       property ModName: String read FName;
       property ModTitle: String read FXMLTitle;
       property ModConsolidedName: String read GetModConsolidedName;
       property Folder: String read FFolder;
       property SteamFile: String read FSteamModFile;
       property UserFile: String read FUserModfile;
       property HasSteamMod: Boolean read FHasSteamMod;
     public
       Dependencies_new: TModSubList;
       References_new: TModSubList;
       constructor create(modsource: Tmodsource; modfolder, modfilename: string);
       procedure update(modsource: Tmodsource; modfolder, modfilename: string);
       function SyncMod(kenshidir: string): boolean;
       function UnsyncMod(): boolean;
       destructor destroy; override;
     end;

  procedure ReSort();
  procedure InitList();
  procedure ShutdownList();

  procedure UpdatelistFromSteamWorkshop(directory: string);
  procedure UpdatelistFromKenshiFolder(directory: string);

  procedure LoadModList(directory: string; modlistname: String = '');
  procedure UpdateActiveModsList();

  procedure SortByIndex(Ascend: boolean);
  procedure SortByTitle(Ascend: boolean);
  procedure SortByName(Ascend: boolean);
  procedure SortByCName(Ascend: boolean);
  procedure SortBySource(Ascend: boolean);

  function FindMod(nametofind: string): tmod;
  function FindModIndex(nametofind: string): integer;

  procedure AddModToActiveindex(modtoAdd: tmod);
  procedure RemoveModFromActiveindex(modtoremove: tmod);
  procedure MoveMod(modTomove: Tmod; targetModIndex: integer; offset: integer);
  procedure SwapMods(modTomove: Tmod; targetModIndex: integer);
  procedure SaveList(directory: string; modlistname: String = '');

  var  Modlist: TObjectList<TMod>;
       ActiveList: Tstringlist;

  CONST MOD_NOT_IMPLEMENTED = 65004;
        MOD_NOT_FOUND = 65002;
        MOD_NOT_INIT = 65000;
        MOD_NOT_USED = -1;
        MOD_NOT_ACTIVE = 65001;
        MOD_STR_NOT_INIT = 'Not Init';

implementation
uses {$ifdef DEBUG} lazloggerbase,{$Endif}umodreader, uinforeader, fileutil, lazfileutils, shellapi;

var currentSort: IComparer<TMod>;


function CompareBytitleDescend(constref A, B: TMod): integer;
begin
  result := comparetext(A.ModTitle, B.ModTitle);
end;

function CompareByTitleAscend(constref A, B: TMod): integer;
begin
  result := comparetext(B.Modtitle, A.ModTitle);
end;

function CompareByNameDescend(constref A, B: TMod): integer;
begin
  result := comparetext(A.ModName, B.ModName);
end;

function CompareByNameAscend(constref A, B: TMod): integer;
begin
  result := comparetext(B.ModName, A.ModName);
end;

function CompareByCNameDescend(constref A, B: TMod): integer;
begin
  result := comparetext(A.ModConsolidedName, B.ModConsolidedName);
end;

function CompareByCNameAscend(constref A, B: TMod): integer;
begin
  result := comparetext(B.ModConsolidedName, A.ModConsolidedName);
end;

function CompareBySourceAscend(constref A, B: TMod): integer;
begin
  if A.Source = B.Source then
    result := 0
  else if A.Source = msSteam then
    result := 1
  else
    result := -1;
end;

function CompareBySourceDescend(constref A, B: TMod): integer;
begin
  if A.Source = B.Source then
    result := 0
  else if A.Source = msKenshiFolder then
    result := 1
  else
    result := -1;
end;

function CompareByIndexDescend(constref A, B: TMod): integer;
begin
  if A.Active_Index < B.Active_Index then
    Result := -1
  else if A.Active_Index > B.Active_Index then
    Result := 1
  else
    //CompareByNameDescend(A, B)
    Result := 0;
end;

function CompareByIndexAscend(constref A, B: TMod): integer;
begin
  if A.Active_Index < B.Active_Index then
    Result := 1
  else if A.Active_Index > B.Active_Index then
    Result := -1
  else
    //CompareByNameAscend(A, B);
    Result := 0;
end;

function CopyDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
   FillByte(fos,SizeOf(fos),0);
  with fos do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY + FOF_NOCONFIRMATION;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;


procedure ReSort();
begin
  if Assigned(currentSort) then
    ModList.Sort(currentSort);
end;

procedure InitList();
begin
    Modlist := TObjectList<TMod>.Create();
    Activelist := TStringList.Create;
end;

procedure ShutdownList();
begin
    //DebugLn('Freeing Modlist');
    ModList.free;
    activelist.free;
end;

procedure AddMod(modsource: Tmodsource; directory, name, folder: string);
begin
   case modsource of
       msSteam: Modlist.add(TMod.create(modsource, directory + '\' + name, folder));
       msKenshiFolder: Modlist.add(TMod.create(modsource, directory + '\mods', folder));
       msMissing: Modlist.add(TMod.create(msMissing, directory + '\mods', folder));
   end;
end;

procedure UpdatelistFromSteamWorkshop(directory: string);

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
begin
     //DebugLn('Listing Steam Mods... ');
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
                        AddMod(mssteam, directory, name, getModFolder(directory, name));
                    end;
                 end;
            end;
          end;
      Until FindNext(info)<>0;
     end;
    FindClose(Info);
end;

procedure UpdatelistFromKenshiFolder(directory: string);

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
     modindex: integer;
begin
     //DebugLn('Listing Kenshi Folder Mods...');
     If FindFirst (directory + '\mods\*.*',faDirectory,Info)<>-1 then
     begin
      Repeat
        With Info do
          begin
            If (Attr and faDirectory) = faDirectory then
            begin
                 if (name <> '.') and (name <> '..') and (name <> '.mod') then
                 begin
                     //DebugLn('Mod Found directory: ', directory, ' - ',  name);
                     modindex :=  FindModIndex(name);
                     //DebugLn('Mod found ? ', inttostr(modindex));
                     if modindex = MOD_NOT_FOUND then
                          AddMod(msKenshiFolder, directory, name, name)
                     else
                        Tmod(modlist.items[modindex]).update(msKenshiFolder, directory + '\mods', name);
                 end;
            end;
          end;
      Until FindNext(info)<>0;
     end;
    FindClose(Info);
end;

procedure LoadModList(directory: string; modlistname: String = '');
begin
    if modlistname = '' then
    begin
       activelist.LoadFromFile(directory + '\data\mods.cfg');
    end
    else
    begin
       activelist.LoadFromFile(directory + '\data\mods.' + modlistname + '.cfg');
    end;
end;

procedure UpdateActiveModsList();
var modindex,
    activeindex,
    depindex: integer;
    modname: string;
    loadedModList: Tstringlist;

begin

   //On verifie si tout les mods ACTIFS sont EXISTANTS
   for activeindex := 0 to activelist.Count-1 do
    begin
      //on prend le nom du mod et on recherche dans la liste des mods.
        modname := leftstr(activelist.Strings[activeindex], length(activelist.Strings[activeindex])-4);
        modindex := FindModIndex(modname);
        if modindex = MOD_NOT_FOUND then
        begin
            AddMod(msMissing, '', modname, modname);
        end;
    end;

   //On change les status des mods de notre liste interne suivant la liste des mods actifs.

   //On prend la liste COMPLETE de mods
   for modindex := 0 to modlist.Count - 1 do
   begin
        modlist.items[modindex].Active := false;
        modlist.items[modindex].Active_Index := MOD_NOT_FOUND;
        //On prend la liste des mods ACTIFS
        for activeindex := 0 to activelist.Count-1 do
        begin
           if (modlist.Items[modindex].ModName + '.mod' = activelist.Strings[activeindex]) then
           begin
              modlist.items[modindex].Active := true;
              modlist.items[modindex].Active_Index := activeindex;
              break;
           end;
        end;
   end;

   //Maintenant on verifie les dependences.
   //DONE 1: Ajouter le systeme de dependences.

   //on "charge" les fichiers de données principaux
   loadedmodlist := TStringList.Create;

   loadedmodlist.Add('gamedata.base');
   loadedmodlist.Add('newwworld.mod');
   loadedmodlist.Add('dialogue.mod');
   loadedmodlist.Add('rebirth.mod');



   for activeindex := 0 to ActiveList.count - 1 do
   begin
      loadedmodlist.Add(ActiveList.Strings[activeindex]);

      modname := leftstr(activelist.Strings[activeindex], length(activelist.Strings[activeindex])-4);
      modindex := FindModIndex(modname);

      modlist.Items[modindex].Dependencies_new.missingList.Clear;
      if modlist.Items[modindex].Dependencies_new.DataList.count > 0 then
      begin
        for depindex := 0 to modlist.Items[modindex].Dependencies_new.DataList.count-1 do
        begin
            if loadedModList.IndexOf(modlist.Items[modindex].Dependencies_new.DataList.Strings[depindex]) = -1 then
                modlist.Items[modindex].Dependencies_new.missingList.add(modlist.Items[modindex].Dependencies_new.DataList.Strings[depindex]);
        end;
      end;

      modlist.Items[modindex].References_new.missingList.Clear;
      if modlist.Items[modindex].References_new.DataList.count > 0 then
      begin
        for depindex := 0 to modlist.Items[modindex].References_new.DataList.count-1 do
        begin
            if loadedModList.IndexOf(modlist.Items[modindex].References_new.DataList.Strings[depindex]) = -1 then
                modlist.Items[modindex].References_new.missingList.add(modlist.Items[modindex].References_new.DataList.Strings[depindex]);
        end;
      end;

   end;
   loadedModList.free;
end;



procedure SortByIndex(Ascend: boolean);
begin
  if ascend then
    CurrentSort := TComparer<TMod>.Construct(CompareByIndexAscend)
  else
    CurrentSort := TComparer<TMod>.Construct(CompareByIndexDescend);

  ReSort();
end;

procedure SortByName(Ascend: boolean);
begin
  if ascend then
      CurrentSort := TComparer<TMod>.Construct(CompareByNameAscend)
    else
      CurrentSort := TComparer<TMod>.Construct(CompareByNameDescend);

  ReSort();
end;

procedure SortByCName(Ascend: boolean);
begin
  if ascend then
      CurrentSort := TComparer<TMod>.Construct(CompareByCNameAscend)
    else
      CurrentSort := TComparer<TMod>.Construct(CompareByCNameDescend);

  ReSort();
end;

procedure SortByTitle(Ascend: boolean);
begin
  if ascend then
      CurrentSort := TComparer<TMod>.Construct(CompareByTitleAscend)
    else
      CurrentSort := TComparer<TMod>.Construct(CompareByTitleDescend);

  ReSort();
end;

procedure SortBySource(Ascend: boolean);
begin
  if ascend then
      CurrentSort := TComparer<TMod>.Construct(CompareBySourceAscend)
    else
      CurrentSort := TComparer<TMod>.Construct(CompareBySourceDescend);

  ReSort();
end;

function FindMod(nametofind: string): Tmod;
var moditerator: TMod;
begin
    FindMod := nil;
    for moditerator in Modlist do
    begin
        if moditerator.ModName = nametofind then
        begin
            FindMod := moditerator;
            Break;
        end;
    end;
end;

function FindModIndex(nametofind: string): integer;
var modindex: integer;
    resultat : integer;
begin
    //debugln('Recherche du mod: ', nametofind);
    resultat := MOD_NOT_FOUND;

    for modindex := 0 to Modlist.Count-1 do
    begin
        if Modlist.Items[modindex].ModName = nametofind then
        begin
            resultat := modindex;
            break;
        end;
    end;

    FindModIndex := resultat;
end;


procedure AddModToActiveindex(modtoAdd: tmod);
begin
    activelist.Add(modToadd.ModName + '.mod');
    UpdateActiveModsList();
    //ReSort();
end;

procedure RemoveModFromActiveindex(modtoremove: tmod);
begin
    activelist.Delete(modtoremove.Active_Index);
    modtoremove.Active_Index:= MOD_NOT_FOUND;
    UpdateActiveModsList();
    //ReSort();
end;

procedure MoveMod(modTomove: Tmod; targetModIndex: integer; offset: integer);
begin
     {$ifdef DEBUG}
        debugln('MoveMod');
        debugln('Mod to Move:');
        debugln(' - Name : ' + modtomove.ModName);
        debugln(' - Actuel Index : ' + dbgs(modtomove.Active_Index) );
        debugln('Active List Count : ' + dbgs(activelist.count) );
    {$endif}

    if (targetmodindex + offset) >= activelist.count then
      activelist.Move(modtomove.Active_Index, activelist.count - 1)
    else
       activelist.Move(modtomove.Active_Index, targetmodindex + offset);
    UpdateActiveModsList();
    Resort();
end;

procedure SwapMods(modTomove: Tmod; targetModIndex: integer);
begin
     {$ifdef DEBUG}
        debugln('SwapMod');
        debugln('Mod to Move:');
        debugln(' - Name : ' + modtomove.ModName);
        debugln(' - Actuel Index : ' + dbgs(modtomove.Active_Index) );
    {$endif}

    activelist.Exchange(modtomove.Active_Index, targetmodindex);
    UpdateActiveModsList();
    Resort();
end;

procedure SaveList(directory: string; modlistname: string = '');
begin
     if modlistname = '' then
    begin
       activelist.SaveToFile(directory + '\data\mods.cfg');
    end
    else
    begin
       activelist.SavetoFile(directory + '\data\mods.' + modlistname + '.cfg');
    end;
end;

{ TMod }

function TMod.GetVersion: Integer;
begin
    GetVersion := MOD_NOT_INIT;
   // if (FSteam_version > MOD_NOT_USED) and (Fuser_Version > MOD_NOT_USED) then
   // begin
        Case FSource of
        msSteam: GetVersion := FSteam_version;
        msKenshiFolder: GetVersion := FUser_version;
        msMissing: GetVersion := 0;
        end;
   // end
   // else
   //     GetVersion := MOD_NOT_USED;
end;

function TMod.HasSteamUpdate: boolean;
begin
    HasSteamUpdate := (Fsource = msKenshiFolder) AND (FSteam_version > Fuser_Version) AND FHasSteamMod;
    //if (FSource = msKenshiFolder) and (FSteam_version <> MOD_NOT_FOUND) then
    //    HasSteamUpdate := (FSteam_version > FUser_version);
end;


function Tmod.GetModConsolidedName: string;
var CName: string;
begin
  CName := FName;

   if trim(FXMLTitle) <> '' then
      CName := FXMLTitle
   else
      CName := Fname;
  Result := CName;
end;

procedure TMod.initProperties();
begin
    //FSource := msSteam;
    FHasSteamMod:= false;
    FSteam_version:= MOD_NOT_FOUND;
    FHasUserMod:= false;
    FUser_version:= MOD_NOT_FOUND;
    FAuthor := MOD_STR_NOT_INIT;
    FDescription := MOD_STR_NOT_INIT;
    FWorkshop_id := MOD_STR_NOT_INIT;
    FName := MOD_STR_NOT_INIT;
    FFolder := MOD_STR_NOT_INIT;
    FActive := false;
    FActive_index := MOD_NOT_INIT;
    FXMLName:= '';
    FXMLTitle:= '';
end;

procedure TMod.ReadModHeaderFile();
var header: TModHeader;
    modstream: TFileStream;
begin
    if FSource <> msMissing then
    begin
        case FSource of
        msSteam: modstream := TFileStream.Create(FSteamModFile, fmOpenRead);
        msKenshiFolder : modstream := TFileStream.Create(FUserModfile, fmOpenRead);
        //msmissing: exit();
        end;

        modstream.Position:=0;
        header := ReadModHeader(modstream);
        modstream.Free;

        case Source of
        msSteam: FSteam_version := header.version;
        msKenshiFolder: FUser_version := header.version;
        msmissing: exit();
        end;

        FAuthor := header.author;
        FDescription := header.description;

        Dependencies_new.rawData := header.rawdependance;
        if header.rawdependance.Trim <> '' then
            Dependencies_new.DataList.AddStrings(header.rawdependance.Trim.Split(','));

        References_new.rawData:= header.rawreference;
         if header.rawreference.Trim <> '' then
            References_new.DataList.AddStrings(header.rawreference.Trim.Split(','));

        FFolder := MOD_STR_NOT_INIT;
    end;

end;

procedure TMod.ReadModInfoFile();
var infofile: TInfoFile;
    infofilename : String;
begin
    case FSource of
        msSteam: infofilename := extractfilepath(FSteamModfile) + '_' + FName + '.info'; //  leftstr(FSteamModFile, length(FSteamModFile)-3) + 'info';
        msKenshiFolder : infofilename := extractfilepath(FUserModFile) + '_' + FName + '.info'; //leftstr(FUserModFile, length(FUserModFile)-3) + 'info';
        msmissing: exit();
    end;

    FXMLName := '';
    FXMLTitle := '';

    if FileExists(infofilename) then
    begin
        infofile := readModInfo(infofilename);
        FXMLName:= infofile.name;
        FXMLTitle:= infofile.Title;
    end;
end;

constructor TMod.create(modsource: Tmodsource; modfolder, modfilename: string);
var modSysfilename: string;
begin
    ModSysfilename := modfolder  + '\' + modfilename + '.mod';

    //FDeplist := Tstringlist.Create;
    //FRefList := Tstringlist.Create;

    Dependencies_new.DataList := Tstringlist.Create;
    Dependencies_new.missingList := TStringList.Create;

    References_new.DataList := Tstringlist.create;
    References_new.missingList := Tstringlist.create;

    //DebugLn('Creation Mod item - ', modfolder  + ' - ' + modfilename);
    initProperties();
    fsource := modsource;
    case Fsource of
        msSteam:
          begin
            FSteamModFile := modsysfilename;
            FHasSteamMod := true;
          end;
        msKenshiFolder:
          begin
            FUserModfile := modfolder  + '\' + modfilename + '\' + modfilename  + '.mod';
            FHasUserMod:= true;
          end;
        msMissing: FUserModfile := modfolder  + '\' + modfilename + '\' + modfilename  + '.mod';
    end;
    ReadModHeaderFile();
    FName := modfilename;
    ReadModInfoFile();
end;

procedure TMod.update(modsource: Tmodsource; modfolder, modfilename: string);
var modSysfilename: string;
begin
    ModSysfilename := modfolder  + '\' + modfilename + '.mod';

    //DebugLn('Creation Mod item - ', modfolder  + ' - ' + modfilename);
    fsource := modsource;
    case Fsource of
        msSteam:
          begin
            FSteamModFile := modsysfilename;
            FHasSteamMod:= true;
          end;
        msKenshiFolder:
          begin
            FUserModfile := modfolder  + '\' + modfilename + '\' + modfilename  + '.mod';
            FHasUserMod := true;
          end;
        msmissing: FUserModfile := modfolder  + '\' + modfilename + '\' + modfilename  + '.mod';
    end;
    ReadModHeaderFile();
    FName := modfilename;
end;

function TMod.SyncMod(kenshidir: string): boolean;
begin
    {$ifdef DEBUG}
    debugln('Copie de ' + ExtractFileDir(FSteamModFile) + ' à ' + kenshidir + '\mods');
    {$endif}
    syncmod := CopyDir(ExtractFileDir(FSteamModFile), kenshidir + '\mods\' + ModName);
    //syncmod := CopyDirTree(ExtractFileDir(FSteamModFile), kenshidir + '\mods\' + ModName, [cffPreserveTime, cffCreateDestDirectory, cffOverwriteFile]);
end;

function Tmod.UnsyncMod(): boolean;
var resultat: boolean;
begin
    {$ifdef DEBUG}
    debugln('Suppression de ' + extractfiledir(FUserModfile));
    {$endif}
      Resultat:=DeleteDirectory(extractfiledir(FUserModfile),True);
      if Resultat then begin
        Resultat:=RemoveDirUTF8(extractfiledir(FUserModfile));
      end;
      unsyncmod := resultat;
end;

destructor TMod.destroy;
begin

    Dependencies_new.DataList.free;
    Dependencies_new.missingList.free;

    References_new.DataList.free;
    References_new.missingList.free;

    inherited;
end;

end.
