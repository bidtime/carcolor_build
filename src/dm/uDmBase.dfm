object dmBase: TdmBase
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 64
  Width = 181
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=test'
      'User_Name=root'
      'Password=123456'
      'Server=172.16.107.196'
      'CharacterSet=utf8'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 32
    Top = 8
  end
  object GUIxCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 112
    Top = 8
  end
end
