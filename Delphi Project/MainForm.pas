unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus,
  Vcl.DBCtrls, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, JSON, System.Generics.Collections, Vcl.Samples.Gauges;

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
    lblSearchFilter: TLabel;
    RESTClient2: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTResponse2: TRESTResponse;
    Gauge1: TGauge;
    procedure cmbFirstFilterChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure TreeView1Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
  private
    const BaseURLPlanets = 'https://swapi.dev/api/planets';
    const BaseURLPeople = 'https://swapi.dev/api/people';
    const BaseURLFilms = 'https://swapi.dev/api/films';
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFormMenu: TMainFormMenu;

implementation

{$R *.dfm}

procedure TMainFormMenu.btnSearchClick(Sender: TObject);
var
  jValue, jValueSub, jResult  : TJSONValue;
  node, nodeSub : TTreeNode;
  name, title, population, climate, release_date, gender, SubBaseURL, OpCrawl : String;
  lbFilter : Boolean;
  i, iSub: integer;
begin
  TreeView1.Items.Clear;
  RESTRequest1.Execute;
  jValue := RESTResponse1.JSONValue;
  {=- Planets -=}
  if cmbFirstFilter.ItemIndex = 0 then
  begin
    Gauge1.MaxValue := jValue.GetValue<Integer>('count');
    Gauge1.MinValue := 0;
    Gauge1.Progress := 0;
    TreeView1.Items.BeginUpdate;
    try
      repeat
        for i := 0 to Pred(jValue.GetValue<TJSonArray>('results').Count) do
        begin
          jResult := jValue.GetValue<TJSonArray>('results').Get(i);
          name := jResult.GetValue<String>('name');
          population := jResult.GetValue<String>('population');
          climate := jResult.GetValue<String>('climate');
          Gauge1.Progress := Gauge1.Progress + 1;
          case cmbSecondFilter.ItemIndex of
            0 : lbFilter := (Pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(name)) > 0);
            1 : lbFilter := population = edtSearch.Text;
            2 : lbFilter := (Pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(climate)) > 0);
          end;

          if (edtSearch.Text = '') or lbFilter then
          begin
            node := TreeView1.Items.AddChild(nil, name);
            TreeView1.Items.AddChild(node, 'Rotation Period: ' + jResult.GetValue<String>('rotation_period') + ' hours');
            TreeView1.Items.AddChild(node, 'Orbital Period: ' + jResult.GetValue<String>('orbital_period') + ' days');
            TreeView1.Items.AddChild(node, 'Diameter: ' + jResult.GetValue<String>('diameter') + ' kilometers');
            TreeView1.Items.AddChild(node, 'Climate: ' + jResult.GetValue<String>('climate'));
            TreeView1.Items.AddChild(node, 'Population: ' + jResult.GetValue<String>('population'));

            if jResult.GetValue<TJSonArray>('residents').Count <> 0 then
            nodeSub := TreeView1.Items.AddChild(node, 'Residents: ');

            for iSub := 0 to pred(jResult.GetValue<TJSonArray>('residents').Count) do
            begin
              SubBaseURL := StringReplace(jResult.GetValue<TJSonArray>('residents').Get(iSub).ToString, '\', '', [rfReplaceAll]);
              SubBaseURL := StringReplace(SubBaseURL, '"', '',[rfReplaceAll]);
              RESTClient2.BaseURL := SubBaseURL;
              RESTRequest2.Execute;
              jValueSub := RESTResponse2.JSONValue;
              TreeView1.Items.AddChild(nodeSub, jValueSub.GetValue<String>('name'));
            end;

            if jResult.GetValue<TJSonArray>('films').Count <> 0 then
            nodeSub := TreeView1.Items.AddChild(node, 'Films: ');

            for iSub := 0 to pred(jResult.GetValue<TJSonArray>('films').Count) do
            begin
              SubBaseURL := StringReplace(jResult.GetValue<TJSonArray>('films').Get(iSub).ToString, '\', '', [rfReplaceAll]);
              SubBaseURL := StringReplace(SubBaseURL, '"', '',[rfReplaceAll]);
              RESTClient2.BaseURL := SubBaseURL;
              RESTRequest2.Execute;
              jValueSub := RESTResponse2.JSONValue;
              TreeView1.Items.AddChild(nodeSub, jValueSub.GetValue<String>('title'));
            end;
          end;
        end;

        RestClient1.BaseURL := jValue.GetValue<String>('next');

        if (RestClient1.BaseURL <> '') then
        begin
          RESTRequest1.Execute;
          jValue := RESTResponse1.JSONValue;
        end;
      until (Gauge1.Progress = Gauge1.MaxValue);
    finally
      TreeView1.AlphaSort;
      TreeView1.Items.EndUpdate;
      RestClient1.BaseURL := BaseURLPlanets;
    end;
  end else
  {=- Characters -=}
  if cmbFirstFilter.ItemIndex = 1 then
  begin
    Gauge1.MaxValue := jValue.GetValue<Integer>('count');
    Gauge1.MinValue := 0;
    Gauge1.Progress := 0;
    TreeView1.Items.BeginUpdate;
    try
      repeat
        for i := 0 to Pred(jValue.GetValue<TJSonArray>('results').Count) do
        begin
          jResult := jValue.GetValue<TJSonArray>('results').Get(i);
          name := jResult.GetValue<String>('name');
          gender := jResult.GetValue<String>('gender');
          Gauge1.Progress := Gauge1.Progress + 1;

          case cmbSecondFilter.ItemIndex of
            0 : lbFilter := (Pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(name)) > 0);
            1 : lbFilter := AnsiUpperCase(edtSearch.Text) = AnsiUpperCase(gender);
          end;

          if (edtSearch.Text = '') or lbFilter then
          begin
            node := TreeView1.Items.AddChild(nil, name);
            TreeView1.Items.AddChild(node, 'Birth Year: ' + jResult.GetValue<String>('birth_year'));
            TreeView1.Items.AddChild(node, 'Gender: ' + jResult.GetValue<String>('gender'));
            if jResult.GetValue<TJSonArray>('films').Count <> 0 then
            nodeSub := TreeView1.Items.AddChild(node, 'Films: ');

            for iSub := 0 to pred(jResult.GetValue<TJSonArray>('films').Count) do
            begin
              SubBaseURL := StringReplace(jResult.GetValue<TJSonArray>('films').Get(iSub).ToString, '\', '', [rfReplaceAll]);
              SubBaseURL := StringReplace(SubBaseURL, '"', '',[rfReplaceAll]);
              RESTClient2.BaseURL := SubBaseURL;
              RESTRequest2.Execute;
              jValueSub := RESTResponse2.JSONValue;
              TreeView1.Items.AddChild(nodeSub, jValueSub.GetValue<String>('title'));
            end;
          end;
        end;

        RestClient1.BaseURL := jValue.GetValue<String>('next');
        if (RestClient1.BaseURL <> '') then
        begin
          RESTRequest1.Execute;
          jValue := RESTResponse1.JSONValue;
        end;
      until (Gauge1.Progress = Gauge1.MaxValue);
    finally
      TreeView1.AlphaSort;
      TreeView1.Items.EndUpdate;
      RestClient1.BaseURL := BaseURLPeople;
    end;
  end else
  {=- Films -=}
  if cmbFirstFilter.ItemIndex = 2 then
  begin
    Gauge1.MaxValue := jValue.GetValue<Integer>('count');
    Gauge1.MinValue := 0;
    Gauge1.Progress := 0;
    TreeView1.Items.BeginUpdate;
    try
      repeat
        for i := 0 to Pred(jValue.GetValue<TJSonArray>('results').Count) do
        begin
          jResult := jValue.GetValue<TJSonArray>('results').Get(i);
          title := jResult.GetValue<String>('title');
          release_date := jResult.GetValue<String>('release_date');
          Gauge1.Progress := Gauge1.Progress + 1;

          case cmbSecondFilter.ItemIndex of
            0 : lbFilter := (Pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(title)) > 0);
            1 : lbFilter := (Pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(release_date)) > 0);
          end;

          if (edtSearch.Text = '') or lbFilter then
          begin
            node := TreeView1.Items.AddChild(nil, Title);
            TreeView1.Items.AddChild(node, 'Title: ' + jResult.GetValue<String>('title'));
            TreeView1.Items.AddChild(node, 'Episode: ' + jResult.GetValue<String>('episode_id'));
            OpCrawl := StringReplace(jResult.GetValue<String>('opening_crawl'), #$D#$A , ' ', [rfReplaceAll]);
            TreeView1.Items.AddChild(node, 'Opening Crawl: ' + OpCrawl);
            TreeView1.Items.AddChild(node, 'Release Date: ' + jResult.GetValue<String>('release_date'));
            if jResult.GetValue<TJSonArray>('characters').Count <> 0 then

            nodeSub := TreeView1.Items.AddChild(node, 'Characters: ');

            for iSub := 0 to pred(jResult.GetValue<TJSonArray>('characters').Count) do
            begin
              SubBaseURL := StringReplace(jResult.GetValue<TJSonArray>('characters').Get(iSub).ToString, '\', '', [rfReplaceAll]);
              SubBaseURL := StringReplace(SubBaseURL, '"', '',[rfReplaceAll]);
              RESTClient2.BaseURL := SubBaseURL;
              RESTRequest2.Execute;
              jValueSub := RESTResponse2.JSONValue;
              TreeView1.Items.AddChild(nodeSub, jValueSub.GetValue<String>('name'));
            end;

            nodeSub := TreeView1.Items.AddChild(node, 'Planets: ');

            for iSub := 0 to pred(jResult.GetValue<TJSonArray>('planets').Count) do
            begin
              SubBaseURL := StringReplace(jResult.GetValue<TJSonArray>('planets').Get(iSub).ToString, '\', '', [rfReplaceAll]);
              SubBaseURL := StringReplace(SubBaseURL, '"', '',[rfReplaceAll]);
              RESTClient2.BaseURL := SubBaseURL;
              RESTRequest2.Execute;
              jValueSub := RESTResponse2.JSONValue;
              TreeView1.Items.AddChild(nodeSub, jValueSub.GetValue<String>('name'));
            end;
          end;
        end;
        RestClient1.BaseURL := jValue.GetValue<String>('next');
        if (RestClient1.BaseURL <> '') then
        begin
          RESTRequest1.Execute;
          jValue := RESTResponse1.JSONValue;
        end;
      until (jValue.GetValue<String>('next') = '');
    finally
      TreeView1.AlphaSort;
      TreeView1.Items.EndUpdate;
      RestClient1.BaseURL := BaseURLFilms;
    end;
  end;
  //***************************************************************************************************)
end;

procedure TMainFormMenu.cmbFirstFilterChange(Sender: TObject);
begin
  cmbSecondFilter.Items.Clear;
  case cmbFirstFilter.ItemIndex of
    0 : begin
          RestClient1.BaseURL := BaseURLPlanets;
          RestClient2.BaseURL := BaseURLPlanets;
          cmbSecondFilter.Items.Add('Name');
          cmbSecondFilter.Items.Add('Population');
          cmbSecondFilter.Items.Add('Climate');
        end;
    1 : begin
          RestClient1.BaseURL := BaseURLPeople;
          RestClient2.BaseURL := BaseURLPeople;
          cmbSecondFilter.Items.Add('Name');
          cmbSecondFilter.Items.Add('Gender');
        end;
    2 : begin
          RestClient1.BaseURL := BaseURLFilms;
          RestClient2.BaseURL := BaseURLFilms;
          cmbSecondFilter.Items.Add('Title');
          cmbSecondFilter.Items.Add('Date');
        end;
  end;
end;

procedure TMainFormMenu.TreeView1Editing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;
end.
