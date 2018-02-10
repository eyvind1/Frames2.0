unit lagra_raphson;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, ParseMath, Dialogs, Math, FileUtil, Forms, Controls, ComCtrls,StdCtrls, ExtCtrls, Spin, Types;

type
  Tnolineal = class
    private
    public
    procedure raphson(x0:Real; x1:Real;x2:Real; fx:String; fy:String;fz:String;dim:integer; error:Real; grill:TStringGrid);
    function f(x : Real;y : Real;s: String):Real;
    function f(x:Real;y:Real;z:Real;s:String):Real;
    function Lagrange(serie:TStringGrid; xo:Real;text:TStaticText):Real;
  end;
var
  check: Boolean ;
implementation

 function Tnolineal.f(x : Real;y : Real;s: String):Real;
var MiParse: TParseMath;
begin
  MiParse:= TParseMath.create();
  MiParse.AddVariable('x',x);
  MiParse.AddVariable('y',y);
  MiParse.Expression:= s;
  check:=false;
  try
    result:=MiParse.Evaluate();
  except
    begin
    ShowMessage('No se puede calcular '+FloatToStr(x)+FloatToStr(y));
    check:=true;
    end;
  end;

  MiParse.destroy;
end;

 function Tnolineal.f(x:Real ;y:Real; z:Real; s:String):Real;
 var MiParse:TParseMath;
   begin
  MiParse:= TParseMath.create();
  MiParse.AddVariable('x',x);
  MiParse.AddVariable('y',y);
  MiParse.AddVariable('z',z);
  MiParse.Expression:= s;
  check:=false;
  try
    result:=MiParse.Evaluate();
  except
    begin
    ShowMessage('No se puede calcular '+FloatToStr(x)+FloatToStr(y));
    check:=true;
    end;
  end;

  MiParse.destroy;
end;

procedure Tnolineal.raphson(x0:Real; x1:Real;x2:real; fx:String; fy:String;fz:String;dim:integer; error:Real; grill:TStringGrid);
var
  e,h,e1,det,ui,vi : Real;
  fxy,fxhy,fxyh,f1xy,f1xhy,f1xyh : Real;
  fxyz,fxhyz,fxyhz,fxyzh,f1xyz,f1xhyz,f1xyhz,f1xyzh,f2xyz,f2xhyz,f2xyhz,f2xyzh: Real;
  j0,j1,j2,j3,j4,j5,j6,j7,j8 : Real;
  n,i,j : Integer;
begin

  e:=1;
  e1:=0;
  n:=0;
  i:=0;
  j:=1;
  h:=error/10;
  if dim = 2 then begin
  grill.RowCount:=2;
  while e > error do
  begin
      fxy:=f(x0,x1,fx);
      if check=true then exit;
      fxhy:=f(x0+h,x1,fx);
      if check=true then exit;
      fxyh:=f(x0,x1+h,fx);
      if check=true then exit;

      f1xy:=f(x0,x1,fy); //v
      if check=true then exit;
      f1xhy:=f(x0+h,x1,fy);
      if check=true then exit;
      f1xyh:=f(x0,x1+h,fy);
      if check=true then exit;

      j0:=(fxhy-fxy)/h;
      j1:=(fxyh-fxy)/h;
      j2:=(f1xhy-f1xy)/h;
      j3:=(f1xyh-f1xy)/h;

      det:=(j0*j3)-(j1*j2);
      ui:=x0-(((fxy*j3)-(f1xy*j1))/det);
      vi:=x1-(((f1xy*j0)-(fxy*j2))/det);

      e:=sqrt(power(x0-ui,2)+power(x1-vi,2));

      grill.Cells[i,j]:=IntToStr(n);
      grill.Cells[i+1,j]:=FormatFloat('0.0000',x0)+' , '+FormatFloat('0.0000',x1);
      grill.Cells[i+2,j]:=FormatFloat('0.0000',(ui-x0)*-1)+' , '+FormatFloat('0.0000',(vi-x1)*-1);
      grill.Cells[i+3,j]:=FormatFloat('0.0000',e);

      if (n<>0) and (n mod 3=0) then
      begin
         e1:=e;
      end;
      if (e1<>0) and (e1<e) then
      begin
         ShowMessage('La funcion Diverge');
         exit;
      end;
      x0:=ui;
      x1:=vi;
      n:=n+1;
      j:=j+1;
      grill.RowCount:=grill.RowCount+1;
  end;
  ShowMessage('La raiz es: '+FormatFloat('0.0000',x0)+' , '+FormatFloat('0.0000',x1));

  end
  else
    ShowMessage('No se puede con 3 variables');
    {-grill.RowCount:=2;
    while e > error do begin
      fxyz:=f(x0,x1,x2,fx);
      if check=true then exit;
      fxhyz:=f(x0+h,x1,x2,fx);
      if check=true then exit;
      fxyhz:=f(x0,x1+h,x2,fx);
      if check=true then exit;
      fxyzh:=f(x0,x1,x2+h,fx);
      if check=true then exit;

      f1xyz:=f(x0,x1,x2,fy);
      if check=true then exit;
      f1xhyz:=f(x0+h,x1,x2,fy);
      if check=true then exit;
      f1xyhz:=f(x0,x1+h,x2,fy);
      if check=true then exit;
      f1xyzh:=f(x0,x1,x2+h,fy);
      if check=true then exit;

      f2xyz:=f(x0,x1,x2,fz);
      if check=true then exit;
      f2xhyz:=f(x0+h,x1,x2,fz);
      if check=true then exit;
      f2xyhz:=f(x0,x1+h,x2,fz);
      if check=true then exit;
      f2xyzh:=f(x0,x1,x2+h,fz);
      if check=true then exit;

      j0:=(fxhyz-fxyz)/h;
      j1:=(fxyhz-fxyz)/h;
      j2:=(fxyzh-fxyz)/h;
      j3:=(f1xhyz-f1xyz)/h;
      j4:=(f1xyhz-f1xyz)/h;
      j5:=(f1xyzh-f1xyz)/h;
      j6:=(f2xhyz-f2xyz)/h;
      j7:=(f2xyhz-f2xyz)/h;
      j8:=(f2xyzh-f2xyz)/h;

      det:=j0*j4*j8+j1*j5*j6 +j3*j7*j2-j2*j4*j6-j1j3*j8-j5*j7*j0;

      ui:=x0-(((fxyz*j3)-(f1xy*j1))/det);
      vi:=x1-(((f1xy*j0)-(fxy*j2))/det);   -}

    //end;

end;








 function Tnolineal.Lagrange(serie:TStringGrid; xo:Real;text:TStaticText):Real;
var
  fi,i,j :Integer;
  mul,sum,c,d: Real;
  pln:String;
begin
  fi:=serie.ColCount-1; //
  pln:='';
  c:=1;
  sum:=0;
  for i:=1 to fi do
  begin
    mul:=1;
      for j:=1 to fi do
      begin
        if j<>i then
        begin
          pln:=pln+'(x-'+serie.Cells[j,0]+')';
          d:=StrToFloat(serie.Cells[i,0])-StrToFloat(serie.Cells[j,0]);
          c:=c*d;
          mul:=mul*(xo-StrToFloat(serie.Cells[j,0]))/d;
        end;
      end;

      pln:=pln+'*(1/'+FloatToStr(c)+')';
      c:=1;
      if i<>(fi) then
         pln:=pln+' + ';
      sum:=sum+(mul*StrToFloat(serie.Cells[i,1]));
  end;
  text.Caption:=pln;
  Result:=sum;
end;

end.



