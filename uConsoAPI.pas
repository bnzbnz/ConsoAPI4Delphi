unit uConsoAPI;

interface
uses RTTI, uJX4Object, uJX4List;

type
  TConsoType = (daily_consumption, consumption_load_curve, consumption_max_power, daily_production, production_load_curve);

  Treading_type = class(TJX4Object)
    &unit: TValue;
    measurement_kind: TValue;
    aggregate: TValue;
    measuring_period: TValue;
  end;

  TData = class(TJX4Object)
    date: TValue;
    value: TValue;
  end;

  TConsoAPIResult = class(TJX4Object)
    status: TValue;
    message: TValue;
    usage_point_id: TValue;
    start: TValue;
    &end: TValue;
    quality: TValue;
    reading_type: Treading_type;
    interval_reading: TJX4List<TData>;
  end;

  function ConsoAPI(Token: string; ConsoType: TConsoType; Prm: string; StartDate, EndDate: TDateTime): TConsoAPIResult;

implementation
uses
    StrUtils
  , SysUtils
  , Classes
  , NetEncoding
  , System.Diagnostics
  , System.Net.URLClient
  , System.Net.HttpClient
  , System.Net.HttpClientComponent
  , NetConsts
  , System.Hash
  ;

function qConsoCom(Verb: string; Token: string; Url: string; ReqST, ResST: TStringStream): integer;
var
  Res: IHTTPResponse;
  Http: THTTPClient;
begin
  Http := THTTPClient.Create;
  try
    Http.UserAgent := 'ConsoAPI4Delphi @ https://github.com/bnzbnz/ConsoAPI4Delphi, Laurent Meyer - ConsoAPI@lmeyer.fr';
    Http.AutomaticDecompression := [THTTPCompressionMethod.Any];
    Http.ContentType := 'application/json';
    Http.CustomHeaders['Authorization'] := 'Bearer '+Token;
    Http.CustomHeaders['From'] := 'Laurent Meyer - ConsoAPI@lmeyer.fr' + Token;
    var Retries := 3;
    repeat
      Dec(Retries);
      if LowerCase(Verb) = 'post' then
      begin
        ReqST.Position := 0; ResST.Position := 0;
        try Res := Http.Post(Url, ReqST, ResST);  except end;
      end else
        try Res := Http.Get(Url, ResST);  except end;

    until ((Res <> nil) or (Retries <= 0));
    if Res = nil then Exit;
    Result := Res.StatusCode;
    for var Cookie in  Http.CookieManager.Cookies do
  finally
    HTTP.Free;
  end;
end;

function ConsoAPI(Token: string; ConsoType: TConsoType; Prm: string; StartDate, EndDate: TDateTime): TConsoAPIResult;
var
  LURL: string;
  LBody: TStringStream;
begin
  LUrl := 'https://conso.boris.sh/api/' + TRttiEnumerationType.GetName(ConsoType)
          + '?prm='   + Prm
          + '&start=' + FormatDateTime('yyyy-mm-dd', StartDate)
          + '&end='   + FormatDateTime('yyyy-mm-dd', EndDate + 1)
          ;

  LBody := TStringStream.Create;
  try
    qConsoCom('GET',Token,  LUrl, Nil, LBody);
    Result := TJX4Object.FromJSON<TConsoAPIResult>(LBody.DataString, [joRaiseException]);
  finally
    LBody.Free;
  end;
end;

end.


