unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ValEdit, Grids, Spin, theframeone, theframetwo,
  theframethree, theframefour, parsemath2;

type

  { TForm1 }

  TForm1 = class(TForm)
    CmdBox1: TCmdBox;
    ActualFrame: Tframe;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    ValueListEditor1: TValueListEditor;
    procedure Button3Click(Sender: TObject);
    procedure CmdBox1Click(Sender: TObject);
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    //procedure SpinEdit1Change(Sender: TObject);
    procedure Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;

      var Accept: Boolean);
   // procedure load_data(grid:TStringGrid; filename:string);
    //procedure TheButtonClic(Sender: TObject);

  private
    ListVar: TStringList;
    Parse, ParsePlot: TParseMath;
    FrameSelected: Integer;
    procedure InstanFrame;
    procedure StartCommand();

  public

  end;

var
  Form1: TForm1;

implementation

const IsFrame1 = 1;
      IsFrame2 = 2;
      IsFrame3 = 3;
      IsFrame4 = 4;

{$R *.lfm}

{ TForm1 }

procedure TForm1.InstanFrame;
begin
   if Assigned(ActualFrame) then
     ActualFrame.Free;

   case FrameSelected of
       IsFrame1: ActualFrame:= TTheFrame1.Create( Form1 );
       IsFrame2: ActualFrame:= TTheFrame2.Create( Form1 );
       IsFrame3: ActualFrame:= TTheFrame3.Create( Form1 );
       IsFrame4: ActualFrame:= TTheFrame4.Create( Form1 );
   end;

   ActualFrame.Parent:= Panel2;
   ActualFrame.Align:= alClient;

end;
 procedure TForm1.StartCommand();
begin
   CmdBox1.StartRead( clBlack, clWhite,  'Minilab-->', clBlack, clWhite);
end;
{procedure TForm1.TheButtonClic(Sender: TObject);
var a,b :real;

begin
    FrameSelected:= TButton(Sender).Tag;
    //a:= StrtoFloat(Edit1.Text);
    //b:= StrtoFloat(Edit2.Text);
    InstanFrame;

    case FrameSelected of
        IsFrame1: TTheFrame1( ActualFrame).suma.Caption:= FloatToStr(TTheFrame1(ActualFrame).suma2(a,b));
        IsFrame2: TTheFrame2( ActualFrame).resta.Caption:= FloatToStr(TTheFrame2(ActualFrame).resta2(a,b));
    end;

end;}

procedure TForm1.Button3Click(Sender: TObject);
begin

end;

procedure TForm1.CmdBox1Click(Sender: TObject);
begin

end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
var FinalLine: string;

  procedure AddVariable( EndVarNamePos: integer );
  var PosVar: Integer;
    const NewVar= -1;
  begin

    PosVar:= ListVar.IndexOfName( trim( Copy( FinalLine, 1, EndVarNamePos  ) ) );

    with ValueListEditor1 do
    case PosVar of
         NewVar: begin
                  ListVar.Add(  FinalLine );
                  Parse.AddVariable( ListVar.Names[ ListVar.Count - 1 ], StrToFloat( ListVar.ValueFromIndex[ ListVar.Count - 1 ]) );
                  Cells[ 0, RowCount - 1 ]:= ListVar.Names[ ListVar.Count - 1 ];
                  Cells[ 1, RowCount - 1 ]:= ListVar.ValueFromIndex[ ListVar.Count - 1 ];
                  RowCount:= RowCount + 1;

         end else begin
              ListVar.Delete( PosVar );
              ListVar.Insert( PosVar,  FinalLine );
              Cells[ 0, PosVar + 1 ]:= ListVar.Names[ PosVar ] ;
              Cells[ 1, PosVar + 1 ]:= ListVar.ValueFromIndex[ PosVar ];
              Parse.NewValue( ListVar.Names[ PosVar ], StrToFloat( ListVar.ValueFromIndex[ PosVar ] ) ) ;

          end;

    end;


  end;

  procedure Execute();
  begin
      Parse.Expression:= Input ;
      CmdBox1.TextColors(clBlack,clWhite);
      CmdBox1.Writeln( LineEnding +  FloatToStr( Parse.Evaluate() )  + LineEnding);


  end;


begin
  try
     Input:= Trim(Input);
     case input of
       'help': ShowMessage( 'help ');
       'exit': Application.Terminate;
       'clear': begin CmdBox1.Clear; StartCommand() end;
       'clearhistory': CmdBox1.ClearHistory;

        else begin
             FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
             if Pos( '=', FinalLine ) > 0 then
                AddVariable( Pos( '=', FinalLine ) - 1 )
             //else if pos('plot(', FinalLine) > 0 then
               // begin
               // FrameSelected:=4;
                //InstanFrame;
                //end
             else
                Execute;

        end;

  end;

  finally
     StartCommand()
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CmdBox1.StartRead( clBlack, clWhite,  'MiniLab-->', clBlack, clWhite);

  with ValueListEditor1 do begin
    Cells[ 0, 0]:= 'Nombre';
    Cells[1, 0]:= 'Valor';
    Clear;

  end;

  ListVar:= TStringList.Create;
  Parse:= TParseMath.create();
  ParsePlot:= TParseMath.create();
  ParsePlot.AddVariable( 'x', 0 );

  StartCommand();

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;





procedure TForm1.Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
  var Accept: Boolean);
begin

end;


end.

