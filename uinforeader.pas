unit uInfoReader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TInfoFile = record
    name: String;
    Title: String;
  end;

  function readModInfo(filename: string): TInfoFile;

implementation
    uses DOM, XMLRead, XPath;

    function readModInfo(filename: string): TInfoFile;
    var infofile: Tinfofile;
        Xml: TXMLDocument;
        XPathResult: TXPathVariable;
    begin
      if fileexists(filename) then
      begin
        ReadXMLFile(Xml, filename);
        XPathResult := EvaluateXPathExpression('/ModData/mod', Xml.DocumentElement);
        infofile.name := String(XPathResult.AsText);
        XPathResult.Free;

        XPathResult := EvaluateXPathExpression('/ModData/title', Xml.DocumentElement);
        infofile.title := String(XPathResult.AsText);
        XPathResult.Free;
        xml.free;
      end
      else
      begin
        infofile.name := filename;
        infofile.Title:= 'Info File Not Found';
      end;
      readmodinfo := infofile;
    end;
end.

