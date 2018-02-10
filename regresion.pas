unit regresion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, Math, Dialogs;

type
  TRegresion= class
  Lmx : TStringList;
  Lmy : TStringList;
  Lx2 : TStringList;
  Lxmym : TStringList;
  Ly : TStringList;
  Laymy : TStringList;
  Laymy2 : TStringList;
  Lymy : TStringList;
  Llny: TStringList;
  Llnx: TStringList;
  Lxy : TStringList;
  mx : real;
  my :real;
  pendiente  :real;
  bias: real;
  A:real;
  private
  public
    f :string;
    function Lineal(serie:TStringGrid):string;
    constructor create;
    destructor Destroy; override;
    function Nolineal(serie:TStringGrid):string;
    function Logaritmica(serie:TStringGrid):string;
    procedure load_data(grid: TStringGrid; filename: String);
    procedure read_text();
    procedure showw();
  end;

implementation

constructor TRegresion.create();
begin
   Lmx := TStringList.Create;
  Lmy :=TStringList.Create;
  Lx2 :=TStringList.Create;
  Lxmym := TStringList.Create;
  Ly := TStringList.Create;
  Laymy := TStringList.Create;
  Laymy2 := TStringList.Create;
  Lymy := TStringList.Create;
  Llny:= TStringList.Create;
  Llnx:= TStringList.Create;
  Lxy:= TStringList.Create;
end;

destructor TRegresion.Destroy;
begin
  Lmx.Destroy;
  Lmy.Destroy;
  Lx2.Destroy;
  Lxmym.Destroy;
  Ly.Destroy;
  Laymy.Destroy;
  Laymy2.Destroy;
  Lymy.Destroy;
  Llny.Destroy;
  Llnx.Destroy;
  Lxy.Destroy;
end;


function mediax(serie:TStringGrid):real;
var fi,i :integer;
    acum :real;
begin
  acum:=0;
  fi := serie.RowCount-1;
  for i:=1 to fi do begin
     acum:=acum+ StrToFloat(serie.Cells[0,i]);
  end;
  Result:= acum/fi;
end;

function mediay(serie:TStringGrid):real;
var fi,i :integer;
    acum :real;
begin
  acum:=0;
  fi := serie.RowCount-1;
  for i:=1 to fi do begin
     acum:=acum+ StrToFloat(serie.Cells[1,i]);
  end;
  Result:= acum/fi;
end;

function medialny(serie:TStringGrid):real;
var fi,i :integer;
    acum :real;
begin
  acum:=0;
  fi := serie.RowCount-1;
  for i:=1 to fi do begin
     acum:=acum+ln( StrToFloat(serie.Cells[1,i]));
  end;
  Result:= acum/fi;
end;

function medialnx(serie:TStringGrid):real;
var fi,i :integer;
    acum :real;
begin
  acum:=0;
  fi := serie.RowCount-1;
  for i:=1 to fi do begin
     acum:=acum+ln( StrToFloat(serie.Cells[0,i]));
  end;
  Result:= acum/fi;
end;

procedure TRegresion.read_text();
var Fil :file of char;
    readChar : char;
    i,j : integer;
    len : real;
    rec: array[1..100]of string;
    Userfile:text;
    word: string;
begin
  i:=1;
  j:=1;
  system.Assign(Fil,'sample.csv') ;
  system.Reset(Fil);
  len:=FileSize(Fil);
  //Close(Fil);
  read(Fil,readchar);
  repeat
    while(readchar<>',')and(j<len)do begin
       rec[i]:=rec[i]+readchar;
       read(Fil,readchar);
       inc(j);
       word:=word+rec[i];
    end;
    if  (readchar<>',')and(j<len) then
    begin
       inc(i);
       read(Fil,readchar);
       inc(j);
    end;

  until(j>=len) ;
    showmessage(word);
end;

procedure TRegresion.showw();
var i:integer ;
begin
  read_text();
  //for i:=1 to 6 begin
    // showmessage(Ly[i]);
  end;
function TRegresion.Lineal(serie:TStringGrid):string;
var fi,i,j:integer;
    x,y,x2,xm,y2,ay,ay2,ym,acump,
     acumb :real   ;
begin
  fi:=serie.RowCount-1;
  x:=0;
  y:=0;
  acump:=0;
  acumb:=0;
  mx:= mediax(serie);
  my:= mediay(serie);
  for i:=1 to fi do begin
    x:= StrToFloat(serie.Cells[0,i])- mx;
    Lmx.Add(FloatToStr(x));
    y:= StrToFloat(serie.Cells[1,i])- my;
    Lmy.Add(FloatToStr(y));
    x2:=x*x;
    acumb:= acumb+x2;
    Lx2.Add(FloatToStr(x2));
    xm:=x*y;
    Lxmym.Add(FloatToStr(xm));
    acump:= acump+xm;
  end;
  pendiente:= acump/acumb;
  bias:= my- (pendiente*mx);
  for j:=1 to fi do begin
    y2:=(StrToFloat(serie.Cells[0,j])*pendiente)+bias;
    Ly.Add(FloatToStr(y2));
    ay:= y2-my;
    Laymy.Add(FloatToStr(ay));
    ay2:=ay*ay;
    Laymy2.Add(FloatToStr(ay2));
    ym:=power((StrToFloat(serie.Cells[1,j])-my),2);
    Lymy.Add(FloatToStr(ym));
  end;
    f:= FloatToStr(bias)+'+'+FloatToStr(pendiente)+'*x';
    Result:=f;
end;

function TRegresion.Nolineal(serie:TStringGrid):string;
var fi,i,j:integer;
    x,y,x2,xm,y2,ay,ay2,ym,acump,
    lny, acumb :real   ;
begin
  fi:=serie.RowCount-1;
  x:=0;
  y:=0;
  acump:=0;
  acumb:=0;
  mx:= mediax(serie);
  my:= medialny(serie);
  for i:=1 to fi do begin
    x:= StrToFloat(serie.Cells[0,i])- mx;
    Lmx.Add(FloatToStr(x));
    lny:= ln(StrToFloat(serie.Cells[1,i]));
    Llny.Add(FloatToStr(lny));
    y:= ln(StrToFloat(serie.Cells[1,i]))- my;
    Lmy.Add(FloatToStr(y));
    x2:=x*x;
    acumb:= acumb+x2;
    Lx2.Add(FloatToStr(x2));
    xm:=x*y;
    Lxmym.Add(FloatToStr(xm));
    acump:= acump+xm;
  end;

  pendiente:= acump/acumb;
  bias:= my- (pendiente*mx);
  A:=exp(bias);
  for j:=1 to fi do begin
    y2:=(StrToFloat(serie.Cells[0,j])*pendiente)+bias;
    Ly.Add(FloatToStr(y2));
    ay:= y2-my;
    Laymy.Add(FloatToStr(ay));
    ay2:=ay*ay;
    Laymy2.Add(FloatToStr(ay2));
    ym:=power((ln(StrToFloat(serie.Cells[1,j]))-my),2);
    Lymy.Add(FloatToStr(ym));
  end;
  f:= FloatToStr(A)+'*exp('+FloatToStr(pendiente)+'*x'+')';
  Result:=f;
end;

function TRegresion.Logaritmica(serie:TStringGrid):string;
var fi,i,j:integer;
    x,y,x2,xm,y2,ay,ay2,ym,acumy,
    xy, lnx, acumx,acumxy, acumxx :real   ;

begin
  fi:=serie.RowCount-1;
  x:=0;
  y:=0;
  acumx:=0;
  acumy:=0;
  acumxy:=0;
  acumxx:=0;
  mx:= medialnx(serie);
  my:= mediay(serie);
  for i:=1 to fi do begin
    acumy:=acumy+ StrToFloat(serie.Cells[1,i])  ;
    lnx:= ln(StrToFloat(serie.Cells[0,i]));
    Llnx.Add(FloatToStr(lnx));
    acumx:=acumx+lnx;
    xy:= lnx*(StrToFloat(serie.Cells[1,i])) ;
    Lxy.Add(FloatToStr(xy));
    acumxy:= acumxy+xy;
    x2:=lnx*lnx;
    acumxx:=acumxx+x2;
    Lx2.Add(FloatToStr(x2));
  end;

  //pendiente:= acump/acumb;
  pendiente:= ((fi*acumxy)-(acumx*acumy))/((fi*acumxx)-(power(acumx,2)));
  //A:=exp(bias);
  bias:=(acumy/fi)-(pendiente*acumx/fi);
  if pendiente<0 then begin
     f:= FloatToStr(bias)+FloatToStr(pendiente)+'*'+ 'ln(x)';

  end
  else begin
    f:= FloatToStr(bias)+'+'+FloatToStr(pendiente)+'*'+ 'ln(x)';
  end;
  Result:=f;
end;

procedure TRegresion.load_data(grid: TStringGrid; filename: String);
begin
  grid.LoadFromCSVFile(filename);
end;


end.
