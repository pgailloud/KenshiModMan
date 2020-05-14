unit uModReader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TModHeader = record
    filetype: longint;
    version: longint;
    author: String;
    description: String;
    rawdependance: String;
    rawreference: String;
    flags: longint;
    recordsCount: longint;
  end;

  function ReadModHeader(source: TfileStream): TModHeader;

implementation

function readNextInt(source:TFilestream): longint;
var buffer: longint;
begin
     source.read(buffer, sizeof(buffer));
     readNextInt := buffer;
end;

function readNextString(source: TFileStream): String;
var StringSize: integer;
    buffer: String;
begin
    StringSize := readNextint(source);
    if (Stringsize < 0) or (Stringsize > 65000) then
        raise exception.create('Woops. Wrong String size - ' + inttostr(Stringsize));
    setLength(buffer, StringSize);
    if StringSize > 0 then
        source.read(buffer[1], StringSize);
    readNextString := buffer;
end;

function readNextBoolean(source: TFileStream): Boolean;
var buffer: boolean;
begin
    source.read(buffer, sizeof(buffer));
    readNextboolean := buffer;
end;

function readNextFloat(source: TFileStream): Single;
var buffer: Single;
begin
    source.read(buffer, sizeof(buffer));
    readNextfloat := buffer;
end;

function ReadModHeader(source: TfileStream): TModHeader;
var header: TModHeader;
begin
    header.filetype := readNextInt(source);
    if header.filetype <> 16 then Raise exception.create('Save Game file not supported - ' + inttostr(header.filetype));
    header.version := readNextInt(Source);
    header.author := readNextString(Source);
    header.description := readNextString(Source);
    header.rawdependance:= readNextString(Source);
    header.rawreference := readNextString(Source);
    header.flags := readNextInt(Source);
    header.recordsCount:= readNextInt(Source);

    ReadModHeader := header;
end;

end.

