program FrameDinamico;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, cmdbox, main, theframetwo, theframeone,
  theframethree, theframefour, parsemath2, metodos_cerrados, metodos_abiertos,
  lagra_raphson, trapecio, edo, regresion
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

