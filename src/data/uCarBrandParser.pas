unit uCarBrandParser;

interface

uses SysUtils, classes, Generics.Collections;

type
  TCarBrandParser = class
  private
  protected
    FDicNewFactory: TDictionary<String, String>;
  public
    constructor Create();
    destructor Destroy; override;
    //procedure listBrandToStrs(strs: TStrings);
    procedure loadIt(const strs: TStrings);
    function tryGet(const key: string; var s: string): boolean;
  end;

implementation

uses uCharSplit;

{ TCarSysParser }

constructor TCarBrandParser.Create();
begin
  inherited create();
  FDicNewFactory := TDictionary<String, String>.create();
end;

destructor TCarBrandParser.Destroy;
begin
  FDicNewFactory.Free;
end;

function TCarBrandParser.tryGet(const key: string; var s: string): boolean;
begin
  Result := FDicNewFactory.TryGetValue(key, S);
end;

procedure TCarBrandParser.loadIt(const strs: TStrings);

  procedure splitIt(const S: string);
  var ss: TStrings;
  begin
    ss := TStringList.Create();
    try
      TCharSplit.SplitChar(s, #9, ss);
      if (ss.Count>=4) then begin
        FDicNewFactory.AddOrSetValue(ss[3].Trim, ss[0].Trim);
        {for I := 0 to strs.Count - 1 do begin
          tmp := StringReplace(strs[I], #9, '', [rfReplaceAll]);
          if i=0 then begin
            k := tmp;
          end else if i<3 then begin
            k := k + '/' + tmp;
          end else if (i=3) then begin
            v := tmp;
          end;
        end;}
      end;
    finally
      ss.Free;
    end;
  end;
var i: integer;
  S: string;
begin
  FDicNewFactory.Clear;
  for I := 1 to strs.Count - 1 do begin
    S := strs[I];
    splitIt(S);
  end;
end;

end.

