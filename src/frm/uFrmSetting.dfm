object frmSetting: TfrmSetting
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #35774#32622
  ClientHeight = 261
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 336
    Top = 207
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 744
    Height = 179
    Align = alTop
    Caption = 'DB '#36830#25509#23646#24615
    TabOrder = 1
    ExplicitLeft = -66
    ExplicitTop = 29
    ExplicitWidth = 905
    object Label9: TLabel
      Left = 23
      Top = 154
      Width = 46
      Height = 13
      Caption = 'password'
    end
    object Label8: TLabel
      Left = 23
      Top = 127
      Width = 48
      Height = 13
      Caption = 'userName'
    end
    object serverLabel: TLabel
      Left = 23
      Top = 50
      Width = 31
      Height = 13
      Caption = 'server'
    end
    object Label2: TLabel
      Left = 23
      Top = 23
      Width = 53
      Height = 13
      Caption = 'driverClass'
    end
    object Label1: TLabel
      Left = 23
      Top = 75
      Width = 20
      Height = 13
      Caption = 'port'
    end
    object Label3: TLabel
      Left = 231
      Top = 23
      Width = 36
      Height = 13
      Caption = 'charset'
    end
    object Label4: TLabel
      Left = 23
      Top = 102
      Width = 45
      Height = 13
      Caption = 'database'
    end
    object btnSaveDbInfo: TButton
      Left = 365
      Top = 96
      Width = 75
      Height = 25
      Caption = #20445#23384#36830#25509
      TabOrder = 0
    end
    object edtPort: TEdit
      Left = 103
      Top = 71
      Width = 241
      Height = 21
      TabOrder = 1
      Text = 'edtPort'
    end
    object cbxCharset: TComboBox
      Left = 279
      Top = 19
      Width = 65
      Height = 21
      TabOrder = 2
      Text = 'utf8'
      Items.Strings = (
        'utf8')
    end
    object edtUserName: TEdit
      Left = 103
      Top = 124
      Width = 241
      Height = 21
      TabOrder = 3
      Text = 'userName'
    end
    object edtPassword: TEdit
      Left = 103
      Top = 151
      Width = 241
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
      Text = 'password'
    end
    object btnTestDbInfo: TButton
      Left = 365
      Top = 43
      Width = 75
      Height = 25
      Caption = #27979#35797#36830#25509
      TabOrder = 5
    end
    object cbxDriverId: TComboBox
      Left = 103
      Top = 19
      Width = 105
      Height = 21
      ItemIndex = 0
      TabOrder = 6
      Text = 'MySQL'
      Items.Strings = (
        'MySQL'
        'MSSQL'
        'Ora'
        'MSAcc'
        'DB2')
    end
    object edtServer: TEdit
      Left = 103
      Top = 45
      Width = 241
      Height = 21
      TabOrder = 7
      Text = 'edtServer'
    end
    object edtDatabase: TEdit
      Left = 103
      Top = 98
      Width = 241
      Height = 21
      TabOrder = 8
      Text = 'edtDatabase'
    end
    object FDGUIxFormsMemo1: TFDGUIxFormsMemo
      Left = 464
      Top = 18
      Width = 217
      Height = 154
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 9
      Visible = False
      WordWrap = False
    end
  end
end
