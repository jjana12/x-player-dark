{ *************************************************************************** }

 { Audio Tools Library                                                         }
 { Class TCDAtrack - for getting information for CDDA track                    }

 { http://mac.sourceforge.net/atl/                                             }
 { e-mail: macteam@users.sourceforge.net                                       }

 { Copyright (c) 2000-2002 by Jurgen Faul                                      }
 { Copyright (c) 2003-2005 by The MAC Team                                     }

 { Version 1.1 (April 2005) by Gambit                                          }
 {   - updated to unicode file access                                          }

 { Version 1.0 (4 November 2002)                                               }
 {   - Using cdplayer.ini                                                      }
 {   - Track info: title, artist, album, duration, track number, position      }

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

unit CDAtrack;

interface

uses
  Classes, SysUtils, IniFiles;

type
  { Class TCDAtrack }
  TCDAtrack = class (TObject)
  private
    { Private declarations }
    FValid:    boolean;
    FTitle:    WideString;
    FArtist:   WideString;
    FAlbum:    WideString;
    FDuration: double;
    FTrack:    word;
    FPosition: double;
    procedure FResetData;
  public
    { Public declarations }
    constructor Create;                                     { Create object }
    function ReadFromFile(const FileName: WideString): boolean;     { Load data }
    property Valid: boolean Read FValid;             { True if valid format }
    property Title: WideString Read FTitle;                    { Song title }
    property Artist: WideString Read FArtist;                 { Artist name }
    property Album: WideString Read FAlbum;                    { Album name }
    property Duration: double Read FDuration;          { Duration (seconds) }
    property Track: word Read FTrack;                        { Track number }
    property Position: double Read FPosition;    { Track position (seconds) }
  end;

implementation

type
  { CDA track data }
  TrackData = packed record
    RIFFHeader: array [1..4] of char;                         { Always "RIFF" }
    FileSize: integer;                            { Always "RealFileSize - 8" }
    CDDAHeader: array [1..8] of char;                     { Always "CDDAfmt " }
    FormatSize: integer;                                          { Always 24 }
    FormatID: word;                                                { Always 1 }
    TrackNumber: word;                                         { Track number }
    Serial: integer;              { CD serial number (stored in cdplayer.ini) }
    PositionHSG: integer;                      { Track position in HSG format }
    DurationHSG: integer;                      { Track duration in HSG format }
    PositionRB: integer;                  { Track position in Red-Book format }
    DurationRB: integer;                  { Track duration in Red-Book format }
    Title:  string;                                               { Song title }
    Artist: string;                                             { Artist name }
    Album:  string;                                               { Album name }
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadData(const FileName: WideString; var Data: TrackData): boolean;
var
  SourceFile: TFileStream;
  CDData:     TIniFile;
begin
  { Read track data }
  Result := False;
  try
    SourceFile := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    SourceFile.Read(Data, 44);
    SourceFile.Free;
    Result      := True;
    { Try to get song info }
    CDData      := TIniFile.Create('cdplayer.ini');
    Data.Title  := CDData.ReadString(IntToHex(Data.Serial, 2),
      IntToStr(Data.TrackNumber), '');
    Data.Artist := CDData.ReadString(IntToHex(Data.Serial, 2), 'artist', '');
    Data.Album  := CDData.ReadString(IntToHex(Data.Serial, 2), 'title', '');
    CDData.Free;
  except
    end;
end;

{ --------------------------------------------------------------------------- }

function IsValid(const Data: TrackData): boolean;
begin
  { Check for format correctness }
  Result := (Data.RIFFHeader = 'RIFF') and (Data.CDDAHeader = 'CDDAfmt ');
end;

{ ********************** Private functions & procedures ********************* }

procedure TCDAtrack.FResetData;
begin
  { Reset variables }
  FValid    := False;
  FTitle    := '';
  FArtist   := '';
  FAlbum    := '';
  FDuration := 0;
  FTrack    := 0;
  FPosition := 0;
end;

{ ********************** Public functions & procedures ********************** }

constructor TCDAtrack.Create;
begin
  { Create object }
  inherited;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TCDAtrack.ReadFromFile(const FileName: WideString): boolean;
var
  Data: TrackData;
begin
  { Reset variables and load file data }
  FResetData;
  FillChar(Data, SizeOf(Data), 0);
  Result := ReadData(FileName, Data);
  { Process data if loaded and valid }
  if Result and IsValid(Data) then
    begin
    FValid    := True;
    { Fill properties with loaded data }
    FTitle    := Data.Title;
    FArtist   := Data.Artist;
    FAlbum    := Data.Album;
    FDuration := Data.DurationHSG / 75;
    FTrack    := Data.TrackNumber;
    FPosition := Data.PositionHSG / 75;
    end;
end;

{ --------------------------------------------------------------------------- }

end.
