object MainFormMenu: TMainFormMenu
  Left = 0
  Top = 0
  Caption = 'Menu'
  ClientHeight = 600
  ClientWidth = 390
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblFirstFilter: TLabel
    Left = 17
    Top = 19
    Width = 105
    Height = 13
    Caption = 'Select your first filter:'
  end
  object lblSecondFilter: TLabel
    Left = 17
    Top = 47
    Width = 120
    Height = 13
    Caption = 'Select your second filter:'
  end
  object lblSearchFilter: TLabel
    Left = 17
    Top = 75
    Width = 99
    Height = 13
    Caption = 'Specify your search:'
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 133
    Width = 369
    Height = 424
    Align = alCustom
    Indent = 19
    TabOrder = 0
  end
  object cmbFirstFilter: TComboBox
    Left = 152
    Top = 16
    Width = 225
    Height = 22
    Style = csOwnerDrawFixed
    TabOrder = 1
    OnChange = cmbFirstFilterChange
    Items.Strings = (
      'Planets'
      'Characters'
      'Films')
  end
  object cmbSecondFilter: TComboBox
    Left = 152
    Top = 44
    Width = 225
    Height = 22
    Style = csOwnerDrawFixed
    TabOrder = 2
  end
  object btnSearch: TButton
    Left = 152
    Top = 99
    Width = 225
    Height = 28
    Caption = 'Search'
    TabOrder = 3
    OnClick = btnSearchClick
  end
  object edtSearch: TEdit
    Left = 152
    Top = 72
    Width = 225
    Height = 21
    TabOrder = 4
  end
  object btnSucc: TButton
    Left = 302
    Top = 567
    Width = 75
    Height = 25
    Caption = 'Next'
    TabOrder = 5
    OnClick = btnSuccClick
  end
  object btnPred: TButton
    Left = 221
    Top = 567
    Width = 75
    Height = 25
    Caption = 'Previous'
    TabOrder = 6
    OnClick = btnPredClick
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://swapi.dev/api/planets'
    Params = <>
    Left = 24
    Top = 560
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    Left = 96
    Top = 560
  end
  object RESTResponse1: TRESTResponse
    Left = 176
    Top = 560
  end
end