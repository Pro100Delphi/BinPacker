﻿unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  OlgLogger, OlgSlot, OlgSlotManager, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    PaintBox1: TPaintBox;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBox2: TCheckBox;
    Edit3: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    FSlotManager: TOlgSlotManager;

  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject); var i: Integer;
    R: TRect;
    S: TSize;
    N: Integer;
    C: Cardinal;
const
  A: Array[0..6] of TSize =(
    (cx: 100; cy: 50),
    (cx: 30; cy: 30),
    (cx: 70; cy: 20),
    (cx: 40; cy: 100),
    (cx: 40; cy: 50),
    (cx: 70; cy: 80),
    (cx: 30; cy: 80));
begin

  C := GetTickCount;

  FSlotManager.Clear;

  if CheckBox1.Checked then
    FSlotManager.Resize(PaintBox1.ClientWidth, PaintBox1.ClientHeight)

  else
    FSlotManager.Resize(StrToInt(Edit1.Text), StrToInt(Edit2.Text));

  if CheckBox2.Checked then
    N := Random(StrToInt(Edit3.Text)) + 20

  else
    N := StrToInt(Edit3.Text);

  for i := 1 to N do
    begin
      S := A[Random(Length(A))];
      FSlotManager.AddSlot(S.cx, S.cy, Random($00FFFF00), 'S' + IntToStr(i));
    end;

    case RadioGroup1.ItemIndex of
      //0: FSlotManager.SortByAreaDESC;
      1: FSlotManager.SortByWidthASC;
      2: FSlotManager.SortByWidthDESC;
      3: FSlotManager.SortByHeightASC;
      4: FSlotManager.SortByHeightDESC;
      5: FSlotManager.SortByAreaASC;
      6: FSlotManager.SortByAreaDESC;
    end;

  FSlotManager.Place;

  Caption :=
    'Total Pieces: ' + IntToStr(N) + '   -   ' +
    'Total Area: ' + IntToStr(FSlotManager.TotalArea) + 'px²   -   ' +
    'Filled Area: ' + IntToStr(FSlotManager.FilledArea) + 'px²   -   ' +
    'Filling Ratio: ' + FloatToStrF(FSlotManager.FilledArea / FSlotManager.TotalArea * 100, ffFixed, 10, 3) + ' %   -   ' +
    'Place Time: ' + IntToStr(GetTickCount - C) + ' ms';

  Repaint;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

//  OlgLogControl.Parent := Self;
//  OlgLogControl.Align := alRight;

  FSlotManager := TOlgSlotManager.Create(20, 20, 700, 600);

  Button1.Click;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSlotManager);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var S: TOlgSlot;
    R: TRect;
begin
  PaintBox1.Canvas.Pen.Color := 0;
  PaintBox1.Canvas.Brush.Color := $00FFFFFF;
  PaintBox1.Canvas.Rectangle(FSlotManager.BoundsRect);

  for S in FSlotManager.Slots do
    begin
      PaintBox1.Canvas.Brush.Color := S.Color;
      PaintBox1.Canvas.Rectangle(S.BoundsRect);

      R := S.BoundsRect;

      DrawText(PaintBox1.Canvas.Handle, S.Name, -1, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
