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
    Edit1: TEdit;
    Label1: TLabel;
    UpDown1: TUpDown;
    Button1: TButton;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    Label2: TLabel;
    ToolButton2: TToolButton;
    Edit2: TEdit;
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
    procedure DbInfoDoAfter(const S: string);
    procedure dbTestOrSaveCfg(const bSave: boolean=false);
    procedure setStatus(const S: string; const setCap: boolean=false);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

//uses uDmCarGoods, uDmBase, uDataSetConvertSql, uDataSetConvertJson;
uses uCharSplit;

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
  Result := ExtractFilePath(Application.ExeName);
end;

procedure TfrmMain.Button1Click(Sender: TObject);

  procedure doIt(const S: string);
  var u: TCarColor;
    brandId: string;
  begin
    u := TCarColor.Create;
    try
      if u.parserIt(S) then begin
        if FCarBrandParser.tryGet(u.car_brand_name, brandId) then begin
          Inc(TCarColor.FMaxId);
          u.car_color_id := TCarColor.FMaxId;
          u.car_brand_id := brandId;
          //
          if rbTable.Checked then begin
            FDGUIxFormsMemoResult.Lines.Add(u.getRow());
          end else begin
            FDGUIxFormsMemoResult.Lines.Add(u.getSql());
          end;
        end else begin
          raise Exception.CreateFmt('not found: brand %s ', [u.car_brand_name]);
        end;
      end;
    finally
      u.Free;
    end;
  end;

var i: integer;
  S: string;
begin
  FDGUIxFormsMemoResult.Clear;
  //
  FCarBrandParser.loadIt(FDGUIxFormsCarBrand.Lines);
  //
  if rbTable.Checked then begin
    FDGUIxFormsMemoResult.Lines.Add(TCarColor.getColumn());
  end;
  //
  for I := 1 to self.FDGUIxFormsMemoSql.Lines.Count - 1 do begin
    S := self.FDGUIxFormsMemoSql.Lines[i];
    setStatus(S);
    doIt(S);
  end;
end;

procedure TfrmMain.DbInfoDoAfter(const S: string);
begin
  //self.FDGUIxFormsMemo1.Lines.Add('----------');
  //self.FDGUIxFormsMemo1.Lines.Add(S);
end;

procedure TfrmMain.dbTestOrSaveCfg(const bSave: boolean);
//var u: TDbConfig;
begin
  {u := TDbConfig.Create;
  try
    ctrsToDbInfo(u);
    //
    FDGUIxFormsMemo1.Show;
    self.FDGUIxFormsMemo1.Lines.Text := u.toConfig;
    Application.ProcessMessages;
    //
    if not bSave then begin
      DmBase.Connection(u.toConfig, DbInfoDoAfter);
    end else begin
      DmBase.SaveConfig(u, DbInfoDoAfter);
    end;
  finally
    u.Free;
  end;}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {if FileExists(self.getPath() + 'my.sql') then begin
    self.FDGUIxFormsMemoSql.Lines.LoadFromFile(self.getPath() + 'my.sql');
  end else begin
  end;
  dbInfoToCtrls_auto();}
  FCarBrandParser := TCarBrandParser.Create;
  TCarColor.FMaxId := StrToInt64(Edit2.Text);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FCarBrandParser.free;
  //self.FDGUIxFormsMemoSql.Lines.SaveToFile(self.getPath() + 'my.sql', TEncoding.UTF8);
end;

end.
