program Girl;

uses
  Forms,
  Girl1 in 'Girl1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
