 (* BitMath by Dark, 2004 *)
 (* Simply Binaty Math Unit ? *)

unit bitmath;

interface

uses Windows;

type
  Bit = 0..1;

type
  TBitSet = array[0..7] of Bit;

type
  RGBSet = record
    R, G, B: byte;
  end;

type
  TColor = -$7FFFFFFF - 1..$7FFFFFFF;

type
  TAsByteArray = array[0..8] of byte; {INT64 MAX}

type
  PASByteArray = ^TAsByteArray;

function HexToInt(X: string): int64;

function MakeByte(BitSet: TBitSet): byte;
//��� � �����

function GetNBit(X, N: byte): Bit;
//��� � �����

function GetNByte16(X, N: smallint): byte;
//��� � �����

function GetNByteWord16(X, N: word): byte;
//��� � �����

function GetNByte32(X, N: longint): byte;
//��� � �����

function GetNByte64(X, N: int64): byte;
//��� � �����

function _GetRGB(C: TColor): RGBSet;
//��� � �����

function _MakeRGB(R: RGBSet): TColor;
//��� � �����

function GetRGB(C: TColor): RGBSet;
//��� � �����

function MakeRGB(R: RGBSet): TColor;
//��� � �����

function GetBits(X: byte): TBitSet;
 //��� � �����
 // ������������� ���������� ����������� ������

function LoWord(X: longword): word;

function HiWord(X: longword): word;

function LoByte(X: word): byte;

function HiByte(X: word): byte;

function MakeWord(X, Y: byte): word;

function MakeLong(X, Y: word): longword;

function MakeLongInt(X, Y: word): longint;

function MakeInt64(X, Y: longint): int64;
//��� � �����

function AnsiUpperCase(s: string): string;

function AnsiLowerCase(s: string): string;

function LoCase(c: char): char;
//��� � �����

function UpCase(c: char): char;

function chr(X: byte): char;

function IntToBin(X: longint): string;
//��� � �����

function LongToBin(x: longword): string;
//��� � �����

// �����...
function GetDrives: string;
function isREMOVABLE(root: string): bool;
function isRAMDRIVE(root: string): bool;
function isRemote(root: string): bool;
function isFixed(root: string): bool;
function isCD(root: string): bool;

///
function StrToInt(X: string): integer;
function IntToStr(X: integer): string;
function HasWriteAccess(f: string): bool; // �������� �� Generic_Write ������
function HasReadAccess(f: string): bool;  // ��. ����
function HasReadWriteAccess(f: string): bool;  // ��. ����
function CanCreate(f: string): bool; // ����� �� ������� ���� (r/o?) /winapi
function CanCreate2(f: string): bool; // ���� �� ������ ������ pure_pascal
 {function GetSelfPath:string;}

implementation

// ������� ���� �� 8 �����

function MakeByte(BitSet: TBitSet): byte;

var
  i: integer;
begin
  Result := 0;
  for i := 0 to 7 do
    Result := Result shl 1 + BitSet[i] and 1;
end;
// �������� N-��� ��� �� �����

function GetNBit(X, N: byte): Bit;
begin
  Result := x shr N and 1;
end;

// �������� ��� ���� �����

function GetBits(X: byte): TBitSet;

var
  N: integer;
begin
  for N := 0 to 7 do
    Result[N] := GetNBit(X, N);
end;

// �������� N ���� 16-������� ��������� �����

function GetNByte16(X, N: smallint): byte;
begin
  Result := X shr (N * 8) and 255;
end;
// �������� N ���� 16-������� ������������ �����

function GetNByteWord16(X, N: word): byte;
begin
  Result := X shr (N * 8) and 255;
end;
// �������� N ���� 32-������� ��������� �����

function GetNByte32(X, N: longint): byte;
begin
  Result := X shr (N * 8) and 255;
end;
// �������� N ���� 64-������� ��������� �����

function GetNByte64(X, N: int64): byte;
begin
  Result := X shr (N * 8) and 255;
  ;
end;
// �������� 3 ����� ��������� �� 32-������� ����� (TColor)

function _GetRGB(C: TColor): RGBSet;
begin
  Result.R := PAsByteArray(@C)[0];
  Result.G := PAsByteArray(@C)[1];
  Result.B := PAsByteArray(@C)[2];
end;
// ������� 32-������ ����� (TColor) �� 3 ����;

function _MakeRGB(R: RGBSet): TColor;
begin
  Result := 0;
  PAsByteArray(@Result)[0] := R.R;
  PAsByteArray(@Result)[1] := R.G;
  PAsByteArray(@Result)[2] := R.B;
  //PXByteArray(@Result)[3]:=0;
end;

// �������� 3 ����� ��������� �� 32-������� ����� (TColor) (alt)

function GetRGB(C: TColor): RGBSet;

var
  Col: longint;
begin
  Result.R := 0;
  Result.G := 0;
  Result.B := 0;
  Col      := C;
  Result.R := Col and 255;
  Result.G := Col shr 8 and 255;
  Result.B := Col shr 16 and 255;
end;

// ������� 32-������ ����� (TColor) �� 3 ����;

function MakeRGB(R: RGBSet): TColor;
begin
  Result := 0;
  Result := Result + (R.R and 255);
  Result := Result shl 8 + (R.G and 255);
  Result := Result shl 16 + (R.B and 255);
end;

 // ������������� ���������� ����������� ������
 // ������� word � DWord

function LoWord(X: longword): word;
begin
  Result := X and 65535;
end;
// ������� word � DWord

function HiWord(X: longword): word;
begin
  Result := X shr 16 and 65535;
end;
// ������� ���� � unsigned int

function LoByte(X: word): byte;
begin
  Result := X and 255;
end;
// ������� ���� � unsigned int

function HiByte(X: word): byte;
begin
  Result := X shr 8 and 255;
end;
//������� Word �� ���� ������ (x-�������)

function MakeWord(X, Y: byte): word;
begin
  Result := Result + Y and 255 shl 8 + X and 255;
end;
//������� DWord �� ���� unsigned int (x-�������)

function MakeLong(X, Y: word): longword;
begin
  Result := Result + Y and 65535 shl 16 + X and 65535;
end;
//������� LongInt �� ���� unsigned int (x-�������)

function MakeLongInt(X, Y: word): longint;
begin
  Result := Result + Y and 65535 shl 16 + X and 65535;
end;
//������������ � ����������� ����������

function MakeInt64(X, Y: longint): int64;
begin
  Result := Result + Y and 2147483647 shl 32 + X and 2147483647;
end;

// 16 � ������� x

function QuickPower16(EXP: integer): int64;

var
  Offset: integer;
begin
  Offset := 4 * Exp;
  Result := 1 shl Offset;
end;
// 8 � ������� x

function QuickPower8(EXP: integer): int64;

var
  Offset: integer;
begin
  Offset := 3 * Exp;
  Result := 1 shl Offset;
end;
// 2 � ������� x

function QuickPower2(EXP: integer): int64;

var
  Offset: integer;
begin
  Offset := Exp;
  Result := 1 shl Offset;
end;
//������ system.upcase + ��������� ��������

function UpCase(c: char): char;
begin
  if c in ['a'..'z', '�'..'�'] then
    Result := char(byte(C) - 32)
  else
    Result := C;
end;
//����������� ?

function LoCase(c: char): char;
begin
  if C in ['A'..'Z', '�'..'�'] then
    Result := char(byte(C) + 32)
  else
    Result := C;
end;
// �������������

function chr(X: byte): char;
begin
  Result := char(X);
end;

// ������ AnsiUpperCase

function AnsiUpperCase(s: string): string;

var
  i: integer;
begin
  if s = '' then
    exit;
  for i := 1 to length(s) do
    Result := Result + UpCase(s[i]);
end;
// ������ AnsiLowerCase

function AnsiLowerCase(s: string): string;

var
  i: integer;
begin
  if s = '' then
    exit;
  for i := 1 to length(s) do
    Result := Result + LoCase(s[i]);
end;

// ����������� � Delphi

function HexToInt(X: string): int64;

var
  Str: string;
  I, TMPB, Max: integer;
  tmp: char;
begin
  Result := 0;
  Str    := AnsiUpperCase(X);
  i      := pos('H', Str);
  if I > 0 then
    Delete(Str, i, 1);
  i := pos('$', Str);
  if I > 0 then
    Delete(Str, i, 1);
  Max := Length(Str);
  for i := 1 to Max do
    begin
    TMP := Str[i];
    if Tmp in ['0'..'9'] then
      TMPB := byte(TMP) - 48
    else
    { 0..9, 0=48... } if Tmp in ['A'..'F'] then
      TMPB := byte(TMP) - 55;      { 10..15, A=65... }
    Result := Result + (TmpB * QuickPower16(Max - i));
    end;
end;
// ����������� � Delphi

function IntToBin(x: longint): string;

var
  i: integer;
begin
  Result := '';
  // 1 ��� �������� �� ����, �.� ����� ��������
  for i := 0 to 31 do
    Result := char(((X shr i) and 1) + 48) + Result;
end;
// ����������� � Delphi

function LongToBin(x: longword): string;

begin
  Result := '';
  while X <> 0 do
    begin
    Result := char((X and 1) + 48) + Result;
    x      := x shr 1;
    end;
end;

function GetDrives: string;
var
  List: longint;
  c:    char;

  function isDrive(drive: char): boolean;
  begin
    Result := (list shr (byte(Drive) - 65)) and 1 = 1;
  end;

begin
  List := Windows.GetLogicalDrives;
  for C := 'A' to 'Z' do
    if isDrive(C) then
      Result := Result + C;
end;

function IntToStr(X: integer): string;
begin
  Str(X, Result);
end;

function StrToInt(X: string): integer;
var
  Code: integer;
begin
  Val(X, Result, Code);
end;

function HasWriteAccess(f: string): bool;
var
  i: cardinal;
begin
  i      := Windows.CreateFile(PChar(f), generic_write, file_share_write,
    nil, OPEN_ALWAYS, 0, 0);
  Result := i <> INVALID_HANDLE_VALUE;
  Windows.CloseHandle(i);
end;


function CanCreate(f: string): bool;
var
  i: cardinal;
begin
  i      := Windows.CreateFile(PChar(f), generic_write, file_share_write,
    nil, CREATE_ALWAYS, 0, 0);
  Result := i <> INVALID_HANDLE_VALUE;
  Windows.CloseHandle(i);
  Windows.DeleteFile(PChar(f));
end;

function CanCreate2(f: string): bool;
var
  Fi: file;
begin
{$I-}
  AssignFile(Fi, F);
  Rewrite(Fi);
  Result := ioresult = 0;
  CloseFile(Fi);
  Erase(Fi);
  {$I+}
end;


{function GetSelfPath:string;
begin
Result:=ExtractFilePath(paramstr(0));
end;}

function HasReadAccess(f: string): bool;
var
  i: cardinal;
begin
  i      := Windows.CreateFile(PChar(f), generic_read, file_share_read,
    nil, OPEN_EXISTING, 0, 0);
  Result := i <> INVALID_HANDLE_VALUE;
  Windows.CloseHandle(i);
end;

function HasReadWriteAccess(f: string): bool;
var
  i: cardinal;
begin
  i      := Windows.CreateFile(PChar(f), 0, 0, nil, OPEN_EXISTING, 0, 0);
  Result := i <> INVALID_HANDLE_VALUE;
  Windows.CloseHandle(i);
end;


function isCD(root: string): bool;
begin
  Result := Windows.GetDriveType(PChar(root)) = Drive_CDRom;
end;

function isFixed(root: string): bool;
begin
  Result := Windows.GetDriveType(PChar(root)) = Drive_Fixed;
end;

function isRemote(root: string): bool;
begin
  Result := Windows.GetDriveType(PChar(root)) = Drive_Remote;
end;

function isRAMDRIVE(root: string): bool;
begin
  Result := Windows.GetDriveType(PChar(root)) = Drive_RamDisk;
end;

function isREMOVABLE(root: string): bool;
begin
  Result := Windows.GetDriveType(PChar(root)) = Drive_Removable;
end;


end.
