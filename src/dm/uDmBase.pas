unit uDmBase;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, Data.DB, FireDAC.Comp.Client, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, uDbConfig;

type
  TdmBase = class(TDataModule)
    FDConnection1: TFDConnection;
    GUIxCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure saveConnection();
    procedure loadConnection();
    function getPath(): string;
    function getDbFile(): string;
  public
    { Public declarations }
    procedure startTransaction();
    procedure commit();
    procedure rollback();
    function executeSql(const sql: string): LongInt;
    {function Connection(const S: string; const bSuccess: boolean=false;
      const bError: boolean=true): boolean; overload;}
    {function Connection(const S: string; const bSuccess: boolean=true;
      const bError: boolean=true; ev: TGetStrProc=nil): boolean;}
    function Connection(const S: string; ev: TGetStrProc=nil; const bSuccess: boolean=true;
      const bError: boolean=true): boolean;
    procedure SaveConfig(const cfg: TDbConfig; ev: TGetStrProc=nil; const bSuccess: boolean=true;
      const bError: boolean=true);
    procedure LoadConfig(var cfg: TDbConfig);
  end;

var
  dmBase: TdmBase;

implementation

uses Forms, variants, Windows;

{$R *.dfm}

procedure TdmBase.commit;
begin
  FDConnection1.Commit;
end;

function TdmBase.Connection(const S: string; ev: TGetStrProc;
  const bSuccess, bError: boolean): boolean;
begin
  Result := false;
  FDConnection1.Params.Text := S;
  try
    FDConnection1.Connected := true;
    //Result := FDConnection1.Connected;
    if Assigned(ev) then begin
      ev('连接成功');
    end;
    if bSuccess then begin
      MessageBox(0, '连接成功', '提示', MB_ICONINFORMATION+MB_OK);
    end;
    Result := true;
  Except on e:Exception do begin
      if Assigned(ev) then begin
        ev('连接失败:' + e.Message);
      end;
      if bError then begin
        MessageBox(0, pchar('连接失败:' + e.Message), '警告', MB_ICONEXCLAMATION);
      end;
    end;
  end;
end;

procedure TdmBase.DataModuleCreate(Sender: TObject);
begin
  loadConnection();
end;

{function TdmBase.Connection(const S: string; const bSuccess, bError: boolean): boolean;
begin
  FDConnection1.Params.Text := S;
  FDConnection1.Connected := true;
  Result := FDConnection1.Connected;
  if (Result) then begin
    if bSuccess then begin
      MessageBox(0, '连接成功', '提示', MB_ICONINFORMATION+MB_OK);
    end;
  end else begin
    if bError then begin
      MessageBox(0, '连接失败', '警告', MB_ICONEXCLAMATION);
    end;
  end;
end;}

procedure TdmBase.SaveConfig(const cfg: TDbConfig; ev: TGetStrProc; const bSuccess, bError: boolean);
begin
  try
    FDConnection1.Params.Text := cfg.toConfig;
    saveConnection;
    if Assigned(ev) then begin
      ev('保存成功');
    end;

    if bSuccess then begin
      MessageBox(0, '保存成功', '提示', MB_ICONINFORMATION+MB_OK);
    end;
  Except on e:Exception do begin
      if Assigned(ev) then begin
        ev('保存失败:' + e.Message);
      end;
      if bError then begin
        MessageBox(0, pchar('保存失败:' + e.Message), '警告', MB_ICONEXCLAMATION);
      end;
    end;
  end;
end;

procedure TdmBase.LoadConfig(var cfg: TDbConfig);
begin
  cfg.fromStrs(FDConnection1.Params);
end;

procedure TdmBase.rollback;
begin
  self.FDConnection1.rollback;
end;

procedure TdmBase.saveConnection;
begin
  FDConnection1.Params.SaveToFile(getDbFile);
end;

procedure TdmBase.loadConnection;
begin
  if FileExists(getDbFile) then begin
    FDConnection1.Params.LoadFromFile(getDbFile);
  end else begin
    FDConnection1.Params.Text := TDbConfig.getDefault;
  end;
end;

procedure TdmBase.startTransaction;
begin
  self.FDConnection1.StartTransaction
end;

function TDmBase.executeSql(const sql: string): LongInt;
begin
  Result := FDConnection1.ExecSQL(sql);
end;

function TdmBase.getDbFile: string;
begin
  Result := getPath() + 'db.conf';
end;

function TdmBase.getPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

{
Database=main_58
User_Name=sa
Password=123
Server=192.168.1.253
CharacterSet=utf8
DriverID=MySQL
}

{
Database=main
User_Name=pch_you_know135
Password=oewijhdgRax29@nothing.com
Server=101.200.157.7
CharacterSet=utf8
DriverID=MySQL
}

end.
