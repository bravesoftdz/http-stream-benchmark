program HTTPStreamBenchmark;

uses
  //FastMM4,
  Forms,
  wMain in 'wMain.pas' {fMain},
  UHTTPStreamReader in 'UHTTPStreamReader.pas',
  UHTTPStreamController in 'UHTTPStreamController.pas',
  wSettings in 'wSettings.pas' {fSettings},
  wDebug in 'wDebug.pas' {fDebug};

{$R *.res}

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfMain, fMain);
    Application.Run;
end.
