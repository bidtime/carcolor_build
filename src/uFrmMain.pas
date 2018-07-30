unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, FireDAC.VCLUI.Memo, uCarColor,
  uCarBrandParser;

type
  TfrmMain = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    ToolButton3: TToolButton;
    ToolButton6: TToolButton;
    FDGUIxFormsMemoSql: TFDGUIxFormsMemo;
    FDGUIxFormsMemoResult: TFDGUIxFormsMemo;
    edtBatchNum: TEdit;
    Label1: TLabel;
    UpDown1: TUpDown;
    Button1: TButton;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    Label2: TLabel;
    ToolButton2: TToolButton;
    edtInitVal: TEdit;
    StatusBar1: TStatusBar;
    FDGUIxFormsCarBrand: TFDGUIxFormsMemo;
    rbTable: TRadioButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    rbSql: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FCarBrandParser: TCarBrandParser;
    { Private declarations }
    {procedure dbInfoToCtrls(const u: TDbConfig);
    procedure dbInfoToCtrls_auto();
    procedure ctrsToDbInfo(var u: TDbConfig);
    }
    function getPath: string;
    function mergePath(const S: string): string;
    procedure DbInfoDoAfter(const S: string);
    procedure dbTestOrSaveCfg(const bSave: boolean=false);
    procedure setStatus(const S: string; const setCap: boolean=false);
    procedure readWriteCfg(const write: boolean);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

//uses uDmCarGoods, uDmBase, uDataSetConvertSql, uDataSetConvertJson;
uses uCharSplit, Contnrs, IniFiles;

{$R *.dfm}

procedure TfrmMain.setStatus(const S: string; const setCap: boolean);
begin
  StatusBar1.Panels[0].Text := S;
  if setCap then begin
    caption := S;
  end;
  Application.ProcessMessages;
end;

function TfrmMain.getPath: string;
begin
  //Result := ExtractFilePath(Application.ExeName);
 Result := ExtractFilePath(Paramstr(0));
end;

function TfrmMain.mergePath(const S: string): string;
begin
  Result := getPath() + S;
end;

procedure TfrmMain.Button1Click(Sender: TObject);

  procedure str2bean(const S: string; var u: TCarColor);
  var
    brandId: string;
  begin
    if u.parserIt(S) then begin
      if FCarBrandParser.tryGet(u.car_brand_name, brandId) then begin
        Inc(TCarColor.FMaxId);
        u.car_color_id := TCarColor.FMaxId;
        u.car_brand_id := brandId;
      end else begin
        raise Exception.CreateFmt('not found: brand %s ', [u.car_brand_name]);
      end;
    end;
  end;

  procedure doIt(const S: string);
  var u: TCarColor;
  begin
    u := TCarColor.Create;
    try
      str2bean(S, u);
      //
      if rbTable.Checked then begin
        FDGUIxFormsMemoResult.Lines.Add(u.getRow());
      end else begin
        FDGUIxFormsMemoResult.Lines.Add(u.getSql());
      end;
    finally
      u.Free;
    end;
  end;

  function doIts(const S: string): TCarColor;
  var u: TCarColor;
  begin
    u := TCarColor.Create;
    str2bean(S, u);
    //
    result := u;
  end;

  procedure prepareDoIt();
  var i: integer;
    S: string;
  begin
    if rbTable.Checked then begin
      FDGUIxFormsMemoResult.Lines.Add(TCarColor.getColumn());
    end;
    for I := 1 to self.FDGUIxFormsMemoSql.Lines.Count - 1 do begin
      S := self.FDGUIxFormsMemoSql.Lines[i];
      setStatus(S);
      doIt(S);
    end;
  end;

  procedure prepareDoIts();
  var i: integer;
    S: string;
    list: TList;
  begin
    list := TObjectList.Create;
    try
      for I := 1 to self.FDGUIxFormsMemoSql.Lines.Count - 1 do begin
        S := self.FDGUIxFormsMemoSql.Lines[i];
        setStatus(S);
        list.Add(doIts(S));
      end;
      FDGUIxFormsMemoResult.Lines.Add(TCarColor.getBatchSql(list));
    finally
      list.Free;
    end;
  end;

var batchRows: integer;
begin
  batchRows := StrToIntDef(edtBatchNum.text, 0);

  FDGUIxFormsMemoResult.Clear;
  TCarColor.startTrans();
  //
  FCarBrandParser.loadIt(FDGUIxFormsCarBrand.Lines);
  if (batchRows<=1) or (rbTable.Checked) then begin
    prepareDoIt();
  end else begin
    prepareDoIts();
  end;
  TCarColor.commit();
end;

procedure TfrmMain.DbInfoDoAfter(const S: string);
begin
  //self.FDGUIxFormsMemo1.Lines.Add('----------');
  //self.FDGUIxFormsMemo1.Lines.Add(S);
end;

procedure TfrmMain.dbTestOrSaveCfg(const bSave: boolean);
begin
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {if FileExists(self.getPath() + 'my.sql') then begin
    self.FDGUIxFormsMemoSql.Lines.LoadFromFile(self.getPath() + 'my.sql');
  end else begin
  end;
  dbInfoToCtrls_auto();}
  readWriteCfg(false);
  FCarBrandParser := TCarBrandParser.Create;
  TCarColor.FMaxId := StrToInt64(edtInitVal.Text);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  readWriteCfg(true);
  FCarBrandParser.free;
  //self.FDGUIxFormsMemoSql.Lines.SaveToFile(self.getPath() + 'my.sql', TEncoding.UTF8);
end;

procedure TfrmMain.readWriteCfg(const write: boolean);
Var
  filename: string;
  myIniFile: Tinifile;
begin
  filename := mergePath( 'mycfg.ini' );      //指明路径.如果不指明路径.文件将在windows目录建立
  myIniFile := Tinifile.Create(filename);    //Create('program.ini');
  try
    if not write then begin
      edtInitVal.Text := myIniFile.ReadString('cfg', 'initVal', '162803175605706987');
      edtBatchNum.Text := myIniFile.ReadString('cfg', 'batchNum', '100');
    end else begin
      myIniFile.WriteString('cfg', 'initVal', edtInitVal.Text);
      myIniFile.WriteString('cfg', 'batchNum', edtBatchNum.Text);
    end;
  finally
    myIniFile.Free;
  end;
end;

end.
