unit wSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfSettings = class(TForm)
    ledThreadsCount: TLabeledEdit;
    ledMaxSpeed: TLabeledEdit;
    mURLList: TMemo;
    lbURLList: TLabel;
    tbThreadsCount: TTrackBar;
    procedure tbThreadsCountChange(Sender: TObject);
    procedure ledThreadsCountChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSettings: TfSettings;

implementation

{$R *.dfm}

procedure TfSettings.ledThreadsCountChange(Sender: TObject);
begin
    tbThreadsCount.Position := StrToInt(ledThreadsCount.Text);
end;

procedure TfSettings.tbThreadsCountChange(Sender: TObject);
begin
    ledThreadsCount.Text := IntToStr(tbThreadsCount.Position);
end;

end.
