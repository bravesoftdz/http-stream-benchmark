unit wMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, XPMan, StdCtrls, Buttons,
  wSettings, wDebug, UHTTPStreamController, UHTTPStreamReader;

type
  TfMain = class(TForm)
    pnlMain: TPanel;
    pcMainDock: TPageControl;
    bStartStop: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bStartStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fSettings: TfSettings;
    fDebug: TfDebug;

    lThreads: TList;
    bIsStarted: Boolean;

    procedure StartThreads;
    procedure StopThreads;
  public
    procedure Log(Mess: string);
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.bStartStopClick(Sender: TObject);
begin
  if (bIsStarted) then begin
      StopThreads;
      bIsStarted := false;
      bStartStop.Caption := 'Старт';
  end else begin
      StartThreads;
      bIsStarted := true;
      bStartStop.Caption := 'Стоп';
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
    bIsStarted := false;
    lThreads := TList.Create;

    fSettings := TfSettings.Create(Application);
    fSettings.ManualDock(Self.pcMainDock);
    fSettings.Show;

    fDebug := TfDebug.Create(Application);
    fDebug.ManualDock(Self.pcMainDock);
    fDebug.Show;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (bIsStarted) then
        StopThreads;
    FreeAndNil(lThreads);
end;

procedure TfMain.Log(Mess: string);
begin
    fDebug.mLog.Lines.Add(Mess);
end;

procedure TfMain.StartThreads;
var
    i: Integer;
    Stream: THTTPStreamReader;
    URL: string;
begin
    for i := 0 to StrToInt(fSettings.ledThreadsCount.Text) - 1 do begin
        if (i <= fSettings.mURLList.Lines.Count - 1) then begin
            URL := fSettings.mURLList.Lines[i];
            Stream := THTTPStreamReader.Create(i, URL, StrToInt(fSettings.ledMaxSpeed.Text) * 1024);
            Stream.Start;
            lThreads.Add(Stream);
        end else
            Log('End of URL list, cannot start new thread');
    end;
    Log(IntToStr(lThreads.Count) + ' threads started');
end;

procedure TfMain.StopThreads;
var
    i: Integer;
    Stream: THTTPStreamReader;
begin
    for i := lThreads.Count - 1 downto 0 do begin
        Stream := THTTPStreamReader(lThreads[i]);
        Stream.Terminate;
        Stream.WaitFor;
        FreeAndNil(Stream);
        lThreads.Delete(i);
    end;
end;

end.
