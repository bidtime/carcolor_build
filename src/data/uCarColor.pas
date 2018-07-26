unit uCarColor;

interface

uses uCarData;

type
  TCarColor = class(TCarData)
  public
    class var FMaxId: Int64;
  public
    car_color_id: int64;
    color_name: string;
    color_value: string;
    color_type: integer;

    car_brand_id: string;
    car_brand_name: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
    function parserIt(const S: string): boolean;
  end;

implementation

uses SysUtils, classes, uCharSplit;

{ TCarColor }

class constructor TCarColor.Create;
begin
  //FMaxId := 67541628411220000;
end;

constructor TCarColor.Create;
begin
  inherited Create;
  FTableName := 'ap_car_color';
end;

destructor TCarColor.Destroy;
begin
end;

class function TCarColor.getColumn(const c: char): string;
begin
  Result :=
    'car_color_id' + c +
    'color_name' + c +
    'color_value' + c +
    'color_type' + c +

    'car_brand_id' + c +
    'car_brand_name' + c +

    'state' + c +
    'sort_no' + c +
    'create_time' + c +
    'modify_time' + c +
    'creator_id' + c +
    'modifier_id';
end;

function TCarColor.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
    Result :=
      QuotedStr(IntToStr(car_color_id)) + c +
      QuotedStr(color_name) + c +
      QuotedStr(color_value) + c +
      QuotedStr(IntToStr(color_type)) + c +

      QuotedStr(car_brand_id) + c +
      QuotedStr(car_brand_name) + c +

      state + c +
      sort_no + c +
      QuotedStr(create_time) + c +
      QuotedStr(modify_time) + c +
      creator_id + c +
      modifier_id + c;
  end else begin
    Result :=
      IntToStr(car_color_id) + c +
      color_name + c +
      color_value + c +
      IntToStr(color_type) + c +

      car_brand_id + c +
      car_brand_name + c +

      state + c +
      sort_no + c +
      create_time + c +
      modify_time + c +
      creator_id + c +
      modifier_id;
  end;
end;

function TCarColor.parserIt(const S: string): boolean;
var
  domerator: string;
  ss: TStrings;
begin
  Result := false;
  ss := TStringList.Create;
  try
    TCharSplit.SplitChar(S, #9, ss);
    if ss.Count>=4 then begin
      self.car_brand_name := ss[0];
      domerator := ss[1];
      if domerator.Contains('外饰') then begin
        self.color_type := 1;
      end else begin
        self.color_type := 2;
      end;
      self.color_name := ss[2];
      self.color_value := ss[3];
      //
      Result := true;
    end;
  finally
    ss.Free;
  end;
end;

end.

