unit uExternalExtensions;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, System.Types, Fmx.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls,
  Fmx.Layouts, FMX.Graphics,
  fmx.styles,
  fmx.styles.Objects,
  fmx.Forms,
  Generics.Collections,
  fmx.Listbox,
  skia,
  fmx.Skia,
  System.UITypes;

type
  [ComponentPlatforms(0)]
  TAcrylicToolbar = class(TRectangle)
  private
    fEffectEnabled: Boolean;
    fEffectBackColor: TAlphaColor;
    fEffectIsTransparent: Boolean;
    procedure SetEffectEnabled(const Value: Boolean);
    procedure SetEffectBackColor(const Value: TAlphaColor);
    procedure SetEffectIsTransparent(const Value: Boolean);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property EffectEnabled: Boolean read fEffectEnabled write SetEffectEnabled;
    property EffectBackcolor: TAlphaColor read fEffectBackColor write SetEffectBackColor;
    property EffectIsTransparent: Boolean read fEffectIsTransparent write SetEffectIsTransparent;

  end;

  
procedure Register;

implementation

uses
  fmx.Skia.Canvas;

procedure Register;
begin
  RegisterComponents('AT Components', [TAcrylicToolbar]);
end;

{ TAcrylicToolbar }

constructor TAcrylicToolbar.Create(AOwner: TComponent);
begin
  inherited;
  Fill.Kind := TBrushKind.Solid;
  EffectBackcolor := TAlphaColors.Beige;
  fEffectEnabled := false;
end;

procedure TAcrylicToolbar.Paint;
begin
  if (Canvas is TSkCanvasCustom) and (EffectEnabled) then
  begin
    var LCanvas := TSkCanvasCustom(Canvas).Canvas;
    var LSaveCount := LCanvas.Save;
    try
      LCanvas.ClipRect(LocalRect, TSkClipOp.Intersect, True);
      LCanvas.SaveLayer(LocalRect, nil,
        TSkImageFilter.MakeBlur(10, 10, nil, TSkTileMode.Clamp),
        [TSkSaveLayerFlag.InitWithPrevious]);
      inherited;
    finally
      LCanvas.RestoreToCount(LSaveCount);
    end;
  end
  else
    inherited;
end;

procedure TAcrylicToolbar.SetEffectBackColor(const Value: TAlphaColor);
begin
  if value <> fEffectBackColor then
  begin
    fEffectBackColor := value;
    Fill.Color := value;
    Repaint();
  end;
end;

procedure TAcrylicToolbar.SetEffectEnabled(const Value: Boolean);
begin
  if value <> fEffectEnabled then
  begin
    fEffectEnabled := value;
    Repaint();
  end;
end;

procedure TAcrylicToolbar.SetEffectIsTransparent(const Value: Boolean);
begin
  if value <> fEffectIsTransparent then
  begin
    fEffectIsTransparent := Value;
    EffectEnabled := not fEffectIsTransparent;
    if fEffectIsTransparent then
      Fill.Kind := TBrushKind.None
    else
      Fill.Kind := TBrushKind.Solid;
    Repaint;
  end;
end;

end.
