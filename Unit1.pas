unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.DateTimeCtrls, FMX.Edit
  , uJX4Object
  , RTTI
  ;

type

  TSetttings = class(TJX4Object)
      Prm: TValue;
      Token: TValue;
      DateStart: TValue;
      DateEnd: TValue;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    DateStart: TDateEdit;
    Button1: TButton;
    DateEnd: TDateEdit;
    Prm: TEdit;
    Token: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
uses uConsoAPI, DateUtils;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  Res:    TConsoAPIResult;
  Settings: TSetttings;
begin

  Res := ConsoAPI( Token.Text.Trim, daily_consumption, Prm.Text.Trim, DateStart.Date,  DateEnd.Date );

  Memo1.lines.Clear;
  if Res.status.IsEmpty then
  begin
    for var Interval in Res.interval_reading do
      Memo1.Lines.add(Interval.date.AsString + ' : ' + Interval.value.AsString + ' Wh');

    // Save Settings
    Settings := TSetttings.Create;
    Settings.Prm                   :=  Prm.Text.Trim;
    Settings.Token                 := Token.Text.Trim;
    Settings.DateStart.ISO8601Utc  := DateStart.Date;
    Settings.DateEnd.ISO8601Utc    := DateEnd.Date;
    TJX4Object.SaveToFile('ConsoAPI.json', TJX4Object.ToJSON(Settings), TEncoding.UTF8);
    Settings.Free;
   //

  end  else
    Memo1.Lines.add('Error: ' + UTF8Decode(Res.message.AsString));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Json: string;
  Settings: TSetttings;
begin
  Settings := Nil;
  DateStart.Date := Now - 10;
  DateEnd.Date := Now;

  // Load Settings
  try
  try
    TJX4Object.LoadFromFile('ConsoAPI.json', Json, TEncoding.UTF8);
    Settings        := TJX4Object.FromJson<TSetttings>(Json);
    Prm.Text        := Settings.Prm.AsString;
    Token.Text      := Settings.Token.AsString;
    DateStart.Date  := Settings.DateStart.ISO8601Utc;
    DateEnd.Date    := Settings.DateEnd.ISO8601Utc;
  except end;
  finally
    Settings.Free;
  end;
end;

end.
