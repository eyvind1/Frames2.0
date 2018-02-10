unit theframeone;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls;

type

  { TTheFrame1 }

  TTheFrame1 = class(TFrame)
    Label1: TLabel;

    suma: TLabel;
    procedure sumaClick(Sender: TObject);
    function suma2(a:real;b:real):real;
  private

  public

  end;

implementation

{$R *.lfm}

{ TTheFrame1 }

procedure TTheFrame1.sumaClick(Sender: TObject);
begin

end;

function TTheFrame1.suma2(a:real;b:real):real;
begin
  Result :=a+b;
end;

end.

