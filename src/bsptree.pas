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
  end;

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

  TWallList = specialize TFPGObjectList<TWall>;

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
  FWalls := TWallList.Create;
  FRoot := nil;
end;

destructor TBSPTree.Destroy;
begin
  FWalls.Destroy;
  if FRoot <> nil then
     FRoot.Destroy;
end;



end.

