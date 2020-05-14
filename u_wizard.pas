unit u_wizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, JvWizard,
  JvWizardRouteMapNodes, JvWizardRouteMapSteps;

type

  { TForm1 }

  TForm1 = class(TForm)
    JvWizard1: TJvWizard;
    JvWizardInteriorPage1: TJvWizardInteriorPage;
    JvWizardInteriorPage2: TJvWizardInteriorPage;
    JvWizardWelcomePage1: TJvWizardWelcomePage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

end.

