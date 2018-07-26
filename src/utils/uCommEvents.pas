unit uCommEvents;

interface

uses
  Windows, Classes, DB;

type
  TRowNextEvent = procedure(TDataSet: TObject; const batch: boolean; strs: TStrings) of object;
  {private
  protected
  public
  end;}

implementation

end.
