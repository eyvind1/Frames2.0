unit metodos_cerrados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, ParseMath, Dialogs;

type
  TCerrados=class
  La : TStringList;
  Lb : TStringList;
  Lsig : TStringList;
  Le : TStringList;
  datos : TStringList;
  s : string;
  //Error : real;
  parse: TParseMath;
  MetodoType: Integer;
  private
  public
    function f(valor:real):real;
    function ejecutarCerrados(iA, iB, eError: Double; ecuacion: String): Double;
    constructor create;
    destructor Destroy; override;
    function evaluar(x: Double): Double;
    function bisection(iA, iB, eError: Double; ecuacion: String): Double;
    function false_position(iA, iB, eError: Double; ecuacion: String): Double;
  end;

const
  F_BIS = 0;
  F_FP = 1;

var
  check : boolean;

implementation

const
  max_iteration = 100000;

constructor TCerrados.create();
  begin
    parse:= TParseMath.create();
    datos:= TStringList.Create;
    La:= TStringList.Create;
    Lb:= TStringList.Create;
    Lsig:= TStringList.Create;
    Le:= TStringList.Create;
  end;

  destructor TCerrados.Destroy;
  begin
    parse.destroy;
    datos.Destroy;
    La.Destroy;
    Lb.Destroy;
    Lsig.Destroy;
    Le.Destroy;
  end;

  function TCerrados.evaluar(x:Double): Double;
begin
  try
    parse.NewValue('x', x);
    Result:= parse.Evaluate();
  except
    ShowMessage('La funcion no es continua');
    datos.Add('La funcion no es continua');
    Exit;
  end;
end;
  function TCerrados.ejecutarCerrados(iA, iB, eError: Double; ecuacion: String): Double;
  begin
    case MetodoType of
      F_BIS: Result:= bisection(iA, iB, eError, ecuacion);
      F_FP: Result:= false_position(iA, iB, eError, ecuacion);
    end;
  end;

function TCerrados.f(valor:real):real;
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

function TCerrados.bisection(iA, iB, eError: Double; ecuacion: String): Double;
var error, tmp: Double;
  function xn(iA, iB: Double): Double;
  begin
    Result:= (iA + iB) / 2;
  end;

begin
  La.Clear;
  Lb.Clear;
  datos.Clear;
  Lsig.Clear;
  Le.Clear;
  La.Add('');
  Lb.Add('');
  Lsig.Add('');
  Le.Add('');
  datos.Add('');
  parse:= TParseMath.create();
  parse.AddVariable('x', 0.0);
  parse.Expression:= ecuacion;
  if evaluar(iA) = 0 then begin
    La.Add(FloatToStr(iA));
    Lb.Add(FloatToStr(iB));
    datos.Add(FloatToStr(iA));
    Result:= iA;
    Exit;
  end;

  if evaluar(iB) = 0 then begin
    La.Add(FloatToStr(iA));
    Lb.Add(FloatToStr(iB));
    datos.Add(FloatToStr(iB));
    Result:= iB;
    Exit;
  end;

  if evaluar(iA) * evaluar(iB) > 0 then begin
    ShowMessage('No se cumple bolzano');
    datos.Add('No se cumple bolzano');
  end;

  tmp:= xn(iA, iB);
  La.Add(FloatToStr(iA));
  Lb.Add(FloatToStr(iB));
  datos.Add(FloatToStr(tmp));
  Lsig.Add(FloatToStr(Sign(evaluar(iA) * evaluar(tmp))));
  Le.Add('-');

  if evaluar(iA) * evaluar(tmp) > 0 then iA:= tmp else iB:= tmp;
  error:= 1;
  while error > eError do begin
     if evaluar(iA) = 0 then begin
        La.Add(FloatToStr(iA));
        Lb.Add(FloatToStr(iB));
        datos.Add(FloatToStr(iA));
        Result:= iA;
        Exit;
     end;

     if evaluar(iB) = 0 then begin
        La.Add(FloatToStr(iA));
        Lb.Add(FloatToStr(iB));
        datos.Add(FloatToStr(iB));
        Result:= iB;
        Exit;
     end;

     error:= abs(tmp - xn(iA, iB));
     tmp:= xn(iA, iB);
     La.Add(FloatToStr(iA));
     Lb.Add(FloatToStr(iB));
     datos.Add(FloatToStr(tmp));
     Lsig.Add(FloatToStr(sign(evaluar(iA)*evaluar(tmp))));
     Le.Add(FloatToStr(error));
     if evaluar(iA)*evaluar(tmp) > 0 then iA:= tmp else iB:= tmp;
  end;
  Result:= tmp;
end;

function TCerrados.false_position(iA, iB, eError: Double; ecuacion: String): Double;
var error, tmp: Double;
  function xn(iA, iB: Double): Double;
  begin
    parse:= TParseMath.create();
    parse.AddVariable('x', 0.0);
    parse.Expression:= ecuacion;
    Result:= iA - (evaluar(iA) * (iB - iA))/(evaluar(iB) - evaluar(iA));
  end;

begin
  La.Clear;
  Lb.Clear;
  datos.Clear;
  Lsig.Clear;
  Le.Clear;
  La.Add('');
  Lb.Add('');
  Lsig.Add('');
  Le.Add('');
  datos.Add('');
  parse:= TParseMath.create();
  parse.AddVariable('x', 0.0);
  parse.Expression:= ecuacion;
  if evaluar(iA) = 0 then begin
    La.Add(FloatToStr(iA));
    Lb.Add(FloatToStr(iB));
    datos.Add(FloatToStr(iA));
    Result:= iA;
    Exit;
  end;

  if evaluar(iB) = 0 then begin
    La.Add(FloatToStr(iA));
    Lb.Add(FloatToStr(iB));
    datos.Add(FloatToStr(iB));
    Result:= iB;
    Exit;
  end;

  if evaluar(iA) * evaluar(iB) > 0 then begin
    ShowMessage('No se cumple bolzano');
    datos.Add('No se cumple bolzano');
  end;

  tmp:= xn(iA, iB);
  La.Add(FloatToStr(iA));
  Lb.Add(FloatToStr(iB));
  datos.Add(FloatToStr(tmp));
  Lsig.Add(FloatToStr(Sign(evaluar(iA) * evaluar(tmp))));
  Le.Add('-');

  if evaluar(iA) * evaluar(tmp) > 0 then iA:= tmp else iB:= tmp;
  error:= 1;
  while error > eError do begin
     if evaluar(iA) = 0 then begin
        La.Add(FloatToStr(iA));
        Lb.Add(FloatToStr(iB));
        datos.Add(FloatToStr(iA));
        Result:= iA;
        Exit;
     end;

     if evaluar(iB) = 0 then begin
        La.Add(FloatToStr(iA));
        Lb.Add(FloatToStr(iB));
        datos.Add(FloatToStr(iB));
        Result:= iB;
        Exit;
     end;

     error:= abs(tmp - xn(iA, iB));
     tmp:= xn(iA, iB);
     La.Add(FloatToStr(iA));
     Lb.Add(FloatToStr(iB));
     datos.Add(FloatToStr(tmp));
     Lsig.Add(FloatToStr(sign(evaluar(iA)*evaluar(tmp))));
     Le.Add(FloatToStr(error));
     if evaluar(iA)*evaluar(tmp) > 0 then iA:= tmp else iB:= tmp;
  end;
  Result:= tmp;
end;









end.



