unit uCarBase;

interface

uses SysUtils, classes;

type
  TCarBase = class(TObject)
  protected
    class var FTableName: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function startTrans(): string;
    class function commit(): string;
    //procedure setRow(const S: string);
    function getSql: string;
    class function getBatchSql(const ls: TList; const rows: integer=0): string;
    //
    function getRow(const c: char=#9; const quoted: boolean=false): string; virtual; abstract;
    class function getColumn(const c: char=#9): string; virtual; abstract;
  end;

implementation

{ TCarBase }

constructor TCarBase.Create;
begin
end;

destructor TCarBase.Destroy;
begin
end;

class function TCarBase.startTrans: string;
begin
  Result := 'start transaction;' + #13#10 +
    '-- truncate table ;'; // + FTableName;
end;

class function TCarBase.commit: string;
begin
  Result := 'commit;';
end;

class function TCarBase.getBatchSql(const ls: TList; const rows: integer): string;
var colsSql, rowsSql, mergeChar, tmp: string;
  i: integer;
  u: TCarBase;
begin
  if ls.Count<=0 then begin
    Result := '';
  end;

  colsSql := 'insert into ' + FTableName +
    '(' +
      getColumn(#44) +
    ')' + #13#10 +
    ' values ' + #13#10;
  //
  rowsSql := '';
  for I := 0 to ls.Count - 1 do begin
    u := ls.Items[I];
    if (i = ls.Count - 1) then begin
      mergeChar := ';';
    end else begin
      mergeChar := ',';
    end;
    tmp := ' (' +
        u.getRow(#44, true) +
      ')' + mergeChar;
    rowsSql := rowsSql + tmp + #13#10;
  end;
  Result := colsSql + rowsSql;
end;

function TCarBase.getSql: string;
begin
  Result := 'insert into ' + FTableName +
    '(' +
      getColumn(#44) +
    ')' +
    ' value(' +
      getRow(#44, true) +
    ');'
end;

end.

