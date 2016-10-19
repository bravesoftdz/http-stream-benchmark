unit UHTTPStreamReader;

interface

uses
  Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF}, SysUtils,
  IdIntercept, IdInterceptThrottler, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TTestStream = class(TCustomMemoryStream)
  private
    FPosition: Longint;
    //procedure SetCapacity(NewCapacity: Longint); override;
  public
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

  THTTPStreamReader = class(TThread)
  protected
    procedure Execute; override;
  private
    procedure OnHTTPProgress(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure Log;
  public
    idHTTP: TIdHTTP;
    idInterceptThrottler: TIdInterceptThrottler;
    m_sNum: Integer;
    m_sURL: string;
    m_uMaxSpeed: UInt64;
    m_uResponseCode: Int64;
    m_uResponseContentLength: Int64;
    m_uStartPosition: Int64;
    m_uEndPosition: Int64;
    m_lastError: string;
    m_sLastMessage: string;
    m_sNullStream: TTestStream;
    constructor Create(Num: Integer; URL: string; MaxSpeed: UInt64);
    destructor Destroy(); override;
  end;

implementation

uses
  wMain, IdHTTPHeaderInfo;

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure HTTPStreamReader.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{procedure TTestStream.SetCapacity(NewCapacity: Longint);
begin
  //
end;   }

function TTestStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := Count;
end;

function TTestStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
    case Origin of
        soFromBeginning: FPosition := Offset;
        soFromCurrent: Inc(FPosition, Offset);
        //soFromEnd: FPosition := FSize + Offset;
    end;
    Result := FPosition;
end;

{ HTTPStreamReader }

constructor THTTPStreamReader.Create(Num: Integer; URL: string; MaxSpeed: UInt64);
begin
    inherited Create(true);
    m_sNum := Num;
    m_sURL := URL;
    m_uMaxSpeed := MaxSpeed;
    m_sNullStream := TTestStream.Create;
    Self.FreeOnTerminate := false;
end;

destructor THTTPStreamReader.Destroy();
begin
    if (Assigned(idHTTP)) then
        FreeAndNil(idHTTP);
    if (Assigned(idInterceptThrottler)) then
        FreeAndNil(idInterceptThrottler);
    if (Assigned(m_sNullStream)) then
        FreeAndNil(m_sNullStream);
    inherited Destroy;
end;

procedure THTTPStreamReader.Execute;
var
    idRange: TIdEntityRange;
begin
    NameThreadForDebugging('HTTPStreamReader-' + IntToStr(m_sNum));

    idInterceptThrottler := TIdInterceptThrottler.Create(nil);
    idInterceptThrottler.BitsPerSec := m_uMaxSpeed;

    idHTTP := TIdHTTP.Create(nil);
    idHTTP.Intercept := idInterceptThrottler;
    idHTTP.OnWork := Self.OnHTTPProgress;

    Randomize;

    try
        idHTTP.Head(m_sURL);
        m_uResponseCode := idHTTP.Response.ResponseCode;
        m_uResponseContentLength := idHTTP.Response.ContentLength;

        m_uStartPosition := Random(m_uResponseContentLength div 4);
        m_uEndPosition := m_uStartPosition + ((100 + Random(100)) * 1024 * 1024);
        //m_uEndPosition := m_uResponseContentLength - 1;

        while (not Terminated) do
        begin
            idHTTP.Request.Ranges.Clear;
            idRange := IdHTTP.Request.Ranges.Add;
            idRange.StartPos := m_uStartPosition;
            idRange.EndPos := m_uEndPosition;

            m_sLastMessage := 'Thread #' + IntToStr(m_sNum) + ' :: Start: ' + IntToStr(m_uStartPosition) + '; End: ' + IntToStr(m_uEndPosition) + '; Code: ' + IntToStr(m_uResponseCode);
            Synchronize(Log);

            idHTTP.Get(m_sURL, m_sNullStream);

            if (m_uEndPosition <= m_uResponseContentLength) then
                m_uStartPosition := m_uEndPosition
            else
                m_uStartPosition := 0;

            m_uEndPosition := m_uStartPosition + ((100 + Random(100)) * 1024 * 1024);
        end;
    except
        on E: Exception do begin
            m_lastError := E.ClassName + ': ' + E.Message;
            Synchronize(
                procedure begin
                    fMain.Log(m_lastError);
                end
            );
        end;
    end;
end;

procedure THTTPStreamReader.OnHTTPProgress(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
    if Self.Terminated then begin
        if (idHTTP.Connected) then begin
            idHTTP.Disconnect;
            idHTTP.IOHandler.InputBuffer.Clear;
            if (idHTTP.Connected) then
                Abort;
        end;
    end;
end;

procedure THTTPStreamReader.Log;
begin
    fMain.Log(m_sLastMessage);
end;

end.
