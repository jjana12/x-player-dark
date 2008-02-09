 { Copyright 2004 Darksoft Full soure code}
 { ������� ������ ���������� ��������������� ��������������� �����}
{ �� ������: ����������� ����������, �.�. �������� ������ ������� �� �������� �� � ��� ������� max ������ ����������...}
unit XRAND;

interface

uses Classes;

type
  TRandom = class (TObject)
  protected
    Pos:  integer;
    imax: integer;
    RandomList: TList;
    function getmax: integer;
  public
    property maximal: integer Read GetMax; //���������� ���-�� �����.
    procedure Randomize(c: integer);
    // ����������� ������ ����� � ������� ���-��� ���������.
    function Random(maxnum: integer; exclude: integer = -1): integer;
    // ������������ ����� � �����, ������� �� ���������.
    constructor Create(max: integer); // ������ ������ ��������� �����.
    destructor Free;
  end;

implementation

destructor TRandom.Free;
begin
  RandomList.Free;
end;

function TRandom.Random;
var
  i: integer;
begin
  if pos < imax - 1 then
    Inc(pos)
  else
    begin
    Randomize(imax);
    pos := 0;
    end;
  for i := pos to imax - 1 do
    begin
    Result := integer(RandomList.items[i]);
    if (Result <= maxnum) and (Result <> exclude) then
      begin
      pos := i;
      Exit;
      end;
    end;
  pos    := imax - 1;
  Result := Random(maxnum, Exclude);
end;

function TRandom.getmax;
begin
  Result := imax;
end;

constructor TRandom.Create(max: integer);
begin
  RandomList := TList.Create;
  System.Randomize;
  imax := max;
  Randomize(imax);
  inherited Create;
end;

procedure TRandom.Randomize(c: integer);
var
  z: integer;
begin
  pos  := -1;
  imax := c;
  RandomList.Clear;
  repeat
    z := System.Random(c);
    if RandomList.indexof(Ptr(z)) = -1 then
      RandomList.add(Ptr(Z));
  until RandomList.Count = c;
end;

begin
end.
