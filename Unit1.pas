unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.DateTimeCtrls, FMX.Edit;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    DateStart: TDateEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    DateEnd: TDateEdit;
    Label3: TLabel;
    Label4: TLabel;
    Prm: TEdit;
    Token: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
uses uConsoAPI, DateUtils, uJX4Object;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
 var
  Res:    TConsoAPIResult;
begin

  Res := ConsoAPI( Token.Text, daily_consumption, Prm.Text, DateStart.Date,  DateEnd.Date );

  Memo1.lines.Clear;
  if Res.status.IsEmpty then
    for var Interval in Res.interval_reading do
      Memo1.Lines.add(Interval.date.AsString + ' : ' + Interval.value.AsString + ' Wh')
  else
    Memo1.Lines.add('Error: ' + UTF8Decode(Res.message.AsString));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DateStart.Date := Now - 10;
  DateEnd.Date := Now;
  Token.Text := {$INCLUDE Token.inc};
  Prm.Text := {$INCLUDE Prm.inc};
end;

end.
