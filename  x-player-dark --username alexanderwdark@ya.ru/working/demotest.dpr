program demotest;

uses
  Forms,
  demo in 'demo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'XARC';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
