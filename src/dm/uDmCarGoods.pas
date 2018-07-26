unit uDmCarGoods;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DBClient, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, uCommEvents,
  FireDAC.Comp.UI, FireDAC.Comp.Client, FireDAC.Comp.DataSet, Datasnap.Provider;

type
  TdmCarGoods = class(TDataModule)
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDQuery2: TFDQuery;
    DataSource2: TDataSource;
    procedure FDQuery2AfterInsert(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FMaxId: Int64;
  protected
    state: integer;
    sort_no: integer;
    create_time: TDateTime;
    modify_time: TDateTime;
    creator_id: Int64;
    modifier_id: Int64;
    org_id: string;
  public
    { Public declarations }
    procedure commit;
    procedure rollback;
    procedure startTransaction;
    //
    procedure openTable();
    //function updateCarGoodsNo(const carGoodsId: integer; const orgId: integer): LongInt;
    procedure openSql(const S: string);
    procedure convertToSql(const dataSet: TDataSet; const useBatch: boolean;
      ev:TRowNextEvent=nil; logs: TStrings = nil);
  end;

var
  dmCarGoods: TdmCarGoods;

implementation

uses Forms, uDmBase, variants;

{$R *.dfm}

procedure TdmCarGoods.commit;
begin
  DmBase.commit;
end;

procedure TdmCarGoods.convertToSql(const dataSet: TDataSet; const useBatch: boolean;
  ev: TRowNextEvent; logs: TStrings);
begin

end;

procedure TdmCarGoods.DataModuleCreate(Sender: TObject);
begin
  FMaxId := 67686114558779000;
  //
  state := 1;
  sort_no := 0;
  //create_time := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  create_time := now;
  modify_time := create_time;
  creator_id := 0;
  modifier_id := creator_id;
  //
  //org_id := '10';
end;

procedure TdmCarGoods.FDQuery2AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('car_color_id').AsInteger := FMaxId + 1;
  DataSet.FieldByName('state').AsInteger := state;
  DataSet.FieldByName('sort_no').AsInteger := sort_no;
  DataSet.FieldByName('create_time').AsDateTime := create_time;
  DataSet.FieldByName('modify_time').AsDateTime := modify_time;
  DataSet.FieldByName('creator_id').AsInteger := creator_id;
  DataSet.FieldByName('modifier_id').AsInteger := modifier_id;

{car_color_id
car_brand_id
car_brand_name
color_name
color_value
color_type
state
sort_no
create_time
modify_time
creator_id
modifier_id}

end;

procedure TdmCarGoods.openSql(const S: string);
begin
  self.FDQuery1.Close;
  self.FDQuery1.Open(S);
end;

procedure TdmCarGoods.openTable;
begin
  self.FDQuery1.Close;
  self.FDQuery1.Open('select * from ap_car_brand');
  self.FDQuery2.Close;
  self.FDQuery2.Open('select * from ap_car_color_copy');
end;

procedure TdmCarGoods.rollback;
begin
  DmBase.rollback;
end;

procedure TdmCarGoods.startTransaction;
begin
  DmBase.StartTransaction;
end;

end.
