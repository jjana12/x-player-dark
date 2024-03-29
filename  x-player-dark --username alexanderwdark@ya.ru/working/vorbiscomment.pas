{ *************************************************************************** }

 { Audio Tools Library                                                         }
 { Class TVorbisComment - for manipulating with Vorbis Comments                }

 { http://mac.sourceforge.net/atl/                                             }
 { e-mail: macteam@users.sourceforge.net                                       }

{ Copyright (c) 2003-2005 by Erik Stenborg                                    }

 { Version 1.2 (April 2005) by Gambit                                          }
 {   - updated to unicode file access                                          }

 { Version 1.1 (2 Oct 2003)                                                    }
 {   - Updated UTF-8 support to use Jcl Library                                }

 { Version 1.0 (6 Jul 2003)                                                    }
 {   - Created                                                                 }

 { Todo: Fix array handling so that it allocates a longer array when inserting }
 {       a new tag field, or removing fields for that matter.                  }

 { This library is free software; you can redistribute it and/or               }
 { modify it under the terms of the GNU Lesser General Public                  }
 { License as published by the Free Software Foundation; either                }
 { version 2.1 of the License, or (at your option) any later version.          }

 { This library is distributed in the hope that it will be useful,             }
 { but WITHOUT ANY WARRANTY; without even the implied warranty of              }
 { MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
 { Lesser General Public License for more details.                             }

 { You should have received a copy of the GNU Lesser General Public            }
 { License along with this library; if not, write to the Free Software         }
 { Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   }

{ *************************************************************************** }

unit VorbisComment;

interface

uses
  SysUtils, Classes, JclUnicode;

type

  TVorbisComment = class
  protected
    FComments:   array of string;
    FCommentLengths: array of integer;
    FCommentCount: integer;
    FVendor:     string;
    FVendorLength: integer;
    FUpperCaseKeys: boolean;
    FUTF8Values: boolean;
    function GetSize: integer;
    function GetKey(Index: integer): WideString;
    procedure SetKey(Index: integer; Value: WideString);
    function GetValue(Index: WideString): WideString;
    procedure SetValue(Index: WideString; Value: WideString);
    function GetValueI(Index: integer): WideString;
    procedure SetValueI(Index: integer; Value: WideString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(const Stream: TStream);
    procedure SaveToStream(const Stream: TStream);
    function Valid: boolean;
    function GetIndexOf(Index: WideString): integer;
    procedure DeleteI(Index: integer);
    procedure Delete(Index: WideString);
    property Key[Index: integer]: WideString Read GetKey Write SetKey;
    property Value[Index: WideString]: WideString Read GetValue Write SetValue;
    property ValueI[Index: integer]: WideString Read GetValueI Write SetValueI;
    property Count: integer Read FCommentCount;
    property Size: integer Read GetSize;
    property Vendor: string Read FVendor;
  end;

implementation

{ --------------------------------------------------------------------------- }

function TVorbisComment.GetSize: integer;
var
  I: integer;
begin
  Result := 4 + Length(FVendor) + 4 + FCommentCount * 4;
  for I := 0 to FCommentCount - 1 do
    Inc(Result, Length(FComments[I]));
end;

{ --------------------------------------------------------------------------- }

function TVorbisComment.GetKey(Index: integer): WideString;
begin
  if FUpperCaseKeys then
    Result := WideUpperCase(Copy(FComments[Index], 1,
      Pos('=', FComments[Index]) - 1))
  else
    Result := Copy(FComments[Index], 1, Pos('=', FComments[Index]) - 1);
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.SetKey(Index: integer; Value: WideString);
begin
  if Value <> '' then
    if FUpperCaseKeys then
      FComments[Index] := UpperCase(Value) + Copy(FComments[Index],
        Pos('=', FComments[Index]), MaxInt)
    else
      FComments[Index] := Value + Copy(FComments[Index],
        Pos('=', FComments[Index]), MaxInt)
  else
    DeleteI(Index);
end;

{ --------------------------------------------------------------------------- }

function TVorbisComment.GetValue(Index: WideString): WideString;
var
  n: integer;
begin
  n := GetIndexOf(Index);
  if n <> -1 then
    Result := GetValueI(n)
  else
    Result := '';
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.SetValue(Index: WideString; Value: WideString);
var
  n: integer;
begin
  if Index <> '' then
    begin
    n := GetIndexOf(Index);
    if n <> -1 then
      SetValueI(n, Value)
    else
    if Value <> '' then
      begin
      FCommentCount := FCommentCount + 1;
      FComments[FCommentCount - 1] :=
        WideUpperCase(Index) + '=' + WideStringToUTF8(Value);
      end;
    end;
end;

{ --------------------------------------------------------------------------- }

function TVorbisComment.GetValueI(Index: integer): WideString;
begin
  if FUTF8Values then
    Result := UTF8ToWideString(Copy(FComments[Index], 1 +
      Pos('=', FComments[Index]), MaxInt))
  else
    Result := Copy(FComments[Index], 1 + Pos('=', FComments[Index]), MaxInt);
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.SetValueI(Index: integer; Value: WideString);
begin
  if Value <> '' then
    if FUTF8Values then
      FComments[Index] := Copy(FComments[Index], 1, Pos('=', FComments[Index])) +
        WideStringToUTF8(Value)
    else
      FComments[Index] := Copy(FComments[Index], 1,
        Pos('=', FComments[Index])) + Value
  else
    DeleteI(Index);
end;

{ --------------------------------------------------------------------------- }

constructor TVorbisComment.Create;
begin
  inherited Create;
  FUpperCaseKeys := True;
  FUTF8Values    := True;
  Clear;
end;

{ --------------------------------------------------------------------------- }

destructor TVorbisComment.Destroy;
begin
  Clear;
  inherited;
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.Clear;
begin
  FVendor := '';
  FVendorLength := 0;
  SetLength(FComments, 0);
  SetLength(FCommentLengths, 0);
  FCommentCount := 0;
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.LoadFromStream(const Stream: TStream);
var
  I: integer;
begin
  Stream.Read(FVendorLength, SizeOf(FVendorLength));
  SetLength(FVendor, FVendorLength);
  Stream.Read(FVendor[1], FVendorLength);
  Stream.Read(FCommentCount, SizeOf(FCommentCount));
  SetLength(FComments, FCommentCount);
  SetLength(FCommentLengths, FCommentCount);
  for I := 0 to FCommentCount - 1 do
    begin
    Stream.Read(FCommentLengths[I], SizeOf(FCommentLengths[I]));
    SetLength(FComments[I], FCommentLengths[I]);
    Stream.Read(FComments[I, 1], FCommentLengths[I]);
    end;
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.SaveToStream(const Stream: TStream);
var
  N, I: integer;
begin
  N := Length(FVendor);
  Stream.Write(N, 4);
  Stream.Write(FVendor[1], N);
  Stream.Write(FCommentCount, 4);
  for I := 0 to FCommentCount - 1 do
    begin
    N := Length(FComments[I]);
    Stream.Write(N, 4);
    Stream.Write(FComments[I, 1], N);
    end;
end;

{ --------------------------------------------------------------------------- }

function TVorbisComment.Valid: boolean;
begin
  Result := (FVendorLength in [10..50]);
end;

{ --------------------------------------------------------------------------- }

function TVorbisComment.GetIndexOf(Index: WideString): integer;
var
  S: string;
begin
  S := UpperCase(Index);
  for Result := 0 to Count - 1 do
    if UpperCase(Key[Result]) = S then
      Exit;
  Result := -1;
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.DeleteI(Index: integer);
begin
  if (Index >= 0) and (Index < Count) then
    begin
    FComments[Index] := FComments[Count - 1];
    FCommentCount    := FCommentCount - 1;
    end;
end;

{ --------------------------------------------------------------------------- }

procedure TVorbisComment.Delete(Index: WideString);
begin
  DeleteI(GetIndexOf(Index));
end;

{ --------------------------------------------------------------------------- }

end.
