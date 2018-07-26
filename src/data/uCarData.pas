unit uCarData;

interface

uses uCarBase;

type
  TCarData = class(TCarBase)
  protected
    state: string;
    sort_no: string;
    create_time: string;
    modify_time: string;
    creator_id: string;
    modifier_id: string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses SysUtils, classes;

{ TCarData }

constructor TCarData.Create;
begin
  state := '1';
  sort_no := '0';
  create_time := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  modify_time := create_time;
  creator_id := '0';
  modifier_id := '0';
end;

destructor TCarData.Destroy;
begin
end;

end.

