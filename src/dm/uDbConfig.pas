unit uDbConfig;

interface

uses classes;

type
  TDbConfig=class(TObject)
  private
  public
    Server: string;
    Port: string;
    database: string;
    User_Name: string;
    password: string;
    CharacterSet: string;
    driverId: string;
  private
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //function getSpell(): string;
    function toConfig(): string;
    procedure fromStrs(strs: TStrings);
    class function getDefault(): string;
  end;

implementation

uses SysUtils;

{ TCarType }

class constructor TDbConfig.Create;
begin
end;

constructor TDbConfig.Create;
begin
  driverId:='MySql';
  CharacterSet:='utf8';
  Server:='127.0.0.1';
  Port:='3306';
  database:='test';
  User_Name:='root';
  password:='123456';
end;

destructor TDbConfig.Destroy;
begin

end;

function TDbConfig.toConfig: string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Add('DriverId='+driverId);
    strs.Add('CharacterSet='+CharacterSet);
    strs.Add('Server='+Server);
    strs.Add('Port='+Port);
    strs.Add('Database='+database);
    strs.Add('User_Name='+User_Name);
    strs.Add('Password='+Password);
    Result := strs.text;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

procedure TDbConfig.fromStrs(strs: TStrings);
begin
  DriverId:=strs.Values['driverId'];
  CharacterSet:=strs.Values['CharacterSet'];
  Server:=strs.Values['Server'];
  Port:=strs.Values['Port'];
  Database:=strs.Values['Database'];
  User_Name:=strs.Values['User_Name'];
  Password:=strs.Values['Password'];
end;

class function TDbConfig.getDefault: string;
var u: TDbConfig;
begin
  u := TDbConfig.Create;
  try
    Result := u.toConfig;
  finally
    u.Free;
  end;
end;

{procedure TDbConfig.setRow(const S: string);
  procedure strsToItems(strs: TStrings);
  var i: integer;
    str: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      str := strs[I];
      case I of
        0: car_brand_id := str;
        1: car_brand_code := str;
        2: car_brand_name := str;
        3: description := str;
        4: state := str;
        5: sort_no := str;
        6: create_time := str;
        7: modify_time := str;
        8: creator_id := str;
        9: modifier_id := str;
        10: letter := str;
        11: short_code := str;
        12: logo_url := str;
        13: blood_enum := str;
        14: raw_id := str;
      end;
    end;
  end;

var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := #9;
    strs.DelimitedText := S;
    strsToItems(strs);
  finally
    if Assigned(strs) then strs.Free;
  end;
end;}

end.

