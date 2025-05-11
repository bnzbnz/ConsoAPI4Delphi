program Project1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uConsoAPI in 'uConsoAPI.pas',
  uJX4Dict in 'uJsonX4\uJX4Dict.pas',
  uJX4List in 'uJsonX4\uJX4List.pas',
  uJX4Object in 'uJsonX4\uJX4Object.pas',
  uJX4Rtti in 'uJsonX4\uJX4Rtti.pas',
  uJX4Value in 'uJsonX4\uJX4Value.pas',
  uJX4YAML in 'uJsonX4\uJX4YAML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
