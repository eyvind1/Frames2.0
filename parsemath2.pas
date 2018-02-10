unit parsemath2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, fpexprpars, FileUtil, uCmdBox, TAGraph, Forms, Controls, Graphics,
Dialogs, ComCtrls, Grids, ValEdit, ExtCtrls, ShellCtrls, EditBtn, Menus, StdCtrls, metodos_cerrados,
 metodos_abiertos, trapecio, edo, theframeone, theframetwo, theframethree, theframefour, regresion;



//type
  //matrix=array[1..20] of Tmatriz;

type
  TParseMath = Class

    //Panel2: TPanel;


  Private

      FParser: TFPExpressionParser;
      identifier: array of TFPExprIdentifierDef;
      Procedure AddFunctions();
      //procedure InstanFrame;

  Public
      Expression: string;
      respuesta:String;
      function NewValue( Variable:string; Value: Double ): Double;
      function NewValuestring( Variable: string; Value: String ): String;
      procedure AddVariable( Variable: string; Value: Double );
      function Evaluate(): Double;
      procedure AddVariableString( Variable: string; Value: String );
      constructor create();
      function EvaluateString(): String;
      destructor destroy;
  end;

const IsFrame1 = 1;
      IsFrame2 = 2;
      IsFrame3 = 3;
      IsFrame4 = 4;
var
  //matPloteoXY : TMatriz;
  A,B,Error,error2,anterior,funct,x,xn_0,xn_1,signo:Double;
  i,j,tam:Integer;
  number, zero : Integer;
  MiParse: TParseMath;
  f,d:String;
  GuarFuncion,GuarIni,GuarFin,GuarH: TStringList;
  ActualFrame: Tframe;
  FrameSelected: Integer;

implementation
uses main;

constructor TParseMath.create();
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [bcMath];
   AddFunctions();
   GuarFuncion:= TStringList.Create;
   GuarIni:=TStringList.Create;
   GuarFin:=TStringList.Create;
   GuarH:= TStringList.Create;
end;

destructor TParseMath.Destroy;
begin
   GuarFuncion.Destroy;
   GuarIni.Destroy;
   GuarFin.Destroy;
   GuarH.Destroy;
   FParser.Destroy;
end;

procedure InstanFrame;
begin
   if Assigned(ActualFrame) then
     ActualFrame.Free;

   case FrameSelected of
       IsFrame1: ActualFrame:= TTheFrame1.Create( Form1.Panel2 );
       IsFrame2: ActualFrame:= TTheFrame2.Create( Form1.Panel2 );
       IsFrame3: ActualFrame:= TTheFrame3.Create( Form1.Panel2 );
       IsFrame4: ActualFrame:= TTheFrame4.Create( Form1.Panel2 );
   end;

   ActualFrame.Parent:= Form1.Panel2;
   ActualFrame.Align:= alClient;

end;


Function funcion(x:Double;f:String):Double;
begin
  try
     MiParse:= TParseMath.create();
     MiParse.AddVariable( 'x', x );
     MiParse.Expression:= f;//cboFuncion.Text;
     funct:=MiParse.Evaluate();
     funcion:=funct;
     except
     funcion:=0;
     Exit;
  end;
end;

Function funcion2(x,y:Double;f:String):Double;
begin
  try
     MiParse:= TParseMath.create();
     MiParse.AddVariable( 'x', x );
     MiParse.AddVariable( 'y', y );
     MiParse.Expression:= f;//cboFuncion.Text;
     funct:=MiParse.Evaluate();
     funcion2:=funct;
     except
     funcion2:=0;
     Exit;
  end;




end;



function derivada(x:Double;f:String):Double;
var
  h:Float;
Begin
  h:=0.01;
  derivada:=(funcion(x+h,f)-funcion(x,f))/h;
 // ShowMessage(FloatToStr(derivada));
end;

function derivada1(x:Double;f:String;e:Double):Double;
var
  h:Float;
Begin
  h:=e/10;
  derivada1:=x-(h*funcion(x,f))/(funcion(x+h,f)-funcion(x,f));
 // ShowMessage(FloatToStr(derivada));
end;

function derivada2(x:Double;f:String;e:Double;x0:Double):Double;
var
  h:Float;
Begin
  h:=e/10;
  derivada2:=x-(funcion(x,f)*(x-x0))/(funcion(x,f)-funcion(x0,f));
  //ShowMessage(FloatToStr(derivada));
end;

function derivada3(x:Double;f:String;e:Double):Double;
var
  h:Float;
Begin
  h:=e/10;
  derivada3:=x-(2*h*funcion(x,f))/(funcion(x+h,f)-funcion(x-h,f));
 // ShowMessage(FloatToStr(derivada));
end;


Procedure ExprTrapecio( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  Integrales : TIntegrales;
  la,i,h,lb,resp,fa,fb,sum:Double;
  n:integer;
  f:String;
begin
  Integrales:=TIntegrales.create;
  f:=Args[0].ResString;
  la:=ArgToFloat( Args[ 1 ] );
  lb:=ArgToFloat( Args[ 2 ] );
  n:=Args[ 3 ].ResInteger;

  Result.resFloat := Integrales.trapecio(f,la,lb,n);

end;

Procedure ExprSimpsonSimple( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  m_function:TParseMath;
  la,i,h,lb,resp,fa,fb,sump,sumi:Float;
  n:float;
begin
  f:=Args[0].ResString;
  m_function:= TParseMath.create();
   m_function.AddVariable( 'x', 0 );
   m_function.Expression:= f;
   la:=ArgToFloat( Args[ 1 ] );
   lb:=ArgToFloat( Args[ 2 ] );
   n:=ArgToFloat( Args[ 3 ] );


  h:=(lb-la)/3;
  m_function.NewValue('x',la);
  fa:=m_function.Evaluate();
  m_function.NewValue('x',lb);
  fb:=m_function.Evaluate();
  sump:=0;
  sumi:=0;



  sump:=(2*la+lb)/3;
  m_function.NewValue('x',sump);
    sump:=m_function.Evaluate();

  sumi:=(la+2*lb)/3;
    m_function.NewValue('x',sumi);
    sumi:=m_function.Evaluate();
  resp:=RoundTo((3*h/8)*(fa+fb)+(9*h/8)*sump+(9*h/8)*sumi,-6);
  Result.ResFloat:=(resp);

end;

Procedure ExprSimpson38( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  m_function:TParseMath;
  la,i,h,lb,resp,fa,fb,sump,sumo,sumi:Float;
  n,temp:Integer;
begin

     f:=Args[0].ResString;
  m_function:= TParseMath.create();
   m_function.AddVariable( 'x', 0 );
   m_function.Expression:= f;
   la:=ArgToFloat( Args[ 1 ] );
   lb:=ArgToFloat( Args[ 2 ] );
   n:=Args[ 3 ].ResInteger;



  h:=(lb-la)/n;
  m_function.NewValue('x',la);
  fa:=m_function.Evaluate();
  m_function.NewValue('x',lb);
  fb:=m_function.Evaluate();
  sump:=0;
  sumi:=0;
  sumo:=0;


  i:=la+h;
  repeat
    m_function.NewValue('x',i);
    sumo:=sumo+m_function.Evaluate();
    i:=i+3*h;

  until (i>lb-2*h);

  i:=la+2*h;
  repeat
    m_function.NewValue('x',i);
    sumi:=sumi+m_function.Evaluate();
    i:=i+3*h;
  until (i>lb-h);

  i:=la+3*h;
  repeat
    m_function.NewValue('x',i);
    sump:=sump+m_function.Evaluate();
    i:=i+3*h;

  until (i>lb-3*h);

  resp:=RoundTo((3*h/8)*(fa+fb)+(9*h/8)*sumo+(9*h/8)*sumi+(6*h/8)*sump,-6);

  Result.ResFloat:=(resp);
end;

Procedure ExprSimpson13( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  Integral :TIntegrales;
  la,i,h,lb,resp,fa,fb,sump,sumi:Float;
  n:integer;

begin

   Integral:=TIntegrales.create;
   f:=Args[0].ResString;
   la:=ArgToFloat( Args[ 1 ] );
   lb:=ArgToFloat( Args[ 2 ] );
   n:=Args[ 3 ].ResInteger;
  Result.ResFloat:= Integral.simpson(f,la,lb,n) ;
end;



Procedure ExprEuler( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  Edo:TEdo;
  f,res:String;
  yn1,x0,y0,h,y,x,xf,aprox,pendiente:Double;
  n:float;
begin
    Edo:= Tedo.create;
    f:=Args[0].ResString;
    x0 := ArgToFloat( Args[ 1 ] );
    y0:= ArgToFloat( Args[ 2 ] );
    n:= ArgToFloat ( Args[ 3 ]);

    Result.ResFloat:=Edo.euler(f,x0,y0,n);
end;

{Procedure ExprEuler( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  m_function:TParseMath;
  f,res:String;
  yn1,x0,y0,h,y,x,xf,aprox,pendiente:Double;
  n:Integer;
  resul:TEDO;
begin
  matPloteoXY := TMatriz.create;
    f:=Args[0].ResString;
    x0 := ArgToFloat( Args[ 1 ] );
    xf := ArgToFloat( Args[ 2 ] );
    y0:= ArgToFloat( Args[ 3 ] );
    n:= Args[4].ResInteger;
    resul:=TEDO.create(f,x0,xf,y0);
   res:=resul.Euler();
    matPloteoXY.asignar(resul.matrizXY);
    Result.ResString:=res;
end;}
Procedure ExprHeun( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  Edo:Tedo;
  f,res:String;
  yn1,x0,y0,h,y,x,xf,aprox,pendiente:Double;
  n:float;

begin
    Edo:= TEdo.create;
    f:=Args[0].ResString;
    x0:= ArgToFloat( Args[ 1 ] );
    y0:= ArgToFloat( Args[ 2 ] );
    n := ArgToFloat( Args[ 3 ] );
    Result.ResFloat:=Edo.heun(f,x0,y0,n);
end;

{Procedure ExprHeun( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  m_function:TParseMath;
  f,res:String;
  yn1,x0,y0,h,y,x,xf,aprox,pendiente:Double;
  n:Integer;
  resul:TEDO;
begin
 matPloteoXY := TMatriz.create;
    f:=Args[0].ResString;
    x0 := ArgToFloat( Args[ 1 ] );
    xf := ArgToFloat( Args[ 2 ] );
    y0:= ArgToFloat( Args[ 3 ] );
    n:= Args[4].ResInteger;
    resul:=TEDO.create(f,x0,xf,y0);
   res:=resul.Heun();
    matPloteoXY.asignar(resul.matrizXY);
    Result.ResString:=res;
end;

Procedure ExprDormand( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  m_function:TParseMath;
  f,res:String;
  k1,k2,k3,k4,x0,y0,h,y,x,temp,xf,pendiente:Double;
  n:Integer;
  resul:TEDO;
begin
  matPloteoXY := TMatriz.create;
    f:=Args[0].ResString;
    x0 := ArgToFloat( Args[ 1 ] );
    xf := ArgToFloat( Args[ 2 ] );
    y0:= ArgToFloat( Args[ 3 ] );
    n:= Args[4].ResInteger;
    resul:=TEDO.create(f,x0,xf,y0);
   res:=resul.Dormand();
    matPloteoXY.asignar(resul.matrizXY);
    Result.ResString:=res;
end;}
 Procedure ExprRungeKutta4( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  Edo : TEdo;
  f,res:String;
  k1,k2,k3,k4,x0,y0,h,y,x,temp,xf,pendiente:Double;
  n:Integer;

begin
    Edo := TEdo.create;
    f :=Args[0].ResString;
    x0:= ArgToFloat( Args[ 1 ] );
    y0:= ArgToFloat( Args[ 2 ] );
    n := Args[ 3 ].ResInteger;
    Result.ResFloat:=Edo.runge_kutta4(f,x0,y0,n);
end;

{Procedure ExprRungeKutta4( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  m_function:TParseMath;
  f,res:String;
  k1,k2,k3,k4,x0,y0,h,y,x,temp,xf,pendiente:Double;
  n:Integer;
  resul:TEDO;
begin
      matPloteoXY := TMatriz.create;
    f:=Args[0].ResString;
    x0 := ArgToFloat( Args[ 1 ] );
    xf := ArgToFloat( Args[ 2 ] );
    y0:= ArgToFloat( Args[ 3 ] );
    n:= Args[4].ResInteger;
    resul:=TEDO.create(f,x0,xf,y0);
   res:=resul.RungeKutta4();
    matPloteoXY.asignar(resul.matrizXY);
    Result.ResString:=res;
end;
 }



function TParseMath.NewValue( Variable: string; Value: Double ): Double;
begin
    FParser.IdentifierByName(Variable).AsFloat:= Value;

end;

function TParseMath.NewValuestring( Variable: string; Value: String ): String;
begin
    FParser.IdentifierByName(Variable).AsString:= Value;

end;


Procedure ExprBiy( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Cerrado:TCerrados ;

begin
     Cerrado:=TCerrados.create;
     A:=ArgToFloat( Args[ 1 ] );
     B:=ArgToFloat(Args[2]);
     Error:=ArgToFloat( Args[ 3 ] );
     f:=Args[0].ResString;
     Result.resFloat:=Cerrado.bisection(A,B,Error,f);


end;

Procedure ExprFP( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Cerrado:TCerrados;
begin
     Cerrado:=TCerrados.create;
     A:=ArgToFloat( Args[ 1 ] );
     B:=ArgToFloat(Args[2]);
     Error:=ArgToFloat( Args[ 3 ] );
     f:=Args[0].ResString;
     Result.resFloat:=Cerrado.false_position(A,B,Error,f);
end;

Procedure ExprSecante( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Abierto:TAbiertos;
begin
     Abierto:=TAbiertos.create;
     //B:=( Args[ 1 ].ResInteger );
     A:=ArgToFloat(Args[1]);
     Error:=ArgToFloat( Args[ 2 ] );
     f:=Args[0].ResString;
     Result.resFloat:=Abierto.m_secante(A,Error,f);
end;


Procedure ExprNewton( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var Abierto:TAbiertos;
    f2:String;
begin
   Abierto:= TAbiertos.create;
   A:=ArgToFloat(Args[2]);
   Error:=ArgToFloat( Args[ 3 ] );
   f:=Args[0].ResString;
   f2:= Args[1].ResString;
   Result.resFloat:=Abierto.newtonn(A,Error,f,f2);

end;


function TParseMath.Evaluate(): Float;
begin
     FParser.Expression:= Expression;

     Result:= FParser.Evaluate.ResFloat;
end;


function TParseMath.EvaluateString(): String;
begin
     FParser.Expression:= Expression;

     Result:= (FParser.Evaluate.ResString);
end;

function IsNumber(AValue: TExprFloat): Boolean;
begin
  result := not (IsNaN(AValue) or IsInfinite(AValue) or IsInfinite(-AValue));
end;

Procedure ExprTan( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x - 0.5) / pi) <> 0.0) then
      Result.resFloat := tan(x)

   else
     Result.resFloat := NaN;
end;

Procedure ExprSin( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := sin(x)

end;

Procedure ExprCos( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := cos(x)

end;

Procedure ExprLn( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x)

   else
     Result.resFloat := NaN;

end;

Procedure ExprLog( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x) / ln(10)

   else
     Result.resFloat := NaN;

end;

Procedure ExprSQRT( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := sqrt(x)

   else
     Result.resFloat := NaN;

end;

Procedure ExprPower( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,y: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
    y := ArgToFloat( Args[ 1 ] );


     Result.resFloat := power(x,y);

end;



{Procedure ExprEDO( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  f,res:String;
  x0,xf,y0: Float;
  n,tipo:Integer;
  resul:TEDO;

begin


      matPloteoXY := TMatriz.create;


    f:=Args[0].ResString;
    x0 := ArgToFloat( Args[ 1 ] );
    xf := ArgToFloat( Args[ 2 ] );
    y0:= ArgToFloat( Args[ 3 ] );
    n:= Args[4].ResInteger;
    tipo:= Args[5].ResInteger;
    resul:=TEDO.create(f,x0,xf,y0);

    Case tipo  of
    1 : res:=resul.Euler();
    2 : res:=resul.Heun();
    3 : res:=resul.Dormand();
    4 : res:=resul.RungeKutta4();
    else ShowMessage('Error ');
    end;



    matPloteoXY.asignar(resul.matrizXY);

    Result.ResString:=res;

end;

 }

{Procedure ExprIntegral( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  fun:String;
  x,y,temporal: Float;
  i,tipo:Integer;
  resul:TIntegral;
  b:Boolean;

begin
    fun:=Args[0].ResString;
    x := ArgToFloat( Args[ 1 ] );
    y := ArgToFloat( Args[ 2 ] );
    i:= Args[3].ResInteger;
    tipo:= Args[4].ResInteger;
    b:=Args[5].ResBoolean;
    resul:=TIntegral.create(fun,x,y,i);
    temporal:=0;

    Case tipo  of
    1 : begin

        if b=True then  temporal:=resul.TrapecioEvaluateArea()
                  else temporal:=resul.TrapecioEvaluateIntegral() ;
        end;
    2 : begin

        if b=True then  temporal:=resul.SimpsonEvaluateArea()
                  else temporal:=resul.SimpsonEvaluate() ;
        end;
    3 : begin

        if b=True then  temporal:=resul.Simpson38EvaluateArea()
                  else temporal:=resul.Simpson38Evaluate() ;
        end;
    4 : begin

        if b=True then  temporal:=resul.Simpson38CompuestoEvaluateArea()
                  else temporal:=resul.Simpson38CompuestoEvaluate() ;
        end
    else ShowMessage('Error');
    end;
    Result.ResFloat:= temporal;
end;
}

Procedure ExprPlot(var Result: TFPExpressionResult; Const Args: TExprParameterArray)  ;
var
  exprFun:string;
  vmin,vmax,vh:real;
  cont: integer;
begin
  exprFun:= Args[ 0 ].ResString;
  vmin:= ArgToFloat( Args[1]);
  vmax:= ArgToFloat( Args[2]);
  vh:= ArgToFloat( Args[3]);
  GuarFuncion.Add(exprFun);
  GuarIni.Add(FloatToStr(vmin));
  GuarFin.Add(FloatToStr(vmax));;
  GuarH.Add(FloatToStr(vh));
  Result.ResFloat:=0;
  FrameSelected:=4;
  InstanFrame;
  cont:=0;
  while cont < GuarFuncion.Count do begin
      TTheFrame4(Actualframe).graficar(GuarFuncion[cont],StrToFloat(GuarIni[cont]),StrToFloat(GuarFin[cont]),StrToFloat(GuarH[cont]));
      cont:= cont +1;
  end;
end;

Procedure ExprTablas(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
 ecuacion:String;
 a,b,temporal,error: Float;
 i,tipo:Integer;
 resul:TTheFrame1;
 //b:Boolean;

begin
  FrameSelected:=1;
  InstanFrame;
  tipo:= Args[0].ResInteger;
  ecuacion:=Args[1].ResString;
  a := ArgToFloat( Args[ 2 ] );
  b := ArgToFloat( Args[ 3 ] );
  error:= ArgToFloat( Args[4] );
  //b:=Args[5].ResBoolean;
  //resul:=
  temporal:=0;

    Case tipo  of
    1 : begin

        //if tipo= then
        //temporal:=resul.ta(a,b,error,ecuacion);
        TTheFrame1(Actualframe).tabular_bi(a,b,error,ecuacion);
                  //else temporal:=resul.TrapecioEvaluateIntegral() ;
        end;
    2 : begin

        //if b=True then  temporal:=resul.SimpsonEvaluateArea()
                  //else temporal:=resul.SimpsonEvaluate() ;
        TTheFrame1(Actualframe).tabular_fp(a,b,error,ecuacion);
        end;
    3 : begin

        //if b=True then  temporal:=resul.Simpson38EvaluateArea()
                  //else temporal:=resul.Simpson38Evaluate() ;
        TTheFrame1(Actualframe).tabular_secante(a,error,ecuacion);
        end;
    4 : begin

        //if b=True then  temporal:=resul.Simpson38CompuestoEvaluateArea()
                  //else temporal:=resul.Simpson38CompuestoEvaluate() ;
        TTheFrame1(Actualframe).tabular_euler(a,b,error,ecuacion);
        end;
    5 :begin
        TTheFrame1(Actualframe).tabular_heun(a,b,error,ecuacion);
        end;
    6 : begin
        TTheFrame1(Actualframe).tabular_runge(a,b,error,ecuacion);
        end
    else ShowMessage('Error no se');
    end;
    //Result.ResFloat:= temporal;

end;

Procedure ExprTnewton(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var ecuacion,decuacion :string;
    a:real;
begin
  FrameSelected:=1;
  InstanFrame;
  ecuacion:=Args[0].ResString;
  decuacion:=Args[1].ResString;
  a := ArgToFloat( Args[ 2 ] );
  error:= ArgToFloat( Args[3] );
  TTheFrame1(ActualFrame).tabular_newton(a,error,ecuacion,decuacion);
end;

Procedure ExprTsecante(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var ecuacion :string;
    a:real;
begin
  FrameSelected:=1;
  InstanFrame;
  ecuacion:=Args[0].ResString;
  a := ArgToFloat( Args[ 1 ] );
  error:= ArgToFloat( Args[2] );
  TTheFrame1(ActualFrame).tabular_secante(a,error,ecuacion);
end;


Procedure ExprEDO( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  var edo: TEdo;
  var ecuacion, metodo: String;
  var x, y, h:Double;
  var idx,cont: Integer;
begin
   edo:= TEdo.create;
   metodo:= Args[ 0 ].ResString;
   ecuacion:= Args[ 1 ].ResString;
   x:= ArgToFloat( Args[ 2 ] );
   y:= ArgToFloat( Args[ 3 ] );
   //xn:= ArgToFloat( Args[ 4 ] );
   h:= ArgToFloat( Args[ 4 ] );
   if metodo = 'euler'  then
         Result.ResFloat := edo.euler(ecuacion,x,y,h)
   else if metodo = 'heun' then
        Result.ResFloat := edo.heun(ecuacion,x,y,h)
   else if metodo = 'RK4' then
        Result.ResFloat := edo.runge_kutta4(ecuacion,x,y,h)
   //else if metodo = 'DP' then
        //Result.ResFloat := edo.metodoDormandPrince(ecuacion,x,y,xn,h)
   else
       Result.ResString:= '0';
   Form1.CmdBox1.Writeln(LineEnding + edo.xydata + LineEnding);
   FrameSelected:= 4;
   InstanFrame;
   GuarFuncion.Clear;
   GuarFuncion.Add(ecuacion);
   idx:= 0;
   cont:=0;
   //while cont < GuarFuncion.Count do begin
     //TFrame1(ActualFrame).graficar(LFuncion[cont], StrToFloat(LInicio[cont]), StrToFloat(LFin[cont]), StrToFloat(LH[cont]));
     cont:= cont + 1;
     //parse.Expression:= s;
     //plotLines.Clear;
     with TTheFrame4(ActualFrame).PlotLine do repeat
       AddXY(StrToFloat(edo.Lxn[idx]), StrToFloat(edo.Lyn[idx]));
       x:=x+0.001;
       idx:=idx+1
     until(idx>=edo.Lxn.Count);
   //end;
end;

Procedure extrapolar(var Result: TFPExpressionResult; Const Args: TExprParameterArray);
  var regresion: TRegresion;
   var ecuacion, metodo: String;
   var x, y, h:Double;
   var idx,cont: Integer;
       recta1,ecua :string;
 begin
    regresion:= TRegresion.create;
    metodo:= Args[ 0 ].ResString;
    recta1:= Args[ 1 ].ResString;
    regresion.load_data(Form1.StringGrid1,recta1);
    if metodo = 'lineal'  then
          ecua:=regresion.Lineal(Form1.StringGrid1)
    else if metodo = 'exponencial' then
          ecua:=regresion.Nolineal(Form1.StringGrid1)
    else if metodo = 'logaritmica' then
         ecua:=regresion.Logaritmica(Form1.StringGrid1)
    else
        Result.ResString:= '0';
    FrameSelected:= 4;
   InstanFrame;
   cont:=0;
    TTheFrame4(Actualframe).graficar(ecua,-10,10,0.001);
    with TTheFrame4(ActualFrame).Puntos do repeat
       AddXY(StrToFloat(Form1.StringGrid1.Cells[0,cont]), StrToFloat(Form1.StringGrid1.Cells[1,cont]));
       //x:=x+0.001;
       cont:=cont+1 ;
     until(cont >= Form1.StringGrid1.RowCount);

 end;

Procedure TParseMath.AddFunctions();
begin
   with FParser.Identifiers do begin
       AddFunction('tan', 'F', 'F', @ExprTan);
       AddFunction('sin', 'F', 'F', @ExprSin);
       AddFunction('sen', 'F', 'F', @ExprSin);
       AddFunction('cos', 'F', 'F', @ExprCos);
       AddFunction('ln', 'F', 'F', @ExprLn);
       AddFunction('log', 'F', 'F', @ExprLog);
       AddFunction('sqrt', 'F', 'F', @ExprSQRT);
       AddFunction('power', 'F', 'FF', @ExprPower); //two arguments 'FF'

       AddFunction('biseccion', 'F', 'SFFF', @ExprBiy);
       AddFunction('falsa_posicion', 'F', 'SFFF', @ExprFP);
       AddFunction('newton', 'F', 'SSFF', @ExprNewton);
       AddFunction('secante', 'F', 'SFF', @ExprSecante);
       AddFunction('tablaNewton', 'F' , 'SSFF', @ExprTnewton);
       AddFunction('tablaSecante', 'F' , 'SFF' , @ExprTsecante);
       //AddFunction('newton_raphson', 'F', 'SSFFF', @ExprRaphson);

       //AddFunction('integral','F','SFFIIB', @ExprIntegral);
       AddFunction('trapecio', 'F', 'SFFF', @ExprTrapecio);
       AddFunction('simpson13', 'F', 'SFFF', @ExprSimpson13);

       //AddFunction('simpson38', 'F', 'SFFF', @ExprSimpson38);   //3/8 compuesto
       //AddFunction('simpsonsimple', 'F', 'SFFF', @ExprSimpsonSimple);  //3/8 simple

       AddFunction('euler', 'S', 'SFFF', @ExprEuler);
       AddFunction('heun', 'S', 'SFFF', @ExprHeun);
       //AddFunction('dormand', 'S', 'SFFFF', @ExprDormand);
       AddFunction('rungekutta4', 'S', 'SFFF', @ExprRungeKutta4);
       AddFunction('EDO', 'S', 'SSFFF', @ExprEDO);
       AddFunction('plot', 'S', 'SFFF', @ExprPlot);
       AddFunction('tablas', 'S' , 'ISFFF', @ExprTablas);

       AddFunction('extrapolacion', 'S','SS', @extrapolar);

   end

end;

procedure TParseMath.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);


end;




procedure TParseMath.AddVariableString( Variable: string; Value: String );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);


end;
end.



