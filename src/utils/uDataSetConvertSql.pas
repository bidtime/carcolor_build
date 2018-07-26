unit uDataSetConvertSql;

interface

uses
  System.SysUtils, System.Classes, Data.DB, uCommEvents;

type
  TDataSetConvertSql = class
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure toSql(const dataSet: TDataSet; const useBatch: boolean; strs: TStrings; ev:TRowNextEvent=nil; logs: TStrings=nil);
    class function convert(const dataSet: TDataSet; const useBatch: boolean; ev:TRowNextEvent=nil; logs: TStrings = nil): string; overload;
  end;

implementation

class procedure TDataSetConvertSql.toSql(const dataSet: TDataSet; const useBatch: boolean;

  strs: TStrings; ev:TRowNextEvent; logs: TStrings);

  {ftUnknown, ftString, ftSmallint, ftInteger, ftWord, // 0..4
  ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, // 5..11
  ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, // 12..18
  ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString, // 19..24
  ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob, // 25..31
  ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd, // 32..37
  ftFixedWideChar, ftWideMemo, ftOraTimeStamp, ftOraInterval, // 38..41
  ftLongWord, ftShortint, ftByte, ftExtended, ftConnection, ftParams, ftStream, //42..48
  ftTimeStampOffset, ftObject, ftSingle}

  //0: string, 1:number, 2: datetime;
  {function isNumber(const ft: TFieldType): TJSONValue;
  begin
    if ft in [ftString] then begin
    end else if ft in [] then begin

    end;
  end;}

  function getFmtFieldValue(const fld: TField): string;
  var
    dt: TFieldType;
  begin
    dt := fld.DataType;
    if dt in [ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString,
      ftFixedWideChar, ftWideMemo] then begin
      Result := QuotedStr(fld.AsString);
    end else if dt in [ftBoolean] then begin
      if fld.AsBoolean then begin
        Result := '1';
      end else begin
        Result := '0';
      end;
      //Result := String.Parse(fld.AsInteger);
    end else if dt in [ftBoolean, ftSmallint, ftInteger, ftWord,
      ftBytes, ftVarBytes, ftAutoInc, ftLargeint,
        ftLongWord, ftShortint, ftByte] then begin
      Result := fld.AsString;
    end else if dt in [ftFloat, ftCurrency, ftBCD, ftADT,
        ftSingle] then begin
      Result := fld.AsString;
    end else if dt in [ftDate, ftTime, ftDateTime, ftTimeStamp] then begin
      Result := QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss', fld.value));
      //Result := QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss', fld.value)+'.000');
    end else begin
      Result := fld.value;
    end;
  end;

  function rowToJson(): string;
  var J: integer;
    fld: TField;
    strs: TStringBuilder;
  begin
    strs := TStringBuilder.Create;
    try
      strs.append('(');
      for J := 0 to dataSet.FieldCount - 1 do begin
        fld := dataSet.Fields[J];
        if assigned(logs) then begin
          logs.Add(fld.FieldName + ': ' + IntToStr( Integer(fld.DataType) ) );
        end;
        if fld.IsNull then begin
          strs.append('null');
        end else begin
          strs.append(getFmtFieldValue(fld));
        end;
        if (J<dataSet.FieldCount - 1) then begin
          strs.append(',');
        end;
      end;
      strs.append(')');
      Result := strs.ToString;
    finally
      strs.Free;
    end;
  end;

  function getFieldListName(): string;
  var J: integer;
    fld: TField;
    strs: TStringBuilder;
  begin
    strs := TStringBuilder.Create;
    try
      strs.append('(');
      for J := 0 to dataSet.FieldCount - 1 do begin
        fld := dataSet.Fields[J];
        strs.append(fld.FieldName);
        if (J<dataSet.FieldCount - 1) then begin
          strs.append(',');
        end;
      end;
      strs.append(')');
      Result := strs.ToString;
    finally
      strs.Free;
    end;
  end;

  procedure rowsToJson(strs: TStrings; const preText: string; const c: char);
  var S: string;
    i: integer;
  begin
    try
      dataSet.Last;
      dataSet.First;
      for I := 0 to dataSet.RecordCount-1 do begin
      //while not dataSet.Eof do begin
        if useBatch then begin
          if i=dataSet.RecordCount-1 then begin
            S := preText + rowToJson();
          end else begin
            S := preText + rowToJson() + c;
          end;
        end else begin
          S := preText + rowToJson() + c;
        end;
        strs.add(S);
        if Assigned(ev) then begin
          ev(dataSet, useBatch, strs);
        end;
        dataSet.Next;
      end;
    finally
      {if useBatch and (strs.Count>0) then begin
        s := strs[strs.Count-1];
        if s.EndsWith(c) then begin
          s := s.Substring(0, s.Length-1);
          strs[strs.Count-1] := s;
        end;
      end;}
    end;
  end;

var ss: string;
begin
  ss := 'insert into tableName ' + getFieldListName() + ' values';
  if useBatch then begin
    strs.Add(ss);
    rowsToJson(strs, '', ',');
  end else begin
    rowsToJson(strs, ss, ';');
  end;
end;

class function TDataSetConvertSql.convert(const dataSet: TDataSet; const useBatch: boolean; ev:TRowNextEvent; logs: TStrings): string;
var
  strs: TStrings;
begin
  if dataSet.Active = false then begin
    exit;
  end;
  strs := TStringList.Create;
  try
    toSql(dataSet, useBatch, strs, ev, logs);
    Result := strs.Text;
  finally
    strs.Free;
  end;
end;

end.
