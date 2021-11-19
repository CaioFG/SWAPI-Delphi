unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus,
  Vcl.DBCtrls, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, JSON, System.Generics.Collections;

type
  TMainFormMenu = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    TreeView1: TTreeView;
    cmbFirstFilter: TComboBox;
    cmbSecondFilter: TComboBox;
    btnSearch: TButton;
    lblFirstFilter: TLabel;
    lblSecondFilter: TLabel;
    edtSearch: TEdit;
    btnSucc: TButton;
    btnPred: TButton;
    lblSearchFilter: TLabel;
    procedure cmbFirstFilterChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnSuccClick(Sender: TObject);
    procedure btnPredClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormMenu: TMainFormMenu;

implementation

{$R *.dfm}

procedure TMainFormMenu.btnPredClick(Sender: TObject);
var
  jValue : TJSONValue;
  prev : String;
begin
  jValue := RESTResponse1.JSONValue;
  prev := jValue.GetValue<TJSonString>('previous').GetValue<String>('');
end;

procedure TMainFormMenu.btnSearchClick(Sender: TObject);
var
  jValue : TJSONValue;
  node : TTreeNode;
  name : String;
  i : integer;
begin
  TreeView1.Items.Clear;
  RESTRequest1.Execute;
  jValue := RESTResponse1.JSONValue;
  if RestClient1.BaseURL = 'https://swapi.dev/api/planets' then
  begin
    for i := 0 to Pred(jValue.GetValue<TJSonArray>('results').Count) do
    begin
      name := jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('name');
      node := TreeView1.Items.AddChild(nil, name);
      TreeView1.Items.AddChild(node, 'Rotation Period: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('rotation_period') + ' hours');
      TreeView1.Items.AddChild(node, 'Orbital Period: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('orbital_period') + ' days');
      TreeView1.Items.AddChild(node, 'Diameter: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('diameter') + ' kilometers');
      TreeView1.Items.AddChild(node, 'Climate: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('climate'));
//      TreeView1.Items.AddChild(node, 'Residents: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('residents'));
//      TreeView1.Items.AddChild(node, 'Films: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('films'));
    end;
  end else
  if RestClient1.BaseURL = 'https://swapi.dev/api/people' then
  begin
    for i := 0 to Pred(jValue.GetValue<TJSonArray>('results').Count) do
    begin
      name := jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('name');
      node := TreeView1.Items.AddChild(nil, name);
      TreeView1.Items.AddChild(node, 'Birth Year: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('birth_year'));
      TreeView1.Items.AddChild(node, 'Gender: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('gender'));
//      TreeView1.Items.AddChild(node, 'Films: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('films'));
    end;
  end else
  begin
  for i := 0 to Pred(jValue.GetValue<TJSonArray>('results').Count) do
    begin
      name := jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('title');
      node := TreeView1.Items.AddChild(nil, name);
      TreeView1.Items.AddChild(node, 'Title: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('title'));
      TreeView1.Items.AddChild(node, 'Episode: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('episode_id'));
      TreeView1.Items.AddChild(node, 'Opening Crawl: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('opening_crawl'));
      TreeView1.Items.AddChild(node, 'Release Date: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('release_date'));
//      TreeView1.Items.AddChild(node, 'Characters: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('characters'));
//      TreeView1.Items.AddChild(node, 'Planets: ' + jValue.GetValue<TJSonArray>('results').Get(i).GetValue<String>('planets'));
    end;
  end;


end;

procedure TMainFormMenu.btnSuccClick(Sender: TObject);
begin
  // need to finish
end;

procedure TMainFormMenu.cmbFirstFilterChange(Sender: TObject);
begin
  cmbSecondFilter.Items.Clear;
  case cmbFirstFilter.ItemIndex of
    0 : begin
          RestClient1.BaseURL := 'https://swapi.dev/api/planets';
          cmbSecondFilter.Items.Add('Name');
          cmbSecondFilter.Items.Add('Population');
          cmbSecondFilter.Items.Add('Climate');
        end;
    1 : begin
          RestClient1.BaseURL := 'https://swapi.dev/api/people/';
          cmbSecondFilter.Items.Add('Name');
          cmbSecondFilter.Items.Add('Gender');
        end;
    2 : begin
          RestClient1.BaseURL := 'https://swapi.dev/api/films';
          cmbSecondFilter.Items.Add('Name');
          cmbSecondFilter.Items.Add('Date');
        end;
  end;
end;

end.