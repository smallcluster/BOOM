unit BSPTree;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TWall }

  TWall = class
    private
      FStartX : Single;
      FStartY : Single;
      FEndX   : Single;
      FEndY   : Single;
      FTrueWall : TWall;
    public
       property StartX   : Single read FStartX write FStartX;
       property StartY   : Single read FStartY write FStartY;
       property EndX     : Single read FEndX write FEndX;
       property EndY     : Single read FEndY write FEndY;
       property TrueWall : TWall read FTrueWall write FTrueWall;
       constructor Create(ATrueWall : TWall);
       function ToString : String; override;
  end;

  TWallList = specialize TFPGObjectList<TWall>;

  { TSector }

  TSector = class
    private
      FWalls : TWallList;
      FName : String;
      FCenterX : Single;
      FCenterY : Single;
    public
      constructor Create(AWalls : TWallList);
      destructor Destroy;
      property Walls : TWallList read FWalls;
      property Name : String read FName write FName;
      property CenterX : Single read FCenterX;
      property CenterY : Single read FCenterY;
  end;

  TSectorList = specialize TFPGObjectList<TSector>;

  { TBSPNode }

  TBSPNode = class
    private
      FLeft         : TBSPNode;
      FRight        : TBSPNode;
      FWall         : TWall;
    public
      property Left  : TBSPNode read FLeft  write FLeft;
      property Right : TBSPNode read FRight write FLeft;
      property Wall  : TWall    read FWall  write FWall;
      constructor Create;
      destructor Destroy;
  end;

  { TBSPTree }

  TBSPTree = class
    private
      FWalls : TWallList;
      FRoot  : TBSPNode;
    public
      constructor Create;
      destructor Destroy;
      property Walls : TWallList read FWalls write FWalls;
  end;

implementation

{ TWall }

constructor TWall.Create(ATrueWall: TWall);
begin
  FTrueWall := ATrueWall;
end;

function TWall.ToString: String;
begin
  Result:= '['+FloatToStr(StartX)+','+FloatToStr(StartY)+','+FloatToStr(EndX)+','+FloatToStr(EndY)+',';
  if TrueWall = nil then
     Result := Result + 'nil'
  else
    Result := Result + IntToStr(PtrUInt(TrueWall));
  Result := Result + ']';
end;

{ TSector }

constructor TSector.Create(AWalls: TWallList);
var
  lWall : TWall;
begin
  FWalls := TWallList.Create(False);

  for lWall in AWalls do
  begin
    FWalls.Add(lWall);
    FCenterX := FCenterX + lWall.StartX + lWall.EndX;
    FCenterY := FCenterY + lWall.StartY + lWall.EndY;
  end;
  FCenterX := FCenterX / (2.0 * AWalls.Count);
  FCenterY := FCenterY / (2.0 * AWalls.Count);
end;

destructor TSector.Destroy;
begin
  FWalls.Destroy;
end;


{ TBSPNode }

constructor TBSPNode.Create;
begin
  FLeft  := nil;
  FRight := nil;
  FWall  := nil;
end;

destructor TBSPNode.Destroy;
begin
  if Left <> nil then
     Left.Destroy;
  if Right <> nil then
     Right.Destroy;
end;

{ TBSPTree }

constructor TBSPTree.Create;
begin
  FWalls := TWallList.Create(True);
  FRoot := nil;
end;

destructor TBSPTree.Destroy;
begin
  FWalls.Destroy;
  if FRoot <> nil then
     FRoot.Destroy;
end;



end.

