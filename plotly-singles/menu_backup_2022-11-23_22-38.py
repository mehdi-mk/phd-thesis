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
df_subs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/subnets_incoming_targets_goodconns.csv")
df_subs_out_dep = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/sourceIPs.csv")
df_subs_in_dep = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/targetIPs.csv")

# Build your components
app = Dash(__name__, external_stylesheets=[dbc.themes.CERULEAN])

# Graphs for outgoing connections
title_subs_out = dcc.Markdown(children='## Source Subnets on Outgoing Connections - ')
graph_subs_out = dcc.Graph(figure={})
dropdown_subs_out = dcc.Dropdown(options=['Total Bytes', 'Inbound', 'Outbound', 'Difference', 'Connections', 'Source IPs',
                                          'Target IPs', 'Source Ports', 'Target Ports'],
                                 value='Total Bytes',  # initial value displayed when page first loads
                                 clearable=False)
choice_subs_out = daq.NumericInput(min=1, max=257, value=257)

depGraph_subs_out = dcc.Graph(figure={})
depTitle_subs_out = dcc.Markdown(children='#### Distribution of the Selected Subnet in Outgoing Connections - ')

# Graphs for incoming connections
title_subs_in = dcc.Markdown(children='## Target Subnets on Incoming Connections - ')
graph_subs_in = dcc.Graph(figure={})
dropdown_subs_in = dcc.Dropdown(options=['Total Bytes', 'Inbound', 'Outbound', 'Difference', 'Connections',
                                         'Source IPs', 'Target IPs', 'Source Ports', 'Target Ports'],
                                value='Total Bytes',  # initial value displayed when page first loads
                                clearable=False)
choice_subs_in = daq.NumericInput(min=1, max=257, value=257)

depGraph_subs_in = dcc.Graph(figure={})
depTitle_subs_in = dcc.Markdown(children='#### Distribution of the Selected Subnet in Incoming Connections - ')

# Graphs for groups - overall connections
title_groups_total = dcc.Markdown(children='## All Connections to/from Subnet Groups - ')
graph_groups_total_conns = dcc.Graph(figure={})
graph_groups_total_bytes = dcc.Graph(figure={})
graph_groups_total_inout = dcc.Graph(figure={})
graph_groups_total_asym = dcc.Graph(figure={})
dropdown_groups_total = dcc.Dropdown(
    options=['CPSC', 'Schulich', 'Science', 'Medical', 'PHAS', 'Arts', 'Kinesiology',
             'Reznet', 'Admin', 'Haskayne', 'Services', 'VPN', 'WiFi', 'WLAN', 'Others'],
    value='CPSC',  # initial value displayed when page first loads
    clearable=False)

# Graphs for groups - outgoing connections
title_groups_out = dcc.Markdown(children='## Outgoing Connections from Subnet Groups - ')
graph_groups_out_conns = dcc.Graph(figure={})
graph_groups_out_bytes = dcc.Graph(figure={})
graph_groups_out_inout = dcc.Graph(figure={})
graph_groups_out_asym = dcc.Graph(figure={})
dropdown_groups_out = dcc.Dropdown(
    options=['CPSC', 'Schulich', 'Science', 'Medical', 'PHAS', 'Arts', 'Kinesiology',
             'Reznet', 'Admin', 'Haskayne', 'Services', 'VPN', 'WiFi', 'WLAN', 'Others'],
    value='CPSC',  # initial value displayed when page first loads
    clearable=False)

# Graphs for groups - incoming connections
title_groups_in = dcc.Markdown(children='## Incoming Connections to Subnet Groups - ')
graph_groups_in_conns = dcc.Graph(figure={})
graph_groups_in_bytes = dcc.Graph(figure={})
graph_groups_in_inout = dcc.Graph(figure={})
graph_groups_in_asym = dcc.Graph(figure={})
dropdown_groups_in = dcc.Dropdown(
    options=['CPSC', 'Schulich', 'Science', 'Medical', 'PHAS', 'Arts', 'Kinesiology',
             'Reznet', 'Admin', 'Haskayne', 'Services', 'VPN', 'WiFi', 'WLAN', 'Others'],
    value='CPSC',  # initial value displayed when page first loads
    clearable=False)

# Customize your own Layout
app.layout = dbc.Container([
    # Section layout for incoming connections
    dbc.Row([
        dbc.Col([title_subs_out], width=6)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_subs_out], width=12)
    ]),
    dbc.Row([
        dbc.Col([dropdown_subs_out], width=3), dbc.Col([choice_subs_out], width=1)
    ], justify='center'),

    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),
    dbc.Row([dbc.Col([depTitle_subs_out], width=7)], justify='center'),
    dbc.Row([dbc.Col([depGraph_subs_out], width=12)]),

    # Section layout for incoming connections
    dbc.Row([
        dbc.Col([title_subs_in], width=6)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_subs_in], width=12)
    ]),
    dbc.Row([
        dbc.Col([dropdown_subs_in], width=3), dbc.Col([choice_subs_in], width=1)
    ], justify='center'),

    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),
    dbc.Row([dbc.Col([depTitle_subs_in], width=7)], justify='center'),
    dbc.Row([dbc.Col([depGraph_subs_in], width=12)]),

    # Divider
    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),

    # Section layout for groups - overall connections
    dbc.Row([
        dbc.Col([title_groups_total], width=5)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_groups_total_conns], width=3),
        dbc.Col([graph_groups_total_bytes], width=3),
        dbc.Col([graph_groups_total_inout], width=3),
        dbc.Col([graph_groups_total_asym], width=3),
    ]),
    dbc.Row([
        dbc.Col([dropdown_groups_total], width=3),
    ], justify='center'),

    # Divider
    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),

    # Section layout for groups - outgoing connections
    dbc.Row([
        dbc.Col([title_groups_out], width=5)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_groups_out_conns], width=3),
        dbc.Col([graph_groups_out_bytes], width=3),
        dbc.Col([graph_groups_out_inout], width=3),
        dbc.Col([graph_groups_out_asym], width=3),
    ]),
    dbc.Row([
        dbc.Col([dropdown_groups_out], width=3),
    ], justify='center'),

    # Divider
    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),

    # Section layout for groups - incoming connections
    dbc.Row([
        dbc.Col([title_groups_in], width=5)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_groups_in_conns], width=3),
        dbc.Col([graph_groups_in_bytes], width=3),
        dbc.Col([graph_groups_in_inout], width=3),
        dbc.Col([graph_groups_in_asym], width=3),
    ]),
    dbc.Row([
        dbc.Col([dropdown_groups_in], width=3),
    ], justify='center'),

], fluid=True)


# Callback allows components to interact
@app.callback(
    Output(graph_subs_out, 'figure'),
    Output(title_subs_out, 'children'),
    Output(graph_subs_in, 'figure'),
    Output(title_subs_in, 'children'),
    Output(graph_groups_total_conns, 'figure'),
    Output(graph_groups_total_bytes, 'figure'),
    Output(graph_groups_total_inout, 'figure'),
    Output(graph_groups_total_asym, 'figure'),
    Output(title_groups_total, 'children'),
    Output(graph_groups_out_conns, 'figure'),
    Output(graph_groups_out_bytes, 'figure'),
    Output(graph_groups_out_inout, 'figure'),
    Output(graph_groups_out_asym, 'figure'),
    Output(title_groups_out, 'children'),
    Output(graph_groups_in_conns, 'figure'),
    Output(graph_groups_in_bytes, 'figure'),
    Output(graph_groups_in_inout, 'figure'),
    Output(graph_groups_in_asym, 'figure'),
    Output(title_groups_in, 'children'),
    Input(dropdown_subs_out, 'value'),
    Input(choice_subs_out, 'value'),
    Input(dropdown_subs_in, 'value'),
    Input(choice_subs_in, 'value'),
    Input(dropdown_groups_total, 'value'),
    Input(dropdown_groups_out, 'value'),
    Input(dropdown_groups_in, 'value'),
)
def update_graph(type_graph_subs_out, top_picks_subs_out, type_graph_subs_in, top_picks_subs_in,
                 type_graph_groups_total, type_graph_groups_out, type_graph_groups_in):  # function arguments come from the
    # component property of the Input
    # print("column_name_one: ", column_name_one)
    # print("type of column_name_one: ", type(column_name_one))
    # print("column_name_two: ", column_name_two)
    # print("type of column_name_two: ", type(column_name_two))
    # print("top_picks_one value: ", top_picks_one)

    new_df_subs_out = df_subs_out.drop(df_subs_out[df_subs_out.Rank > int(top_picks_subs_out)].index)
    new_df_subs_in = df_subs_in.drop(df_subs_in[df_subs_in.Rank > int(top_picks_subs_in)].index)

    # ==================================================================================================================

    # region Section_Subs_Out
    if type_graph_subs_out == "Connections":
        min_Conns = new_df_subs_out["Connections"].min()
        max_Conns = new_df_subs_out["Connections"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="Connections", range_x=[0, 256],
                              range_y=[min_Conns, max_Conns], height=500, animation_frame='Week', log_y=True,
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Total Bytes":
        min_TotalBytes = new_df_subs_out["TotalBytes"].min()
        max_TotalBytes = new_df_subs_out["TotalBytes"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="TotalBytes", range_x=[0, 256],
                              range_y=[min_TotalBytes, max_TotalBytes], height=500, animation_frame='Week', log_y=True,
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Inbound":
        min_Inbound = new_df_subs_out["Inbound"].min()
        max_Inbound = new_df_subs_out["Inbound"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="Inbound", range_x=[0, 256],
                              range_y=[min_Inbound, max_Inbound], height=500, animation_frame='Week', log_y=True,
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Outbound":
        min_Outbound = new_df_subs_out["Outbound"].min()
        max_Outbound = new_df_subs_out["Outbound"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="Outbound", range_x=[0, 256],
                              range_y=[min_Outbound, max_Outbound], height=500, animation_frame='Week', log_y=True,
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Difference":
        min_Diff = new_df_subs_out["Difference"].min()
        max_Diff = new_df_subs_out["Difference"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="Difference", range_x=[0, 256],
                              range_y=[min_Diff, max_Diff], height=500, animation_frame='Week', log_y=True,
                              color="Color", color_discrete_map={"In > Out": "blue", "Out > In": "red"},
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Source IPs":
        min_SourceIPs = new_df_subs_out["SourceIPs"].min()
        max_SourceIPs = new_df_subs_out["SourceIPs"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="SourceIPs", range_x=[0, 256],
                              range_y=[min_SourceIPs, max_SourceIPs], height=500, animation_frame='Week',
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Target IPs":
        min_TargetIPs = new_df_subs_out["TargetIPs"].min()
        max_TargetIPs = new_df_subs_out["TargetIPs"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="TargetIPs", range_x=[0, 256],
                              range_y=[min_TargetIPs, max_TargetIPs], height=500, animation_frame='Week',
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Source Ports":
        min_SourcePorts = new_df_subs_out["SourcePorts"].min()
        max_SourcePorts = new_df_subs_out["SourcePorts"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="SourcePorts", range_x=[0, 256],
                              range_y=[min_SourcePorts, max_SourcePorts], height=500, animation_frame='Week',
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    elif type_graph_subs_out == "Target Ports":
        min_TargetPorts = new_df_subs_out["TargetPorts"].min()
        max_TargetPorts = new_df_subs_out["TargetPorts"].max()
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y="TargetPorts", range_x=[0, 256],
                              range_y=[min_TargetPorts, max_TargetPorts], height=500, animation_frame='Week',
                              hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    else:
        fig_subs_out = px.bar(data_frame=new_df_subs_out, x="Rank", y=type_graph_subs_out, height=500, range_x=[1, 257],
                              animation_frame='Week', hover_data=["Week", "SourceSubnet"], text="SourceSubnet")

    fig_subs_out.update_xaxes(range=[0, 256], autorange=False)
    fig_subs_out.layout.updatemenus[0].buttons[0].args[1]['frame']['duration'] = 800
    fig_subs_out.layout.updatemenus[0].buttons[0].args[1]['transition']['duration'] = 500
    fig_subs_out.update_traces(width=1, textangle=0, textposition='outside')
    # endregion

    # ==================================================================================================================

    # region Section_Subs_In
    if type_graph_subs_in == "Connections":
        min_Conns = new_df_subs_in["Connections"].min()
        max_Conns = new_df_subs_in["Connections"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="Connections", range_x=[0, 256],
                             range_y=[min_Conns, max_Conns], height=500, animation_frame='Week', log_y=True,
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Total Bytes":
        min_TotalBytes = new_df_subs_in["TotalBytes"].min()
        max_TotalBytes = new_df_subs_in["TotalBytes"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="TotalBytes", range_x=[0, 256],
                             range_y=[min_TotalBytes, max_TotalBytes], height=500, animation_frame='Week', log_y=True,
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Inbound":
        min_Inbound = new_df_subs_in["Inbound"].min()
        max_Inbound = new_df_subs_in["Inbound"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="Inbound", range_x=[0, 256],
                             range_y=[min_Inbound, max_Inbound], height=500, animation_frame='Week', log_y=True,
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Outbound":
        min_Outbound = new_df_subs_in["Outbound"].min()
        max_Outbound = new_df_subs_in["Outbound"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="Outbound", range_x=[0, 256],
                             range_y=[min_Outbound, max_Outbound], height=500, animation_frame='Week', log_y=True,
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Difference":
        min_Diff = new_df_subs_in["Difference"].min()
        max_Diff = new_df_subs_in["Difference"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="Difference", range_x=[0, 256],
                             range_y=[min_Diff, max_Diff], height=500, animation_frame='Week', log_y=True,
                             color="Color", color_discrete_map={"In > Out": "blue", "Out > In": "red"},
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Source IPs":
        min_SourceIPs = new_df_subs_in["SourceIPs"].min()
        max_SourceIPs = new_df_subs_in["SourceIPs"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="SourceIPs", range_x=[0, 256],
                             range_y=[min_SourceIPs, max_SourceIPs], height=500, animation_frame='Week',
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Target IPs":
        min_TargetIPs = new_df_subs_in["TargetIPs"].min()
        max_TargetIPs = new_df_subs_in["TargetIPs"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="TargetIPs", range_x=[0, 256],
                             range_y=[min_TargetIPs, max_TargetIPs], height=500, animation_frame='Week',
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Source Ports":
        min_SourcePorts = new_df_subs_in["SourcePorts"].min()
        max_SourcePorts = new_df_subs_in["SourcePorts"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="SourcePorts", range_x=[0, 256],
                             range_y=[min_SourcePorts, max_SourcePorts], height=500, animation_frame='Week',
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    elif type_graph_subs_in == "Target Ports":
        min_TargetPorts = new_df_subs_in["TargetPorts"].min()
        max_TargetPorts = new_df_subs_in["TargetPorts"].max()
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y="TargetPorts", range_x=[0, 256],
                             range_y=[min_TargetPorts, max_TargetPorts], height=500, animation_frame='Week',
                             hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    else:
        fig_subs_in = px.bar(data_frame=new_df_subs_in, x="Rank", y=type_graph_subs_out, height=500, range_x=[1, 257],
                             animation_frame='Week', hover_data=["Week", "TargetSubnet"], text="TargetSubnet")

    fig_subs_in.update_xaxes(range=[0, 256], autorange=False)
    fig_subs_in.layout.updatemenus[0].buttons[0].args[1]['frame']['duration'] = 800
    fig_subs_in.layout.updatemenus[0].buttons[0].args[1]['transition']['duration'] = 500
    fig_subs_in.update_traces(width=1, textangle=0, textposition='outside')
    # endregion

    # ==================================================================================================================

    # region Section_Groups_Total
    if type_graph_groups_total == "CPSC":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_cpsc_subnets.csv")

    elif type_graph_groups_total == "Schulich":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_schulich_subnets.csv")

    elif type_graph_groups_total == "Science":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_science_subnets.csv")

    elif type_graph_groups_total == "Medical":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_medical_subnets.csv")

    elif type_graph_groups_total == "PHAS":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_phas_subnets.csv")

    elif type_graph_groups_total == "Arts":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_arts_subnets.csv")

    elif type_graph_groups_total == "Kinesiology":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_kinesiology_subnets.csv")

    elif type_graph_groups_total == "Reznet":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_reznet_subnets.csv")

    elif type_graph_groups_total == "Admin":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_admin_subnets.csv")

    elif type_graph_groups_total == "Haskayne":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_haskayne_subnets.csv")

    elif type_graph_groups_total == "Services":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_services_subnets.csv")

    elif type_graph_groups_total == "VPN":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_vpn_subnets.csv")

    elif type_graph_groups_total == "WiFi":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wifi_subnets.csv")

    elif type_graph_groups_total == "WLAN":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wlan_subnets.csv")

    elif type_graph_groups_total == "Others":
        new_df_groups_total = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_others_subnets.csv")

    fig_groups_total_conns = px.bar(data_frame=new_df_groups_total, x="Week", y="Connections", height=600)

    fig_groups_total_bytes = px.bar(data_frame=new_df_groups_total, x="Week", y="TotalBytes", height=600)

    fig_groups_total_inout = go.Figure()
    fig_groups_total_inout.add_trace(go.Bar(x=new_df_groups_total["Week"], y=new_df_groups_total["Inbound"], name="Inbound", offsetgroup=0))
    fig_groups_total_inout.add_trace(go.Bar(x=new_df_groups_total["Week"], y=new_df_groups_total["Outbound"] * -1, name="Outbound", offsetgroup=0))
    fig_groups_total_inout.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_total_inout.update_xaxes(title="Week")
    fig_groups_total_inout.update_yaxes(title="Bytes")

    fig_groups_total_asym = go.Figure()
    fig_groups_total_asym.add_trace(go.Bar(x=new_df_groups_total["Week"], y=(new_df_groups_total["Inbound"] - new_df_groups_total["Outbound"]), name='In > Out', offsetgroup=0))
    fig_groups_total_asym.add_trace(go.Bar(x=new_df_groups_total["Week"], y=(new_df_groups_total["Outbound"] - new_df_groups_total["Inbound"]), name='Out > In', offsetgroup=0))
    fig_groups_total_asym.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_total_asym.update_xaxes(title="Week")
    fig_groups_total_asym.update_yaxes(title="Difference in Asymmetry", type="log")

    # endregion

    # ==================================================================================================================

    # region Section_Groups_Out
    if type_graph_groups_out == "CPSC":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_cpsc_out_subnets.csv")

    elif type_graph_groups_out == "Schulich":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_schulich_out_subnets.csv")

    elif type_graph_groups_out == "Science":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_science_out_subnets.csv")

    elif type_graph_groups_out == "Medical":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_medical_out_subnets.csv")

    elif type_graph_groups_out == "PHAS":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_phas_out_subnets.csv")

    elif type_graph_groups_out == "Arts":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_arts_out_subnets.csv")

    elif type_graph_groups_out == "Kinesiology":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_kinesiology_out_subnets.csv")

    elif type_graph_groups_out == "Reznet":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_reznet_out_subnets.csv")

    elif type_graph_groups_out == "Admin":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_admin_out_subnets.csv")

    elif type_graph_groups_out == "Haskayne":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_haskayne_out_subnets.csv")

    elif type_graph_groups_out == "Services":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_services_out_subnets.csv")

    elif type_graph_groups_out == "VPN":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_vpn_out_subnets.csv")

    elif type_graph_groups_out == "WiFi":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wifi_out_subnets.csv")

    elif type_graph_groups_out == "WLAN":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wlan_out_subnets.csv")

    elif type_graph_groups_out == "Others":
        new_df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_others_out_subnets.csv")

    fig_groups_out_conns = px.bar(data_frame=new_df_groups_out, x="Week", y="Connections", height=600)

    fig_groups_out_bytes = px.bar(data_frame=new_df_groups_out, x="Week", y="TotalBytes", height=600)

    fig_groups_out_inout = go.Figure()
    fig_groups_out_inout.add_trace(go.Bar(x=new_df_groups_out["Week"], y=new_df_groups_out["Inbound"], name="Inbound", offsetgroup=0))
    fig_groups_out_inout.add_trace(go.Bar(x=new_df_groups_out["Week"], y=new_df_groups_out["Outbound"] * -1, name="Outbound", offsetgroup=0))
    fig_groups_out_inout.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_out_inout.update_xaxes(title="Week")
    fig_groups_out_inout.update_yaxes(title="Bytes")

    fig_groups_out_asym = go.Figure()
    fig_groups_out_asym.add_trace(go.Bar(x=new_df_groups_out["Week"], y=(new_df_groups_out["Inbound"] - new_df_groups_out["Outbound"]), name='In > Out', offsetgroup=0))
    fig_groups_out_asym.add_trace(go.Bar(x=new_df_groups_out["Week"], y=(new_df_groups_out["Outbound"] - new_df_groups_out["Inbound"]), name='Out > In', offsetgroup=0))
    fig_groups_out_asym.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_out_asym.update_xaxes(title="Week")
    fig_groups_out_asym.update_yaxes(title="Difference in Asymmetry", type="log")

    # endregion

    # ==================================================================================================================

    # region Section_Groups_In
    if type_graph_groups_in == "CPSC":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_cpsc_in_subnets.csv")

    elif type_graph_groups_in == "Schulich":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_schulich_in_subnets.csv")

    elif type_graph_groups_in == "Science":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_science_in_subnets.csv")

    elif type_graph_groups_in == "Medical":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_medical_in_subnets.csv")

    elif type_graph_groups_in == "PHAS":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_phas_in_subnets.csv")

    elif type_graph_groups_in == "Arts":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_arts_in_subnets.csv")

    elif type_graph_groups_in == "Kinesiology":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_kinesiology_in_subnets.csv")

    elif type_graph_groups_in == "Reznet":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_reznet_in_subnets.csv")

    elif type_graph_groups_in == "Admin":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_admin_in_subnets.csv")

    elif type_graph_groups_in == "Haskayne":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_haskayne_in_subnets.csv")

    elif type_graph_groups_in == "Services":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_services_in_subnets.csv")

    elif type_graph_groups_in == "VPN":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_vpn_in_subnets.csv")

    elif type_graph_groups_in == "WiFi":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wifi_in_subnets.csv")

    elif type_graph_groups_in == "WLAN":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wlan_in_subnets.csv")

    elif type_graph_groups_in == "Others":
        new_df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_others_in_subnets.csv")

    fig_groups_in_conns = px.bar(data_frame=new_df_groups_in, x="Week", y="Connections", height=600)

    fig_groups_in_bytes = px.bar(data_frame=new_df_groups_in, x="Week", y="TotalBytes", height=600)

    fig_groups_in_inout = go.Figure()
    fig_groups_in_inout.add_trace(go.Bar(x=new_df_groups_in["Week"], y=new_df_groups_in["Inbound"], name="Inbound", offsetgroup=0))
    fig_groups_in_inout.add_trace(go.Bar(x=new_df_groups_in["Week"], y=new_df_groups_in["Outbound"] * -1, name="Outbound", offsetgroup=0))
    fig_groups_in_inout.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_in_inout.update_xaxes(title="Week")
    fig_groups_in_inout.update_yaxes(title="Bytes")

    fig_groups_in_asym = go.Figure()
    fig_groups_in_asym.add_trace(go.Bar(x=new_df_groups_in["Week"], y=(new_df_groups_in["Inbound"] - new_df_groups_in["Outbound"]), name='In > Out', offsetgroup=0))
    fig_groups_in_asym.add_trace(go.Bar(x=new_df_groups_in["Week"], y=(new_df_groups_in["Outbound"] - new_df_groups_in["Inbound"]), name='Out > In', offsetgroup=0))
    fig_groups_in_asym.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_in_asym.update_xaxes(title="Week")
    fig_groups_in_asym.update_yaxes(title="Difference in Asymmetry", type="log")

    # endregion

    return fig_subs_out, '## Source Subnets on Outgoing Connections - ' + type_graph_subs_out, \
        fig_subs_in, '## Target Subnets on Incoming Connections - ' + type_graph_subs_in, \
        fig_groups_total_conns, fig_groups_total_bytes, fig_groups_total_inout, fig_groups_total_asym, \
        '## All Connections to/from Subnet Group - ' + type_graph_groups_total,\
        fig_groups_out_conns, fig_groups_out_bytes, fig_groups_out_inout, fig_groups_out_asym, \
        '## Outgoing Connections from Subnet Group - ' + type_graph_groups_out, \
        fig_groups_in_conns, fig_groups_in_bytes, fig_groups_in_inout, fig_groups_in_asym, \
        '## Incoming Connections to Subnet Group - ' + type_graph_groups_in
    # returned objects are assigned to the component property of the Output


@app.callback(
    Output(depGraph_subs_out, component_property='figure'),
    Output(depTitle_subs_out, component_property='children'),
    Output(depGraph_subs_in, component_property='figure'),
    Output(depTitle_subs_in, component_property='children'),
    Input(graph_subs_out, component_property='clickData'),
    Input(dropdown_subs_out, component_property='value'),
    Input(graph_subs_in, component_property='clickData'),
    Input(dropdown_subs_in, component_property='value'),
)
def update_dependent_graph(click_data_subs_out, type_graph_dep_out, click_data_subs_in, type_graph_dep_in):

    # ==================================================================================================================

    # region Section_Dependent_Graph_Subs_Out
    selected_subnet_out = None
    thisWeek_out = 'Feb 2020'
    print('<click_data>: ', click_data_subs_out)
    if click_data_subs_out is not None:
        thisWeek_out = click_data_subs_out['points'][0]['customdata'][0]
        selected_subnet_out = click_data_subs_out['points'][0]['customdata'][1]

    print('<selected_subnet_out>: ', selected_subnet_out)
    print('<the selected week>: ', thisWeek_out)
    print('<graph_type>: ', str(type_graph_dep_out).replace(" ", ""))

    new_df_subs_out_dep = df_subs_out_dep.loc[(df_subs_out_dep["SourceSubnet"] == selected_subnet_out) &
                                              (df_subs_out_dep["Week"] == thisWeek_out)]

    print('<new_df_subs_out_dep dataframe>: ')
    print(new_df_subs_out_dep)

    if str(type_graph_dep_out).replace(" ", "") == 'SourceIPs':
        fig_dep_subs_out = px.bar(data_frame=new_df_subs_out_dep, x="SourceIP", y='TotalBytes', range_x=[0, 255],
                                  height=500, log_y=True)
        fig_dep_subs_out.update_traces(width=1, marker_color='green')
    elif str(type_graph_dep_out).replace(" ", "") == 'Difference':
        fig_dep_subs_out = px.bar(data_frame=new_df_subs_out_dep, x="SourceIP",
                                  y=str(type_graph_dep_out).replace(" ", ""), range_x=[0, 255], color='Color',
                                  color_discrete_map={"In > Out": "blue", "Out > In": "red"}, height=500, log_y=True)
        fig_dep_subs_out.update_traces(width=1)
    else:
        fig_dep_subs_out = px.bar(data_frame=new_df_subs_out_dep, x="SourceIP",
                                  y=str(type_graph_dep_out).replace(" ", ""), range_x=[0, 255], height=500, log_y=True)
        fig_dep_subs_out.update_traces(width=1, marker_color='green')

    # endregion

    # ==================================================================================================================

    # region Section_Dependent_Graph_Subs_Out
    selected_subnet_in = None
    thisWeek_in = 'Feb 2020'
    print('<click_data>: ', click_data_subs_in)
    if click_data_subs_in is not None:
        thisWeek_in = click_data_subs_in['points'][0]['customdata'][0]
        selected_subnet_in = click_data_subs_in['points'][0]['customdata'][1]

    print('<selected_subnet_out>: ', selected_subnet_in)
    print('<the selected week>: ', thisWeek_in)
    print('<graph_type>: ', str(type_graph_dep_in).replace(" ", ""))

    new_df_subs_in_dep = df_subs_in_dep.loc[(df_subs_in_dep["TargetSubnet"] == selected_subnet_in) &
                                              (df_subs_in_dep["Week"] == thisWeek_in)]

    print('<new_df_subs_in_dep dataframe>: ')
    print(new_df_subs_in_dep)

    if str(type_graph_dep_in).replace(" ", "") == 'TargetIP':
        fig_dep_subs_in = px.bar(data_frame=new_df_subs_in_dep, x="TargetIP", y='TotalBytes', range_x=[0, 255],
                                 height=500, log_y=True)
        fig_dep_subs_in.update_traces(width=1, marker_color='green')
    elif str(type_graph_dep_in).replace(" ", "") == 'Difference':
        fig_dep_subs_in = px.bar(data_frame=new_df_subs_in_dep, x="TargetIP",
                                 y=str(type_graph_dep_in).replace(" ", ""), range_x=[0, 255], color='Color',
                                 color_discrete_map={"In > Out": "blue", "Out > In": "red"}, height=500, log_y=True)
        fig_dep_subs_in.update_traces(width=1)
    else:
        fig_dep_subs_in = px.bar(data_frame=new_df_subs_in_dep, x="TargetIP",
                                 y=str(type_graph_dep_in).replace(" ", ""), range_x=[0, 255], height=500, log_y=True)
        fig_dep_subs_in.update_traces(width=1, marker_color='green')

    # endregion

    return fig_dep_subs_out, '### Distribution of the Selected Subnet in Outgoing Connections for ' + thisWeek_out + \
        ' - ' + str(selected_subnet_out), fig_dep_subs_in, \
        '### Distribution of the Selected Subnet in Incoming Connections for ' + thisWeek_in + ' - ' + \
        str(selected_subnet_in)


# Run app
if __name__ == '__main__':
    app.run_server(debug=True, port=8054)

