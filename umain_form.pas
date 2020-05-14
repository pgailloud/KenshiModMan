unit umain_form;

{$mode objfpc}{$H+}
{$ModeSwitch AutoDeref}
{$IFOPT D+} {$DEFINE DEBUG} {$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Graphics, Controls, Dialogs, SpkToolbar, spkt_Tab,
  spkt_Pane, spkt_Buttons, VirtualTrees, uconfig_form,
  about_unit, Types, ActiveX, LCLTranslator, ActnList, ComCtrls, Menus;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actConfig: TAction;
    actAbout: TAction;
    actHelp: TAction;
    ActSyncMod: TAction;
    actRemoveMod: TAction;
    actRevertOrder: TAction;
    actSaveOrder: TAction;
    actStartFCS: TAction;
    actStartKenshi: TAction;
    ActionList1: TActionList;
    imgStates: TImageList;
    imgButtons: TImageList;
    btnConfig: TSpkLargeButton;
    btnRefresh: TSpkLargeButton;
    btnLaunchKenshi: TSpkLargeButton;
    btnLaunchFCS: TSpkLargeButton;
    btnSaveList: TSpkLargeButton;
    btnRevertList: TSpkLargeButton;
    btnHelp: TSpkLargeButton;
    btnAbout: TSpkLargeButton;
    SpkLargeButton1: TSpkLargeButton;
    SpkLargeButton2: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkPane2: TSpkPane;
    SpkPane3: TSpkPane;
    SpkPane4: TSpkPane;
    SpkPane5: TSpkPane;
    SpkPane6: TSpkPane;
    SpkSmallButton1: TSpkSmallButton;
    SpkTab2: TSpkTab;
    SpkToolbar1: TSpkToolbar;
    ModsView: TVirtualStringTree;
    procedure actAboutExecute(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actRemoveModExecute(Sender: TObject);
    procedure actRevertOrderExecute(Sender: TObject);
    procedure actSaveOrderExecute(Sender: TObject);
    procedure actStartFCSExecute(Sender: TObject);
    procedure actStartKenshiExecute(Sender: TObject);
    procedure ActSyncModExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ModsViewChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ModsViewChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure ModsViewDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure ModsViewDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      const Pt: TPoint; var Effect: DWORD; Mode: TDropMode);
    procedure ModsViewDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; const Pt: TPoint; Mode: TDropMode;
      var Effect: DWORD; var Accept: Boolean);
    procedure ModsViewGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: String);
    procedure ModsViewGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ModsViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure ModsViewHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure ModsViewInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure ModsViewInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure btnRefreshClick(Sender: TObject);
    procedure ModsViewStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure SpkSmallButton1Click(Sender: TObject);
  private
    procedure AddDependencies();
  public
    procedure refreshlist();
    procedure setconfigtodlg();
    procedure getconfigfromdlg();
    procedure applyConfig();
  end;



var
  frmMain: TfrmMain;


implementation
uses process, lclintf, {$ifdef DEBUG} lazloggerbase,{$Endif} umods, ustoreconfig, windows, ShlObj, ComObj, StringsLang;

var CanDrag: boolean = false;
    dragMod: Tmod;
    ProfileName: String = '';

{$R *.frm}

procedure CreateDesktopShortCut(Target, TargetArguments, ShortcutName: string);
var
  IObject: IUnknown;
  ISLink: IShellLink;
  IPFile: IPersistFile;
  PIDL: PItemIDList;
  InFolder: array[0..MAX_PATH] of Char;
  LinkName: WideString;
begin
  { Creates an instance of IShellLink }
  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  ISLink.SetPath(pChar(Target));
  ISLink.SetArguments(pChar(TargetArguments));
  ISLink.SetWorkingDirectory(pChar(ExtractFilePath(Target)));

  { Get the desktop location }
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
  SHGetPathFromIDList(PIDL, InFolder);
  LinkName := ShortcutName+'.lnk';
  //LinkName := InFolder + PathDelim + ShortcutName+'.lnk';

  { Create the link }
  IPFile.Save(PWChar(LinkName), false);
end;


{ TfrmMain }

procedure TfrmMain.AddDependencies();
begin

end;

procedure TfrmMain.SpkSmallButton1Click(Sender: TObject);
Var Kprocess: TProcess;
begin

  Kprocess := TProcess.Create(nil);
  Kprocess.Executable:= iniKenshiFolder + '\kenshi_x64.exe';
  Kprocess.CurrentDirectory:= iniKenshiFolder;
  Kprocess.Options:= [poWaitOnExit];
  Kprocess.Execute;
  Kprocess.Free;

  {$ifdef DEBUG}
  debugln('Demande d''info objets:');
  debugln('Objet focus:');
  debugln('- name: ' + modlist.Items[modsview.GetFirstSelected(true).index].ModName);
  debugln('- dependencie:');
  debugln('-- Raw: ' + modlist.Items[modsview.GetFirstSelected(true).index].Dependencies_new.rawData);
  debugln('-- nbr: ' + inttostr(modlist.Items[modsview.GetFirstSelected(true).index].Dependencies_new.DataList.Count));
  {$ENDIF}
end;

procedure TfrmMain.refreshlist();
begin
    modsview.BeginUpdate;
    ModsView.RootNodeCount := 0;
    Modlist.Clear;
    if fileexists(iniKenshiFolder + '\kenshi_x64.exe') then
    begin
      if iniUseSteam then
          UpdatelistFromSteamWorkshop(iniSteamWorkshopFolder);
      UpdatelistFromKenshiFolder(iniKenshiFolder);
      LoadModList(iniKenshiFolder, ProfileName);
      UpdateActiveModsList();
      ModsView.RootNodeCount:= Modlist.Count;
      Resort();
    end
    else
    begin

      MessageDlg('Woops...', 'I didn''t found kenshi where you said. Check back the configuration.',
        mtError , [mbOK] , '');
      actConfig.Execute;
    end;

    modsview.EndUpdate;
end;

procedure TfrmMain.setconfigtodlg();
begin
    {$ifdef DEBUG}debugln('INI Settings: ' + iniKenshiFolder);{$endif}
    dlgConfig.edtKenshiFolder.Directory:=iniKenshiFolder;
    dlgConfig.chkUseSteam.Checked:=iniUseSteam;
    dlgconfig.edtSWFolder.Directory:= iniSteamWorkshopFolder;

    dlgconfig.chkSource.Checked := iniSourceVisible;
    dlgconfig.chkTitle.Checked := inititleVisible;
    dlgconfig.chkName.Checked := iniNameVisible;
    dlgconfig.chkCName.Checked := iniCNameVisible;
    dlgconfig.chkVersion.Checked := iniVersionVisible;

    dlgconfig.chkSaveLaunch.Checked := iniVersionVisible;
//    dlgconfig.ChkPreciseDrop.Checked := iniPreciseDnD;

end;

procedure TfrmMain.getconfigfromdlg();
begin
    iniKenshiFolder:=dlgconfig.edtKenshiFolder.Directory;
    iniUseSteam:=dlgconfig.chkUseSteam.Checked;
    iniSteamWorkshopFolder:=dlgconfig.edtSWFolder.Directory;

    iniSourceVisible:=dlgconfig.chkSource.Checked;
    iniTitleVisible:=dlgconfig.chkTitle.Checked;
    iniNameVisible:=dlgconfig.chkName.Checked;
    iniCNameVisible:=dlgconfig.chkCName.Checked;
    iniVersionVisible:=dlgconfig.chkVersion.Checked;

    iniSaveLaunch := dlgconfig.chkSaveLaunch.Checked;
//    iniPreciseDnD := dlgconfig.ChkPreciseDrop.Checked;

end;

procedure TfrmMain.applyConfig();

procedure SetColumVisibility(column: TVirtualTreeColumn; visible: boolean);
begin
    if visible then
    begin
        if not (coVisible in column.Options) then
           column.Options := column.Options + [coVisible];
    end
    else
    begin
       if coVisible in column.Options then
          column.Options := column.Options - [coVisible];
    end;
end;

begin

  SetColumVisibility(modsview.Header.Columns.Items[2], iniSourceVisible);
  SetColumVisibility(modsview.Header.Columns.Items[3], iniTitleVisible);
  SetColumVisibility(modsview.Header.Columns.Items[4], iniNameVisible);
  SetColumVisibility(modsview.Header.Columns.Items[5], iniCNameVisible);
  SetColumVisibility(modsview.Header.Columns.Items[6], iniVersionVisible);

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

end;

procedure TfrmMain.FormShow(Sender: TObject);
{$ifdef DEBUG}var strdate: string;{$endif}

begin
  {$ifdef DEBUG}
    DateTimeToString (Strdate,'d.mm.yyyy hh:nn',Time);
    Debugln(' ====== New Session ' + strdate);
  {$ENDIF}
  ReadConfig();
  btnLaunchKenshi.Visible := true;
  initList();

  ModsView.NodeDataSize:= SizeOf(TMod);
  ModsView.RootNodeCount := 0;

  if FileExists(iniKenshiFolder + '\kenshi_x64.exe') then
  begin
    refreshlist();
  end
  else
  begin
    setconfigtodlg();
    if dlgConfig.ShowModal = mrOK then
    begin
        getconfigfromdlg();
        refreshlist();
    end;
  end;

  applyConfig();

end;

procedure TfrmMain.ModsViewChecked(Sender: TBaseVirtualTree; Node: PVirtualNode
  );
begin
  modsview.BeginUpdate;

  if Node.CheckState = csCheckedNormal then
  begin
    AddModToActiveindex(modList.Items[Node.Index]);
  end
  else
  begin
     RemoveModFromActiveindex(modList.Items[Node.Index]);
  end;
  modsview.Header.SortColumn := -1;
  modsView.ReinitNode(modsview.RootNode, true);
  modsview.endupdate;
end;

procedure TfrmMain.ModsViewChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  allowed := true;

end;


{DONE -cDragDrop: Check Seulement dans le niveau racine}
{DONE -cDragDrop: Check Pas sur les mods après le dernier mod actif (sinon ca fait une erreur hors index)}

procedure TfrmMain.ModsViewDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
    //Ici c'est uniquement pour savoir si on peut PRENDRE un mod à déplacer.

  Allowed := (Node.CheckState = csCheckedNormal) and canDrag;
  if allowed then
  begin
    {$ifdef DEBUG}
        debugln('Mod Source:');
        debugln(' - Index : ' + inttostr(Node.index));
        debugln(' - Active index : ' + inttostr(modlist.Items[Node.Index].Active_Index));
        debugln(' - Name : ' + modlist.Items[Node.Index].ModName);
        debugln(' - Level : ' + inttostr(Sender.GetNodeLevel(Node)));
    {$endif}
    dragMod := TMod(modlist.Items[Node.Index]);
  end;
end;

procedure TfrmMain.ModsViewDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  const Pt: TPoint; var Effect: DWORD; Mode: TDropMode);
var offset : integer;
    swapitems: boolean;
begin

  //Ici C'est quand on lache le mod.

  {$ifdef DEBUG}
    Debugln('Mod Target:');
    Debugln(' - Index : ' + inttostr(sender.DropTargetNode.Index));
    Debugln(' - Active Index : ' + inttostr(modlist.Items[sender.DropTargetNode.Index].Active_Index));
    Debugln(' - Name : ' + modlist.Items[sender.DropTargetNode.Index].ModName);
  {$ENDIF}

  offset := 0;
  swapitems := false;

    {$ifdef DEBUG}debugln(' - Precise');{$ENDIF}
    Case mode of
    dmAbove: offset := 0;
    dmOnNode: swapitems := true;
    dmBelow: offset := 1;
    dmNowhere: exit();
    end;

  {$ifdef DEBUG}
    Case mode of
    dmAbove: debugln(' - Above');
    dmOnNode: debugln(' - OnNode');
    dmBelow: debugln(' - Below');
    dmNowhere: debugln(' - No where');
    end;
    debugln(' - Offset : ' + inttostr(offset));
  {$ENDIF}

    if (modlist.Items[sender.DropTargetNode.Index].Active_Index < activelist.Count) and (modlist.Items[sender.DropTargetNode.Index].Active_Index > -1) then
    begin
          modsview.BeginUpdate;
          if swapitems then
             SwapMods(dragmod, modlist.items[Sender.DropTargetNode.Index].Active_Index)
          else
              MoveMod(dragmod, modlist.items[Sender.DropTargetNode.Index].Active_Index, offset);

          //Resort();
          modsView.ReinitNode(modsview.RootNode, true);
          modsview.EndUpdate;
    end;
end;

procedure TfrmMain.ModsViewDragOver(Sender: TBaseVirtualTree; Source: TObject;
  Shift: TShiftState; State: TDragState; const Pt: TPoint; Mode: TDropMode;
  var Effect: DWORD; var Accept: Boolean);
begin

  // Ici c'est normalement quand on passe un objet au dessus de la liste.

  accept := (source = Sender);
end;



procedure TfrmMain.ModsViewGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: String);
var i: integer;
    temptext, modtitle: string;
begin
  {DONE 2 -cDependences: Ajouter aussi l'affichage pour les references manquantes}
  if (column > 2) and (column < 6) then
  begin
    if (modList.Items[Node.Index].Dependencies_new.missingList.Count > 0) then
    begin
        HintText := missingdependencies_string;
        for i := 0 to Tmod(modList.Items[Node.Index]).Dependencies_new.missingList.Count - 1 do
        begin
          temptext := Tmod(modList.Items[Node.Index]).Dependencies_new.missingList.Strings[i];
          modtitle := tmod(FindMod(leftstr(temptext, length(temptext)-4))).ModTitle;
          HintText := HintText + LineEnding + modtitle;
        end;
    end;
    if (modList.Items[Node.Index].References_new.missingList.Count > 0) then
    begin
        HintText := HintText + LineEnding + missingreferences_string;
        for i := 0 to Tmod(modList.Items[Node.Index]).References_new.missingList.Count - 1 do
        begin
          temptext := Tmod(modList.Items[Node.Index]).References_new.missingList.Strings[i];
          modtitle := tmod(FindMod(leftstr(temptext, length(temptext)-4))).ModTitle;
          HintText := HintText + LineEnding + modtitle;
        end;
    end;
  end;
  if (column = 6) and (Tmod(modList.Items[Node.Index]).SteamUpdate) then
  begin
    LineBreakStyle:= hlbDefault;
    HintText := steamworshopnewerversion_string + ' ' + inttostr(Tmod(modList.Items[Node.Index]).SteamVersion);
  end;
end;

procedure TfrmMain.ModsViewGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  case column of
  2: case Tmod(modList.Items[Node.Index]).source of
     msSteam: imageindex := 0;
     msKenshiFolder: if modList.Items[Node.Index].HasSteamMod then imageindex := 6 else imageindex := 1;
     msMissing: imageindex := 3;
     end;
  3: if modList.Items[Node.Index].Active and ((modList.Items[Node.Index].Dependencies_new.missingList.Count > 0) or (modList.Items[Node.Index].References_new.missingList.Count > 0))then imageindex := 5;
  4: if modList.Items[Node.Index].Active and ((modList.Items[Node.Index].Dependencies_new.missingList.Count > 0) or (modList.Items[Node.Index].References_new.missingList.Count > 0))then imageindex := 5;
  5: if modList.Items[Node.Index].Active and ((modList.Items[Node.Index].Dependencies_new.missingList.Count > 0) or (modList.Items[Node.Index].References_new.missingList.Count > 0))then imageindex := 5;
  6: if Tmod(modList.Items[Node.Index]).SteamUpdate then
        imageindex := 2;
  end;
end;

procedure TfrmMain.ModsViewGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
    Case column of
    0: celltext := '';
    1: if modList.Items[Node.Index].Active then
        Celltext := inttostr(modList.Items[Node.Index].Active_Index)
       else
        Celltext := '';
    2: Case  modList.Items[Node.Index].Source of
        msSteam: Celltext := steam_string;
        msKenshiFolder: if modList.Items[Node.Index].HasSteamMod then CellText := steam_user_string else CellText := user_string;
        msMissing: CellText := missing_string;
       end;
    3: Celltext := Modlist.Items[Node.Index].Modtitle;
    4: Celltext := Modlist.Items[Node.Index].ModName;
    5: Celltext := Tmod(Modlist.Items[Node.Index]).ModConsolidedName;
    6: if modList.Items[Node.Index].Source = msmissing then celltext := '-' else Celltext := inttostr(modList.Items[Node.Index].Version);
    //Debug Columns
    //7: if modList.Items[Node.Index].SteamVersion <> MOD_NOT_FOUND then
    //        Celltext := inttostr(modList.Items[Node.Index].SteamVersion)
    //   else
    //        CellText := '-';

   // 8: CellText :=  modList.Items[Node.Index].modName;//   if modList.Items[Node.Index].Dependencies_new.rawData <> '' then CellText :=  modList.Items[Node.Index].Dependencies_new.rawData else Celltext := '-';
   // 9: CellText := modList.Items[Node.Index].SteamFile; //if modList.Items[Node.Index].References_new.rawData <> '' then CellText := modList.Items[Node.Index].References_new.rawData else Celltext := '-';
   // 10: CellText := modList.Items[Node.Index].userFile; //if Assigned(modList.Items[Node.Index].References_new.DataList) then CellText := 'Ref nbr: ' + inttostr(modList.Items[Node.Index].References_new.DataList.Count) else CellText := 'Ref not Assigned !!!';
    end;
end;

procedure TfrmMain.ModsViewHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  modsview.BeginUpdate;
  //On met a jour le glyphe
  if (hitinfo.Column < 6) and (hitinfo.Column > 0) then
  if Sender.SortColumn = Hitinfo.Column then
  begin
    if Sender.SortDirection = Virtualtrees.sdDescending then
        Sender.SortDirection := Virtualtrees.sdAscending
    else
        Sender.SortDirection:= Virtualtrees.sdDescending;
  end
  else
  begin
     Sender.SortColumn := HitInfo.Column;
     Sender.SortDirection := Virtualtrees.sdDescending;
  end;

  //On procedre au tri
  Case hitinfo.column of
  1: SortByIndex(Sender.SortDirection = Virtualtrees.sdAscending);
  2: SortBySource(Sender.SortDirection = Virtualtrees.sdAscending);
  3: SortByTitle(Sender.SortDirection = Virtualtrees.sdAscending);
  4: SortByName(Sender.SortDirection = Virtualtrees.sdAscending);
  5: SortByCName(Sender.SortDirection = Virtualtrees.sdAscending);
  end;

  //On verifie si on peut faire ud drag/drop
  canDrag := (Sender.SortColumn = 1) and (Sender.SortDirection = Virtualtrees.sdDescending);
  modsView.ReinitNode(modsview.RootNode, true);
  //modsView.ReinitChildren(modsView.RootNode, true);
  modsview.EndUpdate;
end;

procedure TfrmMain.ModsViewInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
begin
    ChildCount := 0;
end;


procedure TfrmMain.ModsViewInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
    Node.CheckType := ctCheckBox;
    if modList.Items[Node.Index].Active then
        Node.CheckState:= csCheckedNormal
    else
        Node.CheckState:= csUncheckedNormal;
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  Modlist.Clear;
  if iniUseSteam then
      UpdatelistFromSteamWorkshop(iniSteamWorkshopFolder);
  UpdatelistFromKenshiFolder(iniKenshiFolder);
  LoadModList(iniKenshiFolder, ProfileName);
  UpdateActiveModsList();
  ModsView.RootNodeCount:= Modlist.Count;
  Resort();
end;

procedure TfrmMain.ModsViewStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin

end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  WriteConfig();
  ShutdownList();
end;

procedure TfrmMain.actStartKenshiExecute(Sender: TObject);
var kenshiexe, kenshilink: string;
begin

  kenshilink := iniKenshiFolder + '\KMM_kenshi';
  kenshiexe := iniKenshiFolder + '\kenshi_x64.exe';

  if iniSaveLaunch then
     SaveList(iniKenshiFolder, ProfileName);
  if iniUseSteam then
    ShellExecute(0,nil, PChar('cmd'),PChar('/c start steam://rungameid/233860'),nil,1)
  else
  begin
    if not FileExists(kenshilink+'.lnk') then
        CreateDesktopShortCut(kenshiexe,'', kenshilink);
     ShellExecute(0,nil, PChar(kenshilink+'.lnk'),nil,nil,1);
  end;

end;

procedure TfrmMain.ActSyncModExecute(Sender: TObject);
begin
  if modsview.GetNodeLevel(modsview.GetFirstSelected)=0 then
  begin
    if modlist.Items[modsview.GetFirstSelected.Index].SyncMod(iniKenshiFolder) then
        refreshlist();
  end;
end;

procedure TfrmMain.actStartFCSExecute(Sender: TObject);
var kenshiexe, kenshilink: string;
begin
  kenshilink := iniKenshiFolder + '\KMM_FCS';
  kenshiexe := iniKenshiFolder + '\forgotten construction set.exe';

  if iniSaveLaunch then
     SaveList(iniKenshiFolder, ProfileName);

    if not FileExists(kenshilink+'.lnk') then
        CreateDesktopShortCut(kenshiexe,'', kenshilink);
     ShellExecute(0,nil, PChar(kenshilink+'.lnk'),nil,nil,1);
end;


procedure TfrmMain.actSaveOrderExecute(Sender: TObject);
begin
  SaveList(iniKenshiFolder, ProfileName);
end;

procedure TfrmMain.actRevertOrderExecute(Sender: TObject);
begin
  refreshlist();
end;

procedure TfrmMain.actConfigExecute(Sender: TObject);
begin
  setconfigtodlg();
  if dlgConfig.ShowModal = mrOK then
  begin
    getconfigfromdlg();
    applyConfig();
    refreshlist();
    btnLaunchKenshi.Visible := true;
  end;
end;

procedure TfrmMain.actHelpExecute(Sender: TObject);
begin
  OpenURL('http://kmm.laurient.fastmail.net/KMM.html');
end;

procedure TfrmMain.actRemoveModExecute(Sender: TObject);
begin
  if modsview.GetNodeLevel(modsview.GetFirstSelected)=0 then
  begin
    if modlist.Items[modsview.GetFirstSelected.Index].unSyncMod() then
        refreshlist();
  end;
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
begin
  dlgAbout.ShowModal;
end;

end.