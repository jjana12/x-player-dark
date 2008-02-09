unit info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, ToolWin, StdCtrls, bass;

type
  Tinfoform = class (TForm)
    Mem:      TMemo;
    ToolBar1: TToolBar;
    GetInfo:  TToolButton;
    procedure LogNow(s: string);
    procedure GetInfoClick(Sender: TObject);
    procedure MemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  infoform: Tinfoform;

implementation

uses gui;

{$R *.dfm}

procedure Tinfoform.LogNow(s: string);
begin
  mem.Lines.Add(s);
end;


procedure Tinfoform.GetInfoClick(Sender: TObject);
var
  tl: cardinal;
  i, h, m, s: integer;
  bi: bass_info;
begin
  mem.Clear;
  bass.BASS_GetInfo(bi);
  lognow(format('����� ��������� � ������: %d', [gui.MainList.Count]));
  lognow(format('��������� ����, ���������: %d', [whatspeak.Count]));
  lognow(format('������ ������ ���������: %s', [gui.pltitleformat]));
  lognow(format('������ ������ �� �������: %s', [gui.disptitleformat]));
  lognow(format('����������� ����� ������� ��� �������������: %d', [gui.Min_to_scroll]));
  lognow(format('����� ������������ ������ �������: %d', [gui.speakchar]));
  lognow(format('����� � ���������� ��������� �����: %d', [gui.Rand.maximal]));
  lognow('��������� ���� ������: ' + booltostr(DSCAPS_CONTINUOUSRATE and
    bi.flags <> 0, True));
  lognow('��������: ' + booltostr(DSCAPS_EMULDRIVER and bi.flags <> 0, True));
  lognow('��������������: ' + booltostr(DSCAPS_CERTIFIED and bi.flags <> 0, True));
  lognow('���������� ����: ' + booltostr(DSCAPS_SECONDARYMONO and bi.flags <> 0, True));
  lognow('���������� ������: ' + booltostr(DSCAPS_SECONDARYSTEREO and
    bi.flags <> 0, True));
  lognow('���������� 8-���������: ' + booltostr(DSCAPS_SECONDARY8BIT and
    bi.flags <> 0, True));
  lognow('���������� 16-���������: ' + booltostr(DSCAPS_SECONDARY16BIT and
    bi.flags <> 0, True));
  lognow('���������� ������ (�����): ' + IntToStr(bi.hwsize));
  lognow('���������� ������ (��������): ' + IntToStr(bi.hwfree));
  lognow('�������� ������ �������: ' + IntToStr(bi.freesam));
  lognow('�������� ������ 3D �������: ' + IntToStr(bi.free3d));
  lognow('�������: ' + IntToStr(bi.minrate) + '-' + IntToStr(bi.maxrate));
  lognow('�������: ' + bi.driver);
  lognow('�������...');
  Filllength;
  tl := 0;
  for i := 0 to mainlist.Count - 1 do
    tl := tl + PTag(MainList.items[i])^.duration;
  h := (tl div 3600);
  if h > 0 then
    m := (tl mod 3600) div 60
  else
    m := tl div 60;
  if h > 0 then
    s := tl - (h * 3600 + m * 60)
  else
    s := tl mod 60;
  lognow('����� �����: ' + Format('%.2d:%.2d:%.2d', [h, m, s]));
end;

procedure Tinfoform.MemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  HideCaret(mem.Handle);
end;

procedure Tinfoform.FormActivate(Sender: TObject);
begin
  HideCaret(mem.Handle);
end;

end.
