unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, ExtCtrls, Graphics,fgl,
  BSPTree;

type

  TPointList = specialize TFPGList<TPoint>;

  { TForm1 }

  TForm1 = class(TForm)
    Logs: TMemo;
    OptionsGroup: TGroupBox;
    PaintBox: TPaintBox;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxClick(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxPaint(Sender: TObject);
  private
    FMouse : TPoint;
    FPoints : TPointList;
    FBSPTree : TBSPTree;
    FCellSize : Integer;
    FSectors : TSectorList;
    procedure DrawWall(ACanvas : TCanvas; AWall : TWall);
    procedure DrawWall(ACanvas : TCanvas; AStartX : Integer; AstartY : Integer; AEndX : Integer; AEndY : Integer);
    procedure DrawSector(ACanvas : TCanvas; ASector : TSector);
    function SnappedMouse(ACellSize : Integer) : TPoint;
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
  lSnapMouse : TPoint;
  lSnapStart : TPoint;
  lLength : Single;
  lTmpLength : Single;
  lP, lP1, lP2 : TPoint;
  lSector : TSector;
begin
  with PaintBox do
  begin
    lNumX := Width  div FCellSize;
    lNumY := Height div FCellSize;

    // Clear bg
    Canvas.Brush.Color:= clBlack;
    Canvas.FillRect(0, 0, Width, Height);

    // Gid
    Canvas.Pen.Color:= TColor($333333);
    for I := 0 to lNumX do
    begin
     Canvas.Line(I*FCellSize, 0, I*FCellSize, Height);
    end;

    for I := 0 to lNumY do
    begin
     Canvas.Line(0, I*FCellSize, Width, I*FCellSize);
    end;

    //Draw Realized sectors
    for lSector in FSectors do
    begin
      DrawSector(Canvas, lSector);
    end;

    // Draw unrealized Sector
    if FPoints.Count >= 2 then
    begin
       for I := 0 to FPoints.Count-2 do
        begin
          lP1 := FPoints.Items[I];
          lP2 := FPoints.Items[I+1];
          DrawWall(Canvas, Round(lP1.X), Round(lP1.Y), Round(lP2.X), Round(lP2.Y));
        end;
    end;

    // Draw mouse ghost wall or starting point
    lSnapMouse := SnappedMouse(FCellSize);
    if FPoints.Count > 0 then
    begin
       lP := FPoints.Items[FPoints.Count-1];
       DrawWall(Canvas, Round(lP.X), Round(lP.Y), Round(lSnapMouse.X), Round(lSnapMouse.Y));
    end
    else
    begin
      Canvas.Pen.Color:= clNone;
      Canvas.Brush.Color:= clWhite;
      Canvas.EllipseC(lSnapMouse.X, lsnapMouse.Y, 4, 4);
    end;
  end;

end;

procedure TForm1.DrawWall(ACanvas : TCanvas;  AWall: TWall);
begin
  DrawWall(ACanvas, Round(AWall.StartX), Round(AWall.StartY), Round(AWall.EndX), Round(AWall.EndY));
end;

procedure TForm1.DrawWall(ACanvas: TCanvas; AStartX: Integer; AstartY: Integer;
  AEndX: Integer; AEndY: Integer);
var
  lVX, lVY, lCX, lCY, lNorm : Single;
begin
   ACanvas.Pen.Color:= clRed;
   ACanvas.Line(AStartX, AStartY, AEndX, AEndY);
   ACanvas.Pen.Color:= clRed;

   lVX := AEndX - AStartX;
   lVY := AEndY - AStartY;
   lCX := (AEndX + AStartX) * 0.5;
   lCY := (AEndY + AStartY) * 0.5;

   lNorm := Sqrt(lVX*lVX+lVY*lVY);

   ACanvas.Pen.Color:= clNone;
   ACanvas.Brush.Color:= clWhite;
   ACanvas.EllipseC(AStartX, AStartY, 4, 4);
   ACanvas.EllipseC(AEndX, AEndY, 4, 4);

   if lNorm > 0 then
   begin
     lVX := 8.0 * lVX / lNorm;
     lVY := 8.0 * lVY / lNorm;
     ACanvas.Pen.Color:= clAqua;
     ACanvas.Line(Round(lCX), Round(lCY), Round(lCX-lVY), Round(lCY+lVX));
   end;

end;

procedure TForm1.DrawSector(ACanvas: TCanvas; ASector: TSector);
var
  lWall : TWall;
begin
  for lWall in ASector.Walls do
   begin
    DrawWall(ACanvas, lWall);
   end;
  ACanvas.TextOut(Round(ASector.CenterX), Round(ASector.CenterY), ASector.Name);
end;

function TForm1.SnappedMouse(ACellSize: Integer): TPoint;
begin
   result.X := ACellSize * Round(FMouse.X / ACellSize);
   result.Y := ACellSize * Round(FMouse.Y / ACellSize);
end;

procedure TForm1.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FMouse.X:=X;
  FMouse.Y:=Y;
  PaintBox.Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FBSPTree := TBSPTree.Create;
  FPoints := TPointList.Create;
  FCellSize := 16;
  FSectors := TSectorList.Create(True);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FBSPTree.Destroy;
  FPoints.Destroy;
  FSectors.Destroy;
end;

procedure TForm1.PaintBoxClick(Sender: TObject);
var
  lSnapMouse : TPoint;
  lFirst : TPoint;
  lWall : TWall;
  I : Integer;
  lWalls : TWallList;
  lSector : TSector;
begin
  lSnapMouse := SnappedMouse(FCellSize);
  FPoints.Add(lSnapMouse);

  if FPoints.Count > 2 then
  begin
     lFirst := FPoints.Items[0];
     // End of sector creation
     if (lFirst.X = lSnapMouse.X) and (lFirst.Y = lSnapMouse.Y) then
     begin
        lWalls := TWallList.Create(False);
        for I := 0 to FPoints.Count-2 do
         begin
           lWall := TWall.Create(nil);
           lWall.StartX:= FPoints.Items[I].X;
           lWall.StartY:= FPoints.Items[I].Y;
           lWall.EndX:= FPoints.Items[I+1].X;
           lWall.EndY:= FPoints.Items[I+1].Y;
           lWalls.Add(lWall);
         end;
        lSector := TSector.Create(lWalls);
        lSector.Name := 'Sector '+IntToStr(FSectors.Count);
        Logs.Lines.Add('Created '+ lSector.Name + ' with '+IntToStr(lWalls.Count)+' walls');
        FSectors.Add(lSector);
        FBSPTree.Walls.AddList(lWalls);
        lWalls.Destroy;
        FPoints.Clear;
     end;
  end;

end;

end.

