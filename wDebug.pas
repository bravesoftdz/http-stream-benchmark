unit wDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfDebug = class(TForm)
    mLog: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDebug: TfDebug;

implementation

{$R *.dfm}

end.
