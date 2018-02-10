unit theframefour;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  ExtCtrls, StdCtrls, Dialogs, ComCtrls, ParseMath, metodos_cerrados;

type

  { TTheFrame4 }

  TTheFrame4 = class(TFrame)
    Chart1: TChart;
    Puntos: TLineSeries;
    PlotLine: TLineSeries;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    ColorButton1: TColorButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    TrackBar1: TTrackBar;
  private
    FunctionList,
    EditList: TList;
    ActiveFunction: Integer;
  public
    procedure graficar(s:string; xmin,xmax,h:real);
    procedure graficar2(s:string; xmin,xmax,h:real);
    function evaluar(x:real):real;
  end;

implementation

{$R *.lfm}
function f(valor:real;s:string):real;
     var MiParse: TParseMath;
   begin
     MiParse:= TParseMath.create();
     MiParse.AddVariable('x',valor);
     MiParse.Expression:= s;
     //check:=false;
     try
       result:=MiParse.Evaluate();
     except
       begin
       ShowMessage('La funcion no es continua en el punto '+FloatToStr(valor));
       //check:=true;
       end;
     end;

     MiParse.destroy;
   end;

procedure TTheFrame4.graficar(s:string; xmin,xmax,h:real);
var MiParse: TParseMath;
    x:Real;
begin
  x:=xmin;
  MiParse:= TParseMath.create();
  //PlotLine.Clear;
  with PlotLine do repeat
    AddXY(x,f(x,s));
    x:=x+h
  until(x>=xmax) ;

end;

function TTheFrame4.evaluar(x:real):real;
var parse :TParseMath;
begin
     try
     parse.NewValue('x',x);
     Result:=parse.Evaluate();
     except
     showmessage('la f no es continua');

     end;
 end;
procedure TTheFrame4.graficar2(s:string; xmin,xmax,h:real);
var x:real   ;
    parse:TParseMath;
begin
    x:= xmin;
     parse:= TParseMath.create();
     parse.AddVariable('x', 0.0);
     parse.Expression:= s;
     //plotLines.Clear;
     with PlotLine do repeat
       AddXY(x, evaluar(x));
       x:=x+h
     until(x>=xmax);

end;


end.

