program SWAPI_Delphi;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {MainFormMenu};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFormMenu, MainFormMenu);
  Application.Run;
end.
