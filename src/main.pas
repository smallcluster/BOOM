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
    lSnapMouse.X := lCellSize * Round(FMouse.X / lCellSize);
    lSnapMouse.Y := lCellSize * Round(FMouse.Y / lCellSize);

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

