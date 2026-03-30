unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  BSPTree;

type

  { TForm1 }

  TForm1 = class(TForm)
    OptionsGroup: TGroupBox;
    PaintBox: TPaintBox;
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxPaint(Sender: TObject);
  private
    FMouse : TPoint;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.PaintBoxPaint(Sender: TObject);
var
  I : Integer;
  J : Integer;
  lNumX : Integer;
  lNumY : Integer;
  lCellSize : Integer = 16;
  lSnapMouse : TPoint;
  lSnapStart : TPoint;
  lLength : Single;
  lTmpLength : Single;
begin
  with PaintBox do
  begin
    lNumX := Width  div lCellSize;
    lNumY := Height div lCellSize;

    // Clear bg
    Canvas.Brush.Color:= clBlack;
    Canvas.FillRect(0, 0, Width, Height);

    // Gid
    Canvas.Pen.Color:= TColor($333333);
    for I := 0 to lNumX do
    begin
     Canvas.Line(I*lCellSize, 0, I*lCellSize, Height);
    end;

    for I := 0 to lNumY do
    begin
     Canvas.Line(0, I*lCellSize, Width, I*lCellSize);
    end;

    // Snap mouse to grid
    lLength := lCellSize*lCellSize*2;
    lSnapStart.X := lCellSize * (FMouse.X div lCellSize);
    lSnapStart.Y := lCellSize * (FMouse.Y div lCellSize);

    for I := 0 to 1 do
    begin
      for J := 0 to 1 do
      begin
        lTmpLength := (lSnapStart.X+I*lCellSize - FMouse.X)*(lSnapStart.X+I*lCellSize - FMouse.X) + (lSnapStart.Y+J*lCellSize - FMouse.Y)*(lSnapStart.Y+J*lCellSize - FMouse.Y);
        if lTmpLength < lLength then
        begin
           lLength := lTmpLength;
           lSnapMouse.X := lSnapStart.X+I*lCellSize;
           lSnapMouse.Y := lSnapStart.Y+J*lCellSize;
        end;
      end;
    end;

    Canvas.Brush.Color:= clWhite;
    Canvas.Pen.Color:= clNone;
    Canvas.EllipseC(lSnapMouse.X, lsnapMouse.Y, 4, 4);


  end;
end;

procedure TForm1.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FMouse.X:=X;
  FMouse.Y:=Y;
  PaintBox.Invalidate;
end;

end.

