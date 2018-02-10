unit metodos_abiertos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, Dialogs;

type
  TAbiertos=class
  La : TStringList;
  Lb : TStringList;
  datos : TStringList;
  Lsig : TStringList;
  Le : TStringList;
  parse: TParseMath;
  MetodoType: Integer;
  private
    ErrorCal: real;
    step : real;
  public
    function ejecutarAbiertos(iA, eError: Double; ecuacion, decuacion:String): Double;
    constructor create;
    destructor Destroy; override;
    function evaluar(x: Double): Double;
    function newtonn(iA, eError:Double; ecuacion, decuacion:String): Double;
    function m_secante(iA,eError:Double;ecuacion:string):real;
    function f(valor:real;s:string):real;
end;

  const
    F_New = 0;
    F_S = 1;

implementation

 var
   check : boolean;

const
  max_iteration = 100000;


  constructor TAbiertos.create();
   begin
     parse:= TParseMath.create();
     datos:= TStringList.Create;
     La:= TStringList.Create;
     Lb:= TStringList.Create;
     Lsig:= TStringList.Create;
     Le:= TStringList.Create;
     ErrorCal := 1000000;
     step :=0;
   end;

   destructor TAbiertos.Destroy;
   begin
     parse.destroy;
     datos.Destroy;
     La.Destroy;
     Lb.Destroy;
     Lsig.Destroy;
     Le.Destroy;
   end;

function TAbiertos.f(valor:real;s:string):real;
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

function TAbiertos.evaluar(x:Double): Double;
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

function TAbiertos.ejecutarAbiertos(iA, eError: Double; ecuacion, decuacion:String): Double;
begin
     case MetodoType of
       F_New: Result:= newtonn(iA, eError, ecuacion, decuacion);
       F_S: Result:= m_secante(iA, eError, ecuacion);
     end;
end;

function TAbiertos.newtonn(iA, eError:Double; ecuacion, decuacion:String): Double;
var StayInWhile: Boolean;
var xn,xnant : real;
begin
  datos.Clear;
  datos.Add('');
  Le.Add('');
  step:= 0;
  xn:=iA;
  datos.Add(FloatToStr( xn ));
  Le.Add('');
  StayInWhile:= ( ErrorCal >= eError );
  while StayInWhile do begin
      xnant:= xn;
      xn := xn-(f(xn,ecuacion)/f(xn,decuacion));

      datos.Add( FloatToStr( xn ) );
      ErrorCal:= abs( xn - xnant );
      Le.Add(FloatToStr(ErrorCal));
      step:= step + 1;
      StayInWhile:= ( ErrorCal >= eError ) and (step < max_iteration);
  end;
  Result:= xn;


end;

function TAbiertos.m_secante(iA, eError:Double;ecuacion:string):real;
var h, xn,xnant:real;
var StayInWhile:Boolean;
begin
  datos.Clear;
  h:=0.000001;
  datos.Add('');
  Le.Add('');
  step:=0;
  xn:=iA;
  datos.Add(FloatToStr( xn ));
  Le.Add('');
  StayInWhile:=(ErrorCal >= eError);
  while StayInWhile do begin
      xnant:=xn ;
      xn := xn-(((2*h)*f(xn,ecuacion))/(f(xn+h,ecuacion)-f(xn-h,ecuacion)));
      datos.Add(FloatToStr(xn));
      ErrorCal:= abs(xn-xnant);
      Le.Add(FloatToStr(ErrorCal));
      step:=step+1;
      StayInWhile:=(ErrorCal >= eError)and(step<max_iteration);
  end;
  Result:=xn;
end;





end.

