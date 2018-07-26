unit uDataSetConvertJson;

interface

uses
  System.SysUtils, System.Classes, Data.DB, System.json;

type
  TDataSetConvertJson = class
  private
    { Private declarations }
    class function toJson(const dataSet: TDataSet; jsonObj: TJSONObject; logs: TStrings = nil ): string; overload;
  public
    { Public declarations }
    class function convert(const dataSet: TDataSet; const useData: boolean; logs: TStrings = nil ): string; overload;
  end;

implementation

class function TDataSetConvertJson.toJson(const dataSet: TDataSet; jsonObj: TJSONObject;
  logs: TStrings): string;

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

  function getJsonVal(const fld: TField): TJSONValue;
  var fieldName: string;
    dt: TFieldType;
  begin
    fieldName := fld.FieldName;
    dt := fld.DataType;
    if dt in [ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString,
      ftFixedWideChar, ftWideMemo] then begin
      Result := TJSONString.Create(fld.value);
    end else if dt in [ftSmallint, ftInteger, ftWord,
      ftBytes, ftVarBytes, ftAutoInc, ftLargeint,
        ftLongWord, ftShortint, ftByte] then begin
      Result := TJSONNumber.Create(fld.AsLargeInt);
    end else if dt in [ftFloat, ftCurrency, ftBCD, ftADT,
        ftSingle] then begin
      Result := TJSONNumber.Create(fld.value);
    end else if dt in [ftDate, ftTime, ftDateTime, ftTimeStamp] then begin
      Result := TJSONString.Create(
        formatDateTime('yyyy-mm-dd hh:nn:ss', fld.value));
    end else begin
      Result := TJSONString.Create(fld.value);
    end;
  end;

  procedure rowToJson(jsonObj: TJSONObject);
  var J: integer;
    fld: TField;
  begin
    for J := 0 to dataSet.FieldCount - 1 do begin
      //jsonVal.AddPair()
      fld := dataSet.Fields[J];
      if assigned(logs) then begin
        logs.Add(fld.FieldName + ': ' + IntToStr( Integer(fld.DataType) ) );
      end;
      if fld.IsNull then begin
        jsonObj.AddPair(fld.FieldName, TJSONNull.Create);
        continue;
      end;
      jsonObj.AddPair(fld.FieldName, getJsonVal(fld));
    end;
  end;

  procedure rowsToJson(jsonObj: TJSONObject);
  var jsonArr: TJSONArray;
    jo: TJSONObject;
  begin
    jsonArr := TJSONArray.Create();
    try
      dataSet.First;
      while not dataSet.Eof do begin
        jo := TJSONObject.Create;
        rowToJson(jo);
        jsonArr.AddElement(jo);
        dataSet.Next;
      end;
      jsonObj.AddPair('data', jsonArr);
    finally
      //jsonArr.Free;
    end;
  end;

begin
  if dataSet.RecordCount=1 then begin
    rowToJson(jsonObj);
  end else begin
    rowsToJson(jsonObj);
  end;
end;

class function TDataSetConvertJson.convert(const dataSet: TDataSet; const useData: boolean; logs: TStrings): string;

  function getData(const jsonData: TJSONObject):  TJSONObject;
  var
    jsonObj: TJSONObject;
  begin
    jsonObj := TJSONObject.Create;
    jsonObj.AddPair('state', TJSONNumber.Create(0));
    jsonObj.AddPair('msg', TJSONString.Create(''));
    jsonObj.AddPair('data', jsonData);
    Result := jsonObj;
  end;

var
  jsonObj: TJSONObject;
begin
  if dataSet.Active = false then begin
    exit;
  end;
  jsonObj := TJSONObject.Create;
  try
    toJson(dataSet, jsonObj, logs);
    if useData then begin
      Result := getData(jsonObj).ToString;
    end else begin
      Result := jsonObj.ToString;
    end;
  finally
    jsonObj.Free;
  end;
end;

end.
