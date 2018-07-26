object dmCarGoods: TdmCarGoods
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 222
  Width = 338
  object FDQuery1: TFDQuery
    Connection = dmBase.FDConnection1
    Left = 32
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 128
    Top = 16
  end
  object FDQuery2: TFDQuery
    AfterInsert = FDQuery2AfterInsert
    Connection = dmBase.FDConnection1
    Left = 32
    Top = 72
  end
  object DataSource2: TDataSource
    DataSet = FDQuery2
    Left = 128
    Top = 72
  end
end
