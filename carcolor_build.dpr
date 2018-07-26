program carcolor_build;

uses
  Vcl.Forms,
  uFrmMain in 'src\uFrmMain.pas' {frmMain},
  uCommEvents in 'src\utils\uCommEvents.pas',
  uCarColor in 'src\data\uCarColor.pas',
  uCarData in 'src\data\uCarData.pas',
  uCarBase in 'src\data\uCarBase.pas',
  uCharSplit in '..\delphiutils\src\utils\uCharSplit.pas',
  uCarBrandParser in 'src\data\uCarBrandParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
