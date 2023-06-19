# If you prefer to run the code online instead of on your computer click:
# https://github.com/Coding-with-Adam/Dash-by-Plotly#execute-code-in-browser
import math

from dash import Dash, dcc, Output, Input  # pip install dash
import dash_bootstrap_components as dbc  # pip install dash-bootstrap-components
import plotly.graph_objects as go
import plotly.express as px
import pandas as pd  # pip install pandas
import dash_daq as daq

# incorporate data into app
# Source - https://www.cdc.gov/nchs/pressroom/stats_of_the_states.htm
df_subs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/subnets_outgoing_sources_goodconns.csv")
#df_subs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/subnets_incoming_targets_goodconns.csv")
df_subs_out_dep = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/sourceIPs.csv")

# Build your components
app = Dash(__name__, external_stylesheets=[dbc.themes.CERULEAN])

# First batch of graphs
myFirstTitle = dcc.Markdown(children='## Source Subnets on Outgoing Connections - ')
myFirstGraph = dcc.Graph(figure={})
myFirstDropdown = dcc.Dropdown(options=['Total Bytes', 'Inbound', 'Outbound', 'Difference', 'Connections', 'Source IPs',
                                        'Target IPs', 'Source Ports', 'Target Ports'],
                               value='Total Bytes',  # initial value displayed when page first loads
                               clearable=False)
myFirstChoice = daq.NumericInput(min=1, max=257, value=257)

myDependentGraph = dcc.Graph(figure={})
myDependentTitle = dcc.Markdown(children='#### Distribution of the Selected Subnet - ')

# Second batch of graphs
mySecondTitle = dcc.Markdown(children='## Connections to/from Subnet Groups - ')
mySecondGraph_1 = dcc.Graph(figure={})
mySecondGraph_2 = dcc.Graph(figure={})
mySecondGraph_3 = dcc.Graph(figure={})
mySecondGraph_4 = dcc.Graph(figure={})
mySecondDropdown = dcc.Dropdown(
    options=['CPSC', 'Schulich', 'Science', 'Medical', 'Physics', 'Arts', 'Kinesiology',
             'Reznet', 'Admin', 'Haskayne', 'Services', 'VPN', 'WiFi', 'WLAN', 'Others'],
    value='CPSC',  # initial value displayed when page first loads
    clearable=False)

# Customize your own Layout
app.layout = dbc.Container([
    dbc.Row([
        dbc.Col([myFirstTitle], width=5)
    ], justify='center'),
    dbc.Row([
        dbc.Col([myFirstGraph], width=12)
    ]),
    dbc.Row([
        dbc.Col([myFirstDropdown], width=3), dbc.Col([myFirstChoice], width=1)
    ], justify='center'),

    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),
    dbc.Row([dbc.Col([myDependentTitle], width=5)], justify='center'),
    dbc.Row([dbc.Col([myDependentGraph], width=12)]),

    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),

    dbc.Row([
        dbc.Col([mySecondTitle], width=5)
    ], justify='center'),
    dbc.Row([
        dbc.Col([mySecondGraph_1], width=3),
        dbc.Col([mySecondGraph_2], width=3),
        dbc.Col([mySecondGraph_3], width=3),
        dbc.Col([mySecondGraph_4], width=3),
    ]),
    dbc.Row([
        dbc.Col([mySecondDropdown], width=3),
    ], justify='center'),

], fluid=True)


# Callback allows components to interact
@app.callback(
    Output(myFirstGraph, 'figure'),
    Output(myFirstTitle, 'children'),
    Output(mySecondGraph_1, 'figure'),
    Output(mySecondGraph_2, 'figure'),
    Output(mySecondGraph_3, 'figure'),
    Output(mySecondGraph_4, 'figure'),
    Output(mySecondTitle, 'children'),
    Input(myFirstDropdown, 'value'),
    Input(myFirstChoice, 'value'),
    Input(mySecondDropdown, 'value'),
)
def update_graph(column_name_one, top_picks_one, column_name_two):  # function arguments come from the
    # component property of the Input
    # print("column_name_one: ", column_name_one)
    # print("type of column_name_one: ", type(column_name_one))
    # print("column_name_two: ", column_name_two)
    # print("type of column_name_two: ", type(column_name_two))
    # print("top_picks_one value: ", top_picks_one)

    new_df_one = df_subs_out.drop(df_subs_out[df_subs_out.Rank > int(top_picks_one)].index)

    # ==================================================================================================================

    # region Section_1
    if column_name_one == "Connections":
        min_Conns = new_df_one["Connections"].min()
        max_Conns = new_df_one["Connections"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="Connections", range_x=[0, 256], range_y=[min_Conns, max_Conns],
                     height=500, animation_frame='Week', log_y=True, hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Total Bytes":
        min_TotalBytes = new_df_one["TotalBytes"].min()
        max_TotalBytes = new_df_one["TotalBytes"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="TotalBytes", range_x=[0, 256], range_y=[min_TotalBytes, max_TotalBytes],
                     height=500, animation_frame='Week', log_y=True, hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Inbound":
        min_Inbound = new_df_one["Inbound"].min()
        max_Inbound = new_df_one["Inbound"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="Inbound", range_x=[0, 256], range_y=[min_Inbound, max_Inbound],
                     height=500, animation_frame='Week', log_y=True, hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Outbound":
        min_Outbound = new_df_one["Outbound"].min()
        max_Outbound = new_df_one["Outbound"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="Outbound", range_x=[0, 256], range_y=[min_Outbound, max_Outbound],
                     height=500, animation_frame='Week', log_y=True, hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Difference":
        min_Diff = new_df_one["Difference"].min()
        max_Diff = new_df_one["Difference"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="Difference", range_x=[0, 256], range_y=[min_Diff, max_Diff],
                     height=500, animation_frame='Week', log_y=True, color="Color", hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Source IPs":
        min_SourceIPs = new_df_one["SourceIPs"].min()
        max_SourceIPs = new_df_one["SourceIPs"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="SourceIPs", range_x=[0, 256], range_y=[min_SourceIPs, max_SourceIPs],
                     height=500, animation_frame='Week', hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Target IPs":
        min_TargetIPs = new_df_one["TargetIPs"].min()
        max_TargetIPs = new_df_one["TargetIPs"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="TargetIPs", range_x=[0, 256], range_y=[min_TargetIPs, max_TargetIPs],
                     height=500, animation_frame='Week', hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Source Ports":
        min_SourcePorts = new_df_one["SourcePorts"].min()
        max_SourcePorts = new_df_one["SourcePorts"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="SourcePorts", range_x=[0, 256], range_y=[min_SourcePorts, max_SourcePorts],
                     height=500, animation_frame='Week', hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif column_name_one == "Target Ports":
        min_TargetPorts = new_df_one["TargetPorts"].min()
        max_TargetPorts = new_df_one["TargetPorts"].max()
        fig = px.bar(data_frame=new_df_one, x="Rank", y="TargetPorts", range_x=[0, 256], range_y=[min_TargetPorts, max_TargetPorts],
                     height=500, animation_frame='Week', hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    else:
        fig = px.bar(data_frame=new_df_one, x="Rank", y=column_name_one, height=500, range_x=[1, 257], animation_frame='Week', hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    fig.update_xaxes(range=[0, 256], autorange=False)
    fig.layout.updatemenus[0].buttons[0].args[1]['frame']['duration'] = 800
    fig.layout.updatemenus[0].buttons[0].args[1]['transition']['duration'] = 500
    fig.update_traces(width=1, textangle=0, textposition='outside')
    # endregion

    # ==================================================================================================================

    # region Section_3
    if column_name_two == "CPSC":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_cpsc_subnets.csv")

    elif column_name_two == "Schulich":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_schulich_subnets.csv")

    elif column_name_two == "Science":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_science_subnets.csv")

    elif column_name_two == "Medical":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_medical_subnets.csv")

    elif column_name_two == "Physics":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_physics_subnets.csv")

    elif column_name_two == "Arts":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_arts_subnets.csv")

    elif column_name_two == "Kinesiology":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_kinesiology_subnets.csv")

    elif column_name_two == "Reznet":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_reznet_subnets.csv")

    elif column_name_two == "Admin":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_admin_subnets.csv")

    elif column_name_two == "Haskayne":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_haskayne_subnets.csv")

    elif column_name_two == "Services":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_services_subnets.csv")

    elif column_name_two == "VPN":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_vpn_subnets.csv")

    elif column_name_two == "WiFi":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wifi_subnets.csv")

    elif column_name_two == "WLAN":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wlan_subnets.csv")

    elif column_name_two == "Others":
        new_df_two = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_others_subnets.csv")

    fig_two_conn = px.bar(data_frame=new_df_two, x="Week", y="Connections", height=600)

    fig_two_bytes = px.bar(data_frame=new_df_two, x="Week", y="TotalBytes", height=600)

    fig_two_inout = go.Figure()
    fig_two_inout.add_trace(go.Bar(x=new_df_two["Week"], y=new_df_two["Inbound"], name="Inbound", offsetgroup=0))
    fig_two_inout.add_trace(go.Bar(x=new_df_two["Week"], y=new_df_two["Outbound"] * -1, name="Outbound", offsetgroup=0))
    fig_two_inout.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_two_inout.update_xaxes(title="Week")
    fig_two_inout.update_yaxes(title="Bytes")

    fig_two_diff = go.Figure()
    fig_two_diff.add_trace(go.Bar(x=new_df_two["Week"], y=(new_df_two["Inbound"] - new_df_two["Outbound"]), name='In > Out', offsetgroup=0))
    fig_two_diff.add_trace(go.Bar(x=new_df_two["Week"], y=(new_df_two["Outbound"] - new_df_two["Inbound"]), name='Out > In', offsetgroup=0))
    fig_two_diff.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_two_diff.update_xaxes(title="Week")
    fig_two_diff.update_yaxes(title="Difference in Asymmetry", type="log")

    # fig_two_conn.layout.updatemenus[0].buttons[0].args[1]['frame']['duration'] = 800
    # fig_two_conn.layout.updatemenus[0].buttons[0].args[1]['transition']['duration'] = 500
    # endregion

    # ==================================================================================================================

    return fig, '## Source Subnets on Outgoing Connection - ' + column_name_one, fig_two_conn, fig_two_bytes, fig_two_inout, fig_two_diff, '## Connections to/from Subnet Group - ' + column_name_two
    # returned objects are assigned to the component property of the Output


@app.callback(
    Output(myDependentGraph, component_property='figure'),
    Output(myDependentTitle, component_property='children'),
    Input(myFirstGraph, component_property='clickData'),
    Input(myFirstDropdown, component_property='value'),
)
def update_dependent_graph(click_data, graph_type):

    # ==================================================================================================================

    # region Section_2
    selected_subnet = None
    thisWeek = 'Feb 2020'
    print('<click_data>: ', click_data)
    if click_data is not None:
        thisWeek = click_data['points'][0]['customdata'][0]
        selected_subnet = click_data['points'][0]['customdata'][1]

    print('<selected_subnet>: ', selected_subnet)
    print('<the selected week>: ', thisWeek)
    print('<graph_type>: ', str(graph_type).replace(" ", ""))

    new_df_dep = df_subs_out_dep.loc[(df_subs_out_dep["SourceSubnet"] == selected_subnet) & (df_subs_out_dep["Week"] == thisWeek)]
    print('<new_df_dep dataframe>: ')
    print(new_df_dep)

    if str(graph_type).replace(" ", "") == 'SourceIPs':
        fig_dep = px.bar(data_frame=new_df_dep, x="SourceIP", y='TotalBytes', range_x=[0, 255], height=500, log_y=True)
        fig_dep.update_traces(width=1, marker_color='green')
    elif str(graph_type).replace(" ", "") == 'Difference':
        fig_dep = px.bar(data_frame=new_df_dep, x="SourceIP", y=str(graph_type).replace(" ", ""), range_x=[0, 255], color='Color', height=500, log_y=True)
        fig_dep.update_traces(width=1)
    else:
        fig_dep = px.bar(data_frame=new_df_dep, x="SourceIP", y=str(graph_type).replace(" ", ""), range_x=[0, 255], height=500, log_y=True)
        fig_dep.update_traces(width=1, marker_color='green')

    # endregion

    # ==================================================================================================================

    return fig_dep, '### Distribution of the Selected Subnet in ' + thisWeek + ' - ' + str(selected_subnet)


# Run app
if __name__ == '__main__':
    app.run_server(debug=True, port=8054)

