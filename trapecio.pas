unit trapecio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, Dialogs;
type
  TIntegrales=class

  private
  public
    function f(valor:real;s:string):real;
    function trapecio(s:string;a:real;b:real;parti:integer):real;
    function simpson(s:string;a:real;b:real;parti:integer):real;
  end;

implementation
var
  check: boolean;
function TIntegrales.f(valor:real;s:string):real;
var MiParse: TParseMath;
   begin
     MiParse:= TParseMath.create();
     MiParse.AddVariable('x',valor);
     MiParse.Expression:= s;
     check:=false;
     try
       result:=MiParse.Evaluate();
     except
       begin
       ShowMessage('La funcion no es continua en el punto '+FloatToStr(valor));
       check:=true;
       end;
     end;

     MiParse.destroy;

end;

function TIntegrales.trapecio(s:string;a:real;b:real;parti:integer):real  ;
var i :integer;
var h,rpta,xn :real;
begin
  h:=(b-a)/parti;
  rpta:=0;
  xn:=a+h;
  for i:=1 to parti-1 do begin
     rpta:=rpta+ f(xn,s);
     xn:=xn+h;
  end;
  Result:=h/2*(f(a,s)+f(b,s)+2*rpta)

end;

function TIntegrales.simpson(s:string;a:real;b:real;parti:integer):real;
var i,j :Integer;
var h,acum,rpta,xn,xna:real;
begin
  h:=(b-a)/(2*parti);
  rpta:=0;
  acum:=0;
  i:=2;
  j:=1;
  xna:= a+(2*h);
  xn:= a+h;
  while i<(parti*2) do begin
     rpta:=rpta+f(xna,s);
     xna:=xna+(2*h);
     i:=i+2;
  end;
  while j<(parti*2) do begin
     acum:=acum+f(xn,s);
     xn:=xn+(2*h);
     j:=j+2;
  end;
  Result:=h/3*(f(a,s)+f(b,s)+(2*rpta)+(4*acum));

end;

end.

