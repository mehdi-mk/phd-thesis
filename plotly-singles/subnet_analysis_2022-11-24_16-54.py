# If you prefer to run the code online instead of on your computer click:
# https://github.com/Coding-with-Adam/Dash-by-Plotly#execute-code-in-browser
import math

from dash import Dash, dcc, Output, Input  # pip install dash
import dash_bootstrap_components as dbc  # pip install dash-bootstrap-components
import plotly.graph_objects as go
import plotly.express as px
import pandas as pd  # pip install pandas
import dash_daq as daq

# region Section_Dataframes
# Source - https://www.cdc.gov/nchs/pressroom/stats_of_the_states.htm
df_subs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/subnets_outgoing_sources_goodconns.csv")
df_subs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/subnets_incoming_targets_goodconns.csv")
df_subs_out_dep = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/sourceIPs.csv")
df_subs_in_dep = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/targetIPs.csv")
# endregion

# region Section_Components
app = Dash(__name__, external_stylesheets=[dbc.themes.CERULEAN])

# Graphs for outgoing connections
title_subs_out = dcc.Markdown(children='## Source Subnets on Outgoing Connections - ')
graph_subs_out = dcc.Graph(figure={})
dropdown_subs_out = dcc.Dropdown(
    options=['Total Bytes', 'Inbound', 'Outbound', 'Difference', 'Connections', 'Source IPs',
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

# Graphs for groups - outgoing connections
title_groups_out = dcc.Markdown(children='## Outgoing Connections from Subnet Groups - ')
graph_groups_out_conns = dcc.Graph(figure={})
graph_groups_out_bytes = dcc.Graph(figure={})
graph_groups_out_inout = dcc.Graph(figure={})
graph_groups_out_asym = dcc.Graph(figure={})
dropdown_groups_out = dcc.Dropdown(
    options=['WiFi', 'WLAN', 'Services', 'VPN', 'Science', 'Schulich', 'Medical', 'Arts', 'CPSC', 'PHAS', 'Reznet',
             'Admin'],
    value='WiFi',  # initial value displayed when page first loads
    clearable=False)

# Graphs for groups - incoming connections
title_groups_in = dcc.Markdown(children='## Incoming Connections to Subnet Groups - ')
graph_groups_in_conns = dcc.Graph(figure={})
graph_groups_in_bytes = dcc.Graph(figure={})
graph_groups_in_inout = dcc.Graph(figure={})
graph_groups_in_asym = dcc.Graph(figure={})
dropdown_groups_in = dcc.Dropdown(
    options=['WiFi', 'WLAN', 'Services', 'VPN', 'Science', 'Schulich', 'Medical', 'Arts', 'CPSC', 'PHAS', 'Reznet',
             'Admin'],
    value='WiFi',  # initial value displayed when page first loads
    clearable=False)

# Graphs for orgs - outgoing connections
title_orgs_out = dcc.Markdown(children='## External Targets of the Outgoing Connections from Groups - ')
graph_orgs_out_conns = dcc.Graph(figure={})
graph_orgs_out_bytes = dcc.Graph(figure={})
graph_orgs_out_src_ips = dcc.Graph(figure={})
graph_orgs_out_trg_ips = dcc.Graph(figure={})
graph_orgs_out_src_ports = dcc.Graph(figure={})
graph_orgs_out_trg_ports = dcc.Graph(figure={})
dropdown_orgs_out = dcc.Dropdown(
    options=['WiFi', 'WLAN', 'Services', 'VPN', 'Science', 'Schulich', 'Medical', 'Arts', 'CPSC', 'PHAS', 'Reznet',
             'Admin'],
    value='WiFi',  # initial value displayed when page first loads
    clearable=False)

# Graphs for orgs - incoming connections
title_orgs_in = dcc.Markdown(children='## External Sources of the Incoming Connections to Groups - ')
graph_orgs_in_conns = dcc.Graph(figure={})
graph_orgs_in_bytes = dcc.Graph(figure={})
graph_orgs_in_src_ips = dcc.Graph(figure={})
graph_orgs_in_trg_ips = dcc.Graph(figure={})
graph_orgs_in_src_ports = dcc.Graph(figure={})
graph_orgs_in_trg_ports = dcc.Graph(figure={})
dropdown_orgs_in = dcc.Dropdown(
    options=['WiFi', 'WLAN', 'Services', 'VPN', 'Science', 'Schulich', 'Medical', 'Arts', 'CPSC', 'PHAS', 'Reznet',
             'Admin'],
    value='Services',  # initial value displayed when page first loads
    clearable=False)
# endregion

# region Section_Layout
app.layout = dbc.Container([
    # Section layout for incoming connections
    dbc.Row([
        dbc.Col([title_subs_out], width=6)
    ], justify='center'),
    dbc.Row([
        dbc.Col([dropdown_subs_out], width=3), dbc.Col([choice_subs_out], width=1)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_subs_out], width=12)
    ]),

    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),
    dbc.Row([dbc.Col([depTitle_subs_out], width=7)], justify='center'),
    dbc.Row([dbc.Col([depGraph_subs_out], width=12)]),

    # Section layout for incoming connections
    dbc.Row([
        dbc.Col([title_subs_in], width=6)
    ], justify='center'),
    dbc.Row([
        dbc.Col([dropdown_subs_in], width=3), dbc.Col([choice_subs_in], width=1)
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_subs_in], width=12)
    ]),

    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),
    dbc.Row([dbc.Col([depTitle_subs_in], width=7)], justify='center'),
    dbc.Row([dbc.Col([depGraph_subs_in], width=12)]),

    # Divider
    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),

    # Section layout for groups - outgoing connections
    dbc.Row([
        dbc.Col([title_groups_out], width=5)
    ], justify='center'),
    dbc.Row([
        dbc.Col([dropdown_groups_out], width=3),
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_groups_out_conns], width=3),
        dbc.Col([graph_groups_out_bytes], width=3),
        dbc.Col([graph_groups_out_inout], width=3),
        dbc.Col([graph_groups_out_asym], width=3),
    ]),

    # Divider
    dbc.Row([dbc.Col([dcc.Markdown('## __')])]),

    # Section layout for groups - incoming connections
    dbc.Row([
        dbc.Col([title_groups_in], width=7)
    ], justify='center'),
    dbc.Row([
        dbc.Col([dropdown_groups_in], width=3),
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_groups_in_conns], width=3),
        dbc.Col([graph_groups_in_bytes], width=3),
        dbc.Col([graph_groups_in_inout], width=3),
        dbc.Col([graph_groups_in_asym], width=3),
    ]),

    # Section layout for orgs - outgoing connections
    dbc.Row([
        dbc.Col([title_orgs_out], width=7)
    ], justify='center'),
    dbc.Row([
        dbc.Col([dropdown_orgs_out], width=3),
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_orgs_out_conns], width=5),
        dbc.Col([graph_orgs_out_bytes], width=6),
    ]),
    dbc.Row([
        dbc.Col([graph_orgs_out_src_ips], width=5),
        dbc.Col([graph_orgs_out_trg_ips], width=6),
    ]),
    dbc.Row([
        dbc.Col([graph_orgs_out_src_ports], width=5),
        dbc.Col([graph_orgs_out_trg_ports], width=6),
    ]),

    # Section layout for orgs - incoming connections
    dbc.Row([
        dbc.Col([title_orgs_in], width=6)
    ], justify='center'),
    dbc.Row([
        dbc.Col([dropdown_orgs_in], width=3),
    ], justify='center'),
    dbc.Row([
        dbc.Col([graph_orgs_in_conns], width=5),
        dbc.Col([graph_orgs_in_bytes], width=6),
    ]),
    dbc.Row([
        dbc.Col([graph_orgs_in_src_ips], width=5),
        dbc.Col([graph_orgs_in_trg_ips], width=6),
    ]),
    dbc.Row([
        dbc.Col([graph_orgs_in_src_ports], width=5),
        dbc.Col([graph_orgs_in_trg_ports], width=6),
    ]),

], fluid=True)


# endregion

# region Section_Callbacks_1
@app.callback(
    Output(graph_subs_out, 'figure'),
    Output(title_subs_out, 'children'),
    Output(graph_subs_in, 'figure'),
    Output(title_subs_in, 'children'),
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
    Output(graph_orgs_out_conns, 'figure'),
    Output(graph_orgs_out_bytes, 'figure'),
    Output(graph_orgs_out_src_ips, 'figure'),
    Output(graph_orgs_out_trg_ips, 'figure'),
    Output(graph_orgs_out_src_ports, 'figure'),
    Output(graph_orgs_out_trg_ports, 'figure'),
    Output(title_orgs_out, 'children'),
    Output(graph_orgs_in_conns, 'figure'),
    Output(graph_orgs_in_bytes, 'figure'),
    Output(graph_orgs_in_src_ips, 'figure'),
    Output(graph_orgs_in_trg_ips, 'figure'),
    Output(graph_orgs_in_src_ports, 'figure'),
    Output(graph_orgs_in_trg_ports, 'figure'),
    Output(title_orgs_in, 'children'),
    Input(dropdown_subs_out, 'value'),
    Input(choice_subs_out, 'value'),
    Input(dropdown_subs_in, 'value'),
    Input(choice_subs_in, 'value'),
    Input(dropdown_groups_out, 'value'),
    Input(dropdown_groups_in, 'value'),
    Input(dropdown_orgs_out, 'value'),
    Input(dropdown_orgs_in, 'value'),
)
# endregion
# function arguments come from the component property of the Input
def update_graph(type_graph_subs_out, top_picks_subs_out, type_graph_subs_in, top_picks_subs_in,
                 type_graph_groups_out, type_graph_groups_in, type_graph_orgs_out, type_graph_orgs_in):

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

    # region Section_Groups_Out
    if type_graph_groups_out == "WiFi":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wifi_out_subnets.csv")

    elif type_graph_groups_out == "WLAN":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wlan_out_subnets.csv")

    elif type_graph_groups_out == "Services":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_services_out_subnets.csv")

    elif type_graph_groups_out == "VPN":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_vpn_out_subnets.csv")

    elif type_graph_groups_out == "Science":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_science_out_subnets.csv")

    elif type_graph_groups_out == "Schulich":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_schulich_out_subnets.csv")

    elif type_graph_groups_out == "Medical":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_medical_out_subnets.csv")

    elif type_graph_groups_out == "Arts":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_arts_out_subnets.csv")

    elif type_graph_groups_out == "CPSC":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_cpsc_out_subnets.csv")

    elif type_graph_groups_out == "PHAS":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_phas_out_subnets.csv")

    elif type_graph_groups_out == "Reznet":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_reznet_out_subnets.csv")

    elif type_graph_groups_out == "Admin":
        df_groups_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_admin_out_subnets.csv")

    fig_groups_out_conns = px.bar(data_frame=df_groups_out, x="Week", y="Connections", height=600)

    fig_groups_out_bytes = px.bar(data_frame=df_groups_out, x="Week", y="TotalBytes", height=600)

    fig_groups_out_inout = go.Figure()
    fig_groups_out_inout.add_trace(
        go.Bar(x=df_groups_out["Week"], y=df_groups_out["Inbound"], name="Inbound", offsetgroup=0))
    fig_groups_out_inout.add_trace(
        go.Bar(x=df_groups_out["Week"], y=df_groups_out["Outbound"] * -1, name="Outbound", offsetgroup=0))
    fig_groups_out_inout.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_out_inout.update_xaxes(title="Week")
    fig_groups_out_inout.update_yaxes(title="Bytes")

    fig_groups_out_asym = go.Figure()
    fig_groups_out_asym.add_trace(
        go.Bar(x=df_groups_out["Week"], y=(df_groups_out["Inbound"] - df_groups_out["Outbound"]), name='In > Out',
               offsetgroup=0))
    fig_groups_out_asym.add_trace(
        go.Bar(x=df_groups_out["Week"], y=(df_groups_out["Outbound"] - df_groups_out["Inbound"]), name='Out > In',
               offsetgroup=0))
    fig_groups_out_asym.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_out_asym.update_xaxes(title="Week")
    fig_groups_out_asym.update_yaxes(title="Difference in Asymmetry", type="log")

    # endregion

    # ==================================================================================================================

    # region Section_Groups_In
    if type_graph_groups_in == "WiFi":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wifi_in_subnets.csv")

    elif type_graph_groups_in == "WLAN":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_wlan_in_subnets.csv")

    elif type_graph_groups_in == "Services":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_services_in_subnets.csv")

    elif type_graph_groups_in == "VPN":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_vpn_in_subnets.csv")

    elif type_graph_groups_in == "Science":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_science_in_subnets.csv")

    elif type_graph_groups_in == "Schulich":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_schulich_in_subnets.csv")

    elif type_graph_groups_in == "Medical":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_medical_in_subnets.csv")

    elif type_graph_groups_in == "Arts":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_arts_in_subnets.csv")

    elif type_graph_groups_in == "CPSC":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_cpsc_in_subnets.csv")

    elif type_graph_groups_in == "PHAS":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_phas_in_subnets.csv")

    elif type_graph_groups_in == "Reznet":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_reznet_in_subnets.csv")

    elif type_graph_groups_in == "Admin":
        df_groups_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_admin_in_subnets.csv")

    fig_groups_in_conns = px.bar(data_frame=df_groups_in, x="Week", y="Connections", height=600)

    fig_groups_in_bytes = px.bar(data_frame=df_groups_in, x="Week", y="TotalBytes", height=600)

    fig_groups_in_inout = go.Figure()
    fig_groups_in_inout.add_trace(
        go.Bar(x=df_groups_in["Week"], y=df_groups_in["Inbound"], name="Inbound", offsetgroup=0))
    fig_groups_in_inout.add_trace(
        go.Bar(x=df_groups_in["Week"], y=df_groups_in["Outbound"] * -1, name="Outbound", offsetgroup=0))
    fig_groups_in_inout.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_in_inout.update_xaxes(title="Week")
    fig_groups_in_inout.update_yaxes(title="Bytes")

    fig_groups_in_asym = go.Figure()
    fig_groups_in_asym.add_trace(
        go.Bar(x=df_groups_in["Week"], y=(df_groups_in["Inbound"] - df_groups_in["Outbound"]), name='In > Out',
               offsetgroup=0))
    fig_groups_in_asym.add_trace(
        go.Bar(x=df_groups_in["Week"], y=(df_groups_in["Outbound"] - df_groups_in["Inbound"]), name='Out > In',
               offsetgroup=0))
    fig_groups_in_asym.update_layout(height=600, margin=dict(l=0, r=0, t=60, b=80, pad=0))
    fig_groups_in_asym.update_xaxes(title="Week")
    fig_groups_in_asym.update_yaxes(title="Difference in Asymmetry", type="log")

    # endregion

    # ==================================================================================================================

    # region Section_Orgs_Out
    if type_graph_orgs_out == "WiFi":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_WiFi_out_targets.csv")

    elif type_graph_orgs_out == "WLAN":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_WLAN_out_targets.csv")

    elif type_graph_orgs_out == "Services":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Services_out_targets.csv")

    elif type_graph_orgs_out == "VPN":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_VPN_out_targets.csv")

    elif type_graph_orgs_out == "Science":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Science_out_targets.csv")

    elif type_graph_orgs_out == "Schulich":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Schulich_out_targets.csv")

    elif type_graph_orgs_out == "Medical":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Medical_out_targets.csv")

    elif type_graph_orgs_out == "Arts":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Arts_out_targets.csv")

    elif type_graph_orgs_out == "CPSC":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_CPSC_out_targets.csv")

    elif type_graph_orgs_out == "PHAS":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_PHAS_out_targets.csv")

    elif type_graph_orgs_out == "Reznet":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Reznet_out_targets.csv")

    elif type_graph_orgs_out == "Admin":
        df_orgs_out = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Admin_out_targets.csv")

    fig_orgs_out_conns = px.line(df_orgs_out, x='Week', y='Connections', log_y=True, color='TargetOrgs',
                                 color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                     'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                     'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                     'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                     'VALVE-CORPORATION': '#bcbd22'},
                                 markers=True, line_dash='TargetOrgs', symbol='TargetOrgs', height=600)
    fig_orgs_out_conns.update_layout(plot_bgcolor='white', showlegend=False)
    fig_orgs_out_conns.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_conns.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_conns.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_out_bytes = px.line(df_orgs_out, x='Week', y='TotalBytes', log_y=True, color='TargetOrgs',
                                 color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                     'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                     'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                     'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                     'VALVE-CORPORATION': '#bcbd22'},
                                 markers=True, line_dash='TargetOrgs', symbol='TargetOrgs', height=600)
    fig_orgs_out_bytes.update_layout(plot_bgcolor='white')
    fig_orgs_out_bytes.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_bytes.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_bytes.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_out_src_ips = px.line(df_orgs_out, x='Week', y='SourceIPs', color='TargetOrgs',
                                 color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                     'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                     'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                     'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                     'VALVE-CORPORATION': '#bcbd22'},
                                 markers=True, line_dash='TargetOrgs', symbol='TargetOrgs', height=600)
    fig_orgs_out_src_ips.update_layout(plot_bgcolor='white', showlegend=False)
    fig_orgs_out_src_ips.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_src_ips.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_src_ips.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_out_trg_ips = px.line(df_orgs_out, x='Week', y='TargetIPs', color='TargetOrgs',
                                   color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                       'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                       'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                       'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                       'VALVE-CORPORATION': '#bcbd22'},
                                   markers=True, line_dash='TargetOrgs', symbol='TargetOrgs', height=600)
    fig_orgs_out_trg_ips.update_layout(plot_bgcolor='white')
    fig_orgs_out_trg_ips.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_trg_ips.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_trg_ips.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_out_src_ports = px.line(df_orgs_out, x='Week', y='SourcePorts', color='TargetOrgs',
                                   color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                       'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                       'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                       'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                       'VALVE-CORPORATION': '#bcbd22'},
                                   markers=True, line_dash='TargetOrgs', symbol='TargetOrgs', height=600)
    fig_orgs_out_src_ports.update_layout(plot_bgcolor='white', showlegend=False)
    fig_orgs_out_src_ports.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_src_ports.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_src_ports.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_out_trg_ports = px.line(df_orgs_out, x='Week', y='TargetPorts', color='TargetOrgs',
                                   color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                       'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                       'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                       'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                       'VALVE-CORPORATION': '#bcbd22'},
                                   markers=True, line_dash='TargetOrgs', symbol='TargetOrgs', height=600)
    fig_orgs_out_trg_ports.update_layout(plot_bgcolor='white')
    fig_orgs_out_trg_ports.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_trg_ports.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_out_trg_ports.update_traces(line=dict(width=4), marker_size=12)

    # endregion

    # ==================================================================================================================

    # region Section_Orgs_In
    if type_graph_orgs_in == "WiFi":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_WiFi_in_sources.csv")

    elif type_graph_orgs_in == "WLAN":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_WLAN_in_sources.csv")

    elif type_graph_orgs_in == "Services":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Services_in_sources.csv")

    elif type_graph_orgs_in == "VPN":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_VPN_in_sources.csv")

    elif type_graph_orgs_in == "Science":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Science_in_sources.csv")

    elif type_graph_orgs_in == "Schulich":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Schulich_in_sources.csv")

    elif type_graph_orgs_in == "Medical":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Medical_in_sources.csv")

    elif type_graph_orgs_in == "Arts":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Arts_in_sources.csv")

    elif type_graph_orgs_in == "CPSC":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_CPSC_in_sources.csv")

    elif type_graph_orgs_in == "PHAS":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_PHAS_in_sources.csv")

    elif type_graph_orgs_in == "Reznet":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Reznet_in_sources.csv")

    elif type_graph_orgs_in == "Admin":
        df_orgs_in = pd.read_csv("/Volumes/GoogleDrive/My Drive/Thesis/Plotly/category_Admin_in_sources.csv")

    fig_orgs_in_conns = px.line(df_orgs_in, x='Week', y='Connections', log_y=True, color='SourceOrgs',
                                color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                    'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                    'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                    'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                    'VALVE-CORPORATION': '#bcbd22', 'TELUS': '#db1f48',
                                                    'SHAW': '#613659', 'BACOM': '#01949a', 'ROGERS': '#81b622',
                                                    'Chinanet': '#d3b1c2', 'AHS': '#eeb5eb', 'YANDEXLLC': '#fad02c',
                                                    'NLM-GW': '#055c9d', 'JiscServicesLimited': '#870a30',
                                                    'BROADINSTITUTE-AS': '#e57f84', 'OoredooQ.S.C.': '#90adc6',
                                                    'RelianceJioInfocommLimited': '#a16ae8', 'O-NET': '#ffa384',
                                                    'Vetenskapsradet/SUNET': '#74bdcb', 'VELOCITYNET-01': '#3d5b59',
                                                    'CHINAUNICOMChina169Backbone': '#ff4500', 'CIPHERKEY': '#b7ac44',
                                                    'TEKSAVVY': '#52688f', 'BARR-XPLR-ASN': '#d4f1f4',
                                                    'PRIMUS-AS6407': '#b9b7bd', 'CIKTELECOM-CABLE': '#fb4570',
                                                    'TWC-11426-CAROLINAS': '#7cf3a0', 'PEGTECHINC': '#f9eac2',
                                                    'UniversityofQueensland': '#bfd7ed'},
                                markers=True, line_dash='SourceOrgs', symbol='SourceOrgs', height=600)
    fig_orgs_in_conns.update_layout(plot_bgcolor='white', showlegend=False)
    fig_orgs_in_conns.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_conns.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_conns.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_in_bytes = px.line(df_orgs_in, x='Week', y='TotalBytes', log_y=True, color='SourceOrgs',
                                color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                    'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                    'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                    'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                    'VALVE-CORPORATION': '#bcbd22', 'TELUS': '#db1f48',
                                                    'SHAW': '#613659', 'BACOM': '#01949a', 'ROGERS': '#81b622',
                                                    'Chinanet': '#d3b1c2', 'AHS': '#eeb5eb', 'YANDEXLLC': '#fad02c',
                                                    'NLM-GW': '#055c9d', 'JiscServicesLimited': '#870a30',
                                                    'BROADINSTITUTE-AS': '#e57f84', 'OoredooQ.S.C.': '#90adc6',
                                                    'RelianceJioInfocommLimited': '#a16ae8', 'O-NET': '#ffa384',
                                                    'Vetenskapsradet/SUNET': '#74bdcb', 'VELOCITYNET-01': '#3d5b59',
                                                    'CHINAUNICOMChina169Backbone': '#ff4500', 'CIPHERKEY': '#b7ac44',
                                                    'TEKSAVVY': '#52688f', 'BARR-XPLR-ASN': '#d4f1f4',
                                                    'PRIMUS-AS6407': '#b9b7bd', 'CIKTELECOM-CABLE': '#fb4570',
                                                    'TWC-11426-CAROLINAS': '#7cf3a0', 'PEGTECHINC': '#f9eac2',
                                                    'UniversityofQueensland': '#bfd7ed'},
                                markers=True, line_dash='SourceOrgs', symbol='SourceOrgs', height=600)
    fig_orgs_in_bytes.update_layout(plot_bgcolor='white'),
    fig_orgs_in_bytes.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_bytes.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_bytes.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_in_src_ips = px.line(df_orgs_in, x='Week', y='SourceIPs', color='SourceOrgs',
                                color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                    'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                    'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                    'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                    'VALVE-CORPORATION': '#bcbd22', 'TELUS': '#db1f48',
                                                    'SHAW': '#613659', 'BACOM': '#01949a', 'ROGERS': '#81b622',
                                                    'Chinanet': '#d3b1c2', 'AHS': '#eeb5eb', 'YANDEXLLC': '#fad02c',
                                                    'NLM-GW': '#055c9d', 'JiscServicesLimited': '#870a30',
                                                    'BROADINSTITUTE-AS': '#e57f84', 'OoredooQ.S.C.': '#90adc6',
                                                    'RelianceJioInfocommLimited': '#a16ae8', 'O-NET': '#ffa384',
                                                    'Vetenskapsradet/SUNET': '#74bdcb', 'VELOCITYNET-01': '#3d5b59',
                                                    'CHINAUNICOMChina169Backbone': '#ff4500', 'CIPHERKEY': '#b7ac44',
                                                    'TEKSAVVY': '#52688f', 'BARR-XPLR-ASN': '#d4f1f4',
                                                    'PRIMUS-AS6407': '#b9b7bd', 'CIKTELECOM-CABLE': '#fb4570',
                                                    'TWC-11426-CAROLINAS': '#7cf3a0', 'PEGTECHINC': '#f9eac2',
                                                    'UniversityofQueensland': '#bfd7ed'},
                                markers=True, line_dash='SourceOrgs', symbol='SourceOrgs', height=600)
    fig_orgs_in_src_ips.update_layout(plot_bgcolor='white', showlegend=False)
    fig_orgs_in_src_ips.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_src_ips.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_src_ips.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_in_trg_ips = px.line(df_orgs_in, x='Week', y='TargetIPs', color='SourceOrgs',
                                color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                    'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                    'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                    'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                    'VALVE-CORPORATION': '#bcbd22', 'TELUS': '#db1f48',
                                                    'SHAW': '#613659', 'BACOM': '#01949a', 'ROGERS': '#81b622',
                                                    'Chinanet': '#d3b1c2', 'AHS': '#eeb5eb', 'YANDEXLLC': '#fad02c',
                                                    'NLM-GW': '#055c9d', 'JiscServicesLimited': '#870a30',
                                                    'BROADINSTITUTE-AS': '#e57f84', 'OoredooQ.S.C.': '#90adc6',
                                                    'RelianceJioInfocommLimited': '#a16ae8', 'O-NET': '#ffa384',
                                                    'Vetenskapsradet/SUNET': '#74bdcb', 'VELOCITYNET-01': '#3d5b59',
                                                    'CHINAUNICOMChina169Backbone': '#ff4500', 'CIPHERKEY': '#b7ac44',
                                                    'TEKSAVVY': '#52688f', 'BARR-XPLR-ASN': '#d4f1f4',
                                                    'PRIMUS-AS6407': '#b9b7bd', 'CIKTELECOM-CABLE': '#fb4570',
                                                    'TWC-11426-CAROLINAS': '#7cf3a0', 'PEGTECHINC': '#f9eac2',
                                                    'UniversityofQueensland': '#bfd7ed'},
                                markers=True, line_dash='SourceOrgs', symbol='SourceOrgs', height=600)
    fig_orgs_in_trg_ips.update_layout(plot_bgcolor='white'),
    fig_orgs_in_trg_ips.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_trg_ips.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_trg_ips.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_in_src_ports = px.line(df_orgs_in, x='Week', y='SourcePorts', color='SourceOrgs',
                                  color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                      'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                      'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                      'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                      'VALVE-CORPORATION': '#bcbd22', 'TELUS': '#db1f48',
                                                      'SHAW': '#613659', 'BACOM': '#01949a', 'ROGERS': '#81b622',
                                                      'Chinanet': '#d3b1c2', 'AHS': '#eeb5eb', 'YANDEXLLC': '#fad02c',
                                                      'NLM-GW': '#055c9d', 'JiscServicesLimited': '#870a30',
                                                      'BROADINSTITUTE-AS': '#e57f84', 'OoredooQ.S.C.': '#90adc6',
                                                      'RelianceJioInfocommLimited': '#a16ae8', 'O-NET': '#ffa384',
                                                      'Vetenskapsradet/SUNET': '#74bdcb', 'VELOCITYNET-01': '#3d5b59',
                                                      'CHINAUNICOMChina169Backbone': '#ff4500', 'CIPHERKEY': '#b7ac44',
                                                      'TEKSAVVY': '#52688f', 'BARR-XPLR-ASN': '#d4f1f4',
                                                      'PRIMUS-AS6407': '#b9b7bd', 'CIKTELECOM-CABLE': '#fb4570',
                                                      'TWC-11426-CAROLINAS': '#7cf3a0', 'PEGTECHINC': '#f9eac2',
                                                      'UniversityofQueensland': '#bfd7ed'},
                                  markers=True, line_dash='SourceOrgs', symbol='SourceOrgs', height=600)
    fig_orgs_in_src_ports.update_layout(plot_bgcolor='white', showlegend=False)
    fig_orgs_in_src_ports.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_src_ports.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_src_ports.update_traces(line=dict(width=4), marker_size=12)

    fig_orgs_in_trg_ports = px.line(df_orgs_in, x='Week', y='TargetPorts', color='SourceOrgs',
                                  color_discrete_map={'APPLE': '#7f7f7f', 'NETFLIX': '#dc3912', 'AKAMAI': '#ff9900',
                                                      'CANARIE': '#fb00d1', 'FACEBOOK': '#3366cc', 'GOOGLE': '#109618',
                                                      'AMAZON': '#212E3C', 'FASTLY': '#8c564b', 'LEVEL3': '#17becf',
                                                      'MICROSOFT': '#990099', 'EDGECAST': '#316395',
                                                      'VALVE-CORPORATION': '#bcbd22', 'TELUS': '#db1f48',
                                                      'SHAW': '#613659', 'BACOM': '#01949a', 'ROGERS': '#81b622',
                                                      'Chinanet': '#d3b1c2', 'AHS': '#eeb5eb', 'YANDEXLLC': '#fad02c',
                                                      'NLM-GW': '#055c9d', 'JiscServicesLimited': '#870a30',
                                                      'BROADINSTITUTE-AS': '#e57f84', 'OoredooQ.S.C.': '#90adc6',
                                                      'RelianceJioInfocommLimited': '#a16ae8', 'O-NET': '#ffa384',
                                                      'Vetenskapsradet/SUNET': '#74bdcb', 'VELOCITYNET-01': '#3d5b59',
                                                      'CHINAUNICOMChina169Backbone': '#ff4500', 'CIPHERKEY': '#b7ac44',
                                                      'TEKSAVVY': '#52688f', 'BARR-XPLR-ASN': '#d4f1f4',
                                                      'PRIMUS-AS6407': '#b9b7bd', 'CIKTELECOM-CABLE': '#fb4570',
                                                      'TWC-11426-CAROLINAS': '#7cf3a0', 'PEGTECHINC': '#f9eac2',
                                                      'UniversityofQueensland': '#bfd7ed'},
                                  markers=True, line_dash='SourceOrgs', symbol='SourceOrgs', height=600)
    fig_orgs_in_trg_ports.update_layout(plot_bgcolor='white'),
    fig_orgs_in_trg_ports.update_xaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_trg_ports.update_yaxes(showgrid=True, gridwidth=1, gridcolor='LightGray')
    fig_orgs_in_trg_ports.update_traces(line=dict(width=4), marker_size=12)

    # endregion

    # ==================================================================================================================

    return fig_subs_out, '## Source Subnets on Outgoing Connections - ' + type_graph_subs_out, \
           fig_subs_in, '## Target Subnets on Incoming Connections - ' + type_graph_subs_in, \
           fig_groups_out_conns, fig_groups_out_bytes, fig_groups_out_inout, fig_groups_out_asym, \
           '## Outgoing Connections from Subnet Group - ' + type_graph_groups_out, \
           fig_groups_in_conns, fig_groups_in_bytes, fig_groups_in_inout, fig_groups_in_asym, \
           '## Incoming Connections to Subnet Group - ' + type_graph_groups_in, \
           fig_orgs_out_conns, fig_orgs_out_bytes, \
           fig_orgs_out_src_ips, fig_orgs_out_trg_ips, fig_orgs_out_src_ports, fig_orgs_out_trg_ports, \
           '## External Targets of the Outgoing Connections from Groups - ' + type_graph_orgs_out, \
           fig_orgs_in_conns, fig_orgs_in_bytes, \
           fig_orgs_in_src_ips, fig_orgs_in_trg_ips, fig_orgs_in_src_ports, fig_orgs_in_trg_ports, \
           '## External Sources of the Incoming Connections to Groups - ' + type_graph_orgs_in
    # returned objects are assigned to the component property of the Output


# region Section_Callbacks_2
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
# endregion
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

    # region Section_Dependent_Graph_Subs_In
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

