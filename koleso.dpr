program koleso;

uses
  Vcl.Forms,
  zubkoleso in 'zubkoleso.pas' {Form1},
  raschet in '..\��������\4 �������\������������������ �������������� �������\��\raschet.pas',
  CosmosWorksLib_TLB in '..\..\Documents\Embarcadero\Studio\17.0\Imports\CosmosWorksLib_TLB.pas',
  CommonUnit in '..\SWSimulation-master\SWSimulation-master\CommonUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
