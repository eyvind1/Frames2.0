unit theframeone;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Grids, metodos_cerrados,
  metodos_abiertos, Dialogs, edo;

type

  { TTheFrame1 }

  TTheFrame1 = class(TFrame)
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure sumaClick(Sender: TObject);
    function suma2(a:real;b:real):real;
  private

  public
    procedure tabular_bi(a,b,error:real ; ecuacion:string);
    procedure tabular_fp(a,b,error:real ; ecuacion:string);
    procedure tabular_newton(a,error:real ; ecuacion,decuacion:string);
    procedure tabular_secante(a,error:real ; ecuacion:string);
    procedure tabular_euler(varx,vary,h:real ; ecuacion:string);
    procedure tabular_heun(varx,vary,h:real ; ecuacion:string);
    procedure tabular_runge(varx,vary,h:real ; ecuacion:string);
  end;

implementation
const
 col_pos = 0;
 col_iA = 1;
 col_iB = 2;
 col_Xn = 3;
 col_signo = 4;
 col_err = 5;
{$R *.lfm}

{ TTheFrame1 }

procedure TTheFrame1.sumaClick(Sender: TObject);
begin

end;

function TTheFrame1.suma2(a:real;b:real):real;
begin
  Result :=a+b;
end;

procedure TTheFrame1.tabular_bi(a,b,error:real ; ecuacion:string) ;
var Metodos : TCerrados;
    iRow, row,col: integer;
begin
  Metodos:= TCerrados.create;
  Metodos.bisection(a, b, error, ecuacion);
  StringGrid1.Colcount:= 6;
  StringGrid1.RowCount:= Metodos.datos.Count;
  StringGrid1.Cols[ col_iA ].Assign( Metodos.La );
  StringGrid1.Cols[ col_iB ].Assign( Metodos.Lb );
  StringGrid1.Cols[ col_Xn ].Assign( Metodos.datos );
  StringGrid1.Cols[ col_signo ].Assign( Metodos.Lsig );
  StringGrid1.Cols[ col_err ].Assign( Metodos.Le );
  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Metodos.Destroy;
end;

procedure TTheFrame1.tabular_fp(a,b,error:real ; ecuacion:string);
var Metodos : TCerrados;
    iRow : integer;
begin
  Metodos:= TCerrados.create;
  Metodos.false_position(a, b, error, ecuacion);
  StringGrid1.Colcount:= 6;
  StringGrid1.RowCount:= Metodos.datos.Count;
  StringGrid1.Cols[ col_iA ].Assign( Metodos.La );
  StringGrid1.Cols[ col_iB ].Assign( Metodos.Lb );
  StringGrid1.Cols[ col_Xn ].Assign( Metodos.datos );
  StringGrid1.Cols[ col_signo ].Assign( Metodos.Lsig );
  StringGrid1.Cols[ col_err ].Assign( Metodos.Le );
  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Metodos.Destroy;
end;

procedure TTheFrame1.tabular_newton(a,error:real ; ecuacion,decuacion:string);
var Abierto: TAbiertos;
    iRow: Integer;
begin
  Abierto:= TAbiertos.create;
  Abierto.newtonn(a, error, ecuacion, decuacion);
  StringGrid1.ColCount:=3;
  StringGrid1.RowCount:= Abierto.datos.Count;
  StringGrid1.Cols[ 1 ].Assign( Abierto.datos );
  StringGrid1.Cols[ 2 ].Assign( Abierto.Le );

  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Abierto.Destroy;
end;

procedure TTheFrame1.tabular_secante(a,error:real ; ecuacion:string);
var Abierto: TAbiertos;
    iRow: Integer;
begin
  Abierto:= TAbiertos.create;
  Abierto.m_secante(a, error, ecuacion);
  StringGrid1.ColCount:=3;
  StringGrid1.RowCount:= Abierto.datos.Count;
  StringGrid1.Cols[ 1 ].Assign( Abierto.datos );
  StringGrid1.Cols[ 2 ].Assign( Abierto.Le );

  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Abierto.Destroy;
end;

procedure TTheFrame1.tabular_euler(varx,vary,h:real ; ecuacion:string);
var Edo:TEdo;
    iRow: integer;
begin
  Edo:=TEdo.create;
  Edo.euler(ecuacion,varx,vary,h);
  StringGrid1.ColCount:=3;
  StringGrid1.RowCount:= Edo.Lxn.Count;
  StringGrid1.Cols[ 1 ].Assign( Edo.Lxn );
  StringGrid1.Cols[ 2 ].Assign( Edo.Lyn );

  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Edo.Destroy;

end;

procedure TTheFrame1.tabular_heun(varx,vary,h:real ; ecuacion:string);
var Edo:TEdo;
    irow: integer;
begin
   Edo:=TEdo.create;
  Edo.heun(ecuacion,varx,vary,h);
  StringGrid1.ColCount:=4;
  StringGrid1.RowCount:= Edo.Lxn.Count;
  StringGrid1.Cols[ 1 ].Assign( Edo.Lxn );
  StringGrid1.Cols[ 2 ].Assign( Edo.Lyn2 );
  StringGrid1.Cols[ 3 ].Assign( Edo.Lyn );

  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Edo.Destroy;
end;

procedure TTheFrame1.tabular_runge(varx,vary,h:real; ecuacion:string);
var Edo:TEdo;
    irow: integer;
begin
   Edo:=TEdo.create;
  Edo.runge_kutta4(ecuacion,varx,vary,h);
  StringGrid1.ColCount:=7;
  StringGrid1.RowCount:= Edo.Lxn.Count;
  StringGrid1.Cols[ 1 ].Assign( Edo.Lxn );
  StringGrid1.Cols[ 2 ].Assign( Edo.Lyn );
  StringGrid1.Cols[ 3 ].Assign( Edo.Lk1 );
  StringGrid1.Cols[ 4 ].Assign( Edo.Lk2 );
  StringGrid1.Cols[ 5 ].Assign( Edo.Lk3 );
  StringGrid1.Cols[ 6 ].Assign( Edo.Lk4 );
  with StringGrid1 do
   for iRow:= 1 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
   end;
  Edo.Destroy;
end;


end.

