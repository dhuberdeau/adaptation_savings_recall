% Day1 vs. Day2
nm0_day1_trs = 1:59; nm0_day2_rot_trs = 60:(60+64);
nm2_day1_trs = 1:61; nm2_day2_rot_trs = 62:(62+64);
nm5_day1_trs = 1:64; nm5_day2_rot_trs = 65:(65+64);
nm10_day1_trs = 1:69; nm10_day2_rot_trs = 70:(70+64);
nm39_day1_trs = 1:98; nm39_day2_rot_trs = 99:(99+64);
nm_15deg_day1_trs = 1:98; nm_15deg_day2_rot_trs = 99:(99 + 64);
nm_cntrot_day1_trs = 1:64; nm_cntrot_day2_rot_trs = 65:(65+64);
nm_5min_day1_trs = 1:64; nm_5min_day2_rot_trs = 65:(65+64); % changed all these from 69 to reflect that some ppl got a little break befor the last 5 trials

% statistical regions of interest:
nm0_day1_learn = [];
nm2_day1_learn = 61:61;
nm5_day1_learn = 61:64;
nm10_day1_learn = 61:65;
nm39_day1_learn = 61:65;
nm_15deg_day1_learn = 61:65;
nm_cntrot_day1_learn = 61:64;
nm_5min_day1_learn = 61:64;

% for LEARNING INDEX using trials 2 - 6
nm0_day2_learn = 61:65;
nm2_day2_learn = 63:67;
nm5_day2_learn = 66:70;
nm10_day2_learn = 71:75;
nm39_day2_learn = 100:104;
nm_15deg_day2_learn = 100:104;
nm_cntrot_day2_learn = 66:70;
nm_5min_day2_learn = 66:70;

% for LEARNING INDEX using trials 1 - 6
% nm0_day2_learn = 60:65;
% nm2_day2_learn = 62:67;
% nm5_day2_learn = 65:70;
% nm10_day2_learn = 70:75;
% nm39_day2_learn = 99:104;
% nm_15deg_day2_learn = 99:104;
% nm_cntrot_day2_learn = 65:70;
% nm_5min_day2_learn = 65:70;

% for LEARNING INDEX using trials 1 - 10
% nm0_day2_learn = 60:69;
% nm2_day2_learn = 62:71;
% nm5_day2_learn = 65:74;
% nm10_day2_learn = 70:79;
% nm39_day2_learn = 99:108;
% nm_15deg_day2_learn = 99:108;
% nm_cntrot_day2_learn = 65:74;
% nm_5min_day2_learn = 65:74;

% for LEARNING INDEX using trials 2 - 7
% nm0_day2_learn = 61:66;
% nm2_day2_learn = 62:68;
% nm5_day2_learn = 66:71;
% nm10_day2_learn = 71:76;
% nm39_day2_learn = 100:105;
% nm_15deg_day2_learn = 100:105;
% nm_cntrot_day2_learn = 66:71;
% nm_5min_day2_learn = 66:71;

nm0_day2_bias = 60;
nm2_day2_bias = 62;
nm5_day2_bias = 65;
nm10_day2_bias = 70;
nm39_day2_bias = 99;
nm_15deg_day2_bias = 99;
nm_cntrot_day2_bias = 65;
nm_5min_day2_bias = 65;

nm0_day2_rate = 61:63;
nm2_day2_rate = 63:65;
nm5_day2_rate = 66:68;
nm10_day2_rate = 71:73;
nm39_day2_rate = 100:102;
nm_15deg_day2_rate = 100:102;
nm_cntrot_day2_rate = 66:68;
nm_5min_day2_rate = 66:68;

% pack all into a structure for use later
experiment_indicies = struct('group', struct('day1', [], 'day2', []));
experiment_indicies.group(1).day1 = nm0_day1_trs;
experiment_indicies.group(1).day2 = nm0_day2_rot_trs;
experiment_indicies.group(2).day1 = nm2_day1_trs;
experiment_indicies.group(2).day2 = nm2_day2_rot_trs;
experiment_indicies.group(3).day1 = nm5_day1_trs;
experiment_indicies.group(3).day2 = nm5_day2_rot_trs;
experiment_indicies.group(4).day1 = nm10_day1_trs;
experiment_indicies.group(4).day2 = nm10_day2_rot_trs;
experiment_indicies.group(5).day1 = nm39_day1_trs;
experiment_indicies.group(5).day2 = nm39_day2_rot_trs;
experiment_indicies.group(6).day1 = nm_15deg_day1_trs;
experiment_indicies.group(6).day2 = nm_15deg_day2_rot_trs;
experiment_indicies.group(7).day1 = nm_cntrot_day1_trs;
experiment_indicies.group(7).day2 = nm_cntrot_day2_rot_trs;
experiment_indicies.group(8).day1 = nm_5min_day1_trs;
experiment_indicies.group(8).day2 = nm_5min_day2_rot_trs;

experiment_indicies.group(1).learn1 = nm0_day1_learn;
experiment_indicies.group(2).learn1 = nm2_day1_learn;
experiment_indicies.group(3).learn1 = nm5_day1_learn;
experiment_indicies.group(4).learn1 = nm10_day1_learn;
experiment_indicies.group(5).learn1 = nm39_day1_learn;
experiment_indicies.group(6).learn1 = nm_15deg_day1_learn;
experiment_indicies.group(7).learn1 = nm_cntrot_day1_learn;
experiment_indicies.group(8).learn1 = nm_5min_day1_learn;

experiment_indicies.group(1).learn2 = nm0_day2_learn;
experiment_indicies.group(2).learn2 = nm2_day2_learn;
experiment_indicies.group(3).learn2 = nm5_day2_learn;
experiment_indicies.group(4).learn2 = nm10_day2_learn;
experiment_indicies.group(5).learn2 = nm39_day2_learn;
experiment_indicies.group(6).learn2 = nm_15deg_day2_learn;
experiment_indicies.group(7).learn2 = nm_cntrot_day2_learn;
experiment_indicies.group(8).learn2 = nm_5min_day2_learn;

experiment_indicies.group(1).bias = nm0_day2_bias;
experiment_indicies.group(2).bias = nm2_day2_bias;
experiment_indicies.group(3).bias = nm5_day2_bias;
experiment_indicies.group(4).bias = nm10_day2_bias;
experiment_indicies.group(5).bias = nm39_day2_bias;
experiment_indicies.group(6).bias = nm_15deg_day2_bias;
experiment_indicies.group(7).bias = nm_cntrot_day2_bias;
experiment_indicies.group(8).bias = nm_5min_day2_bias;

experiment_indicies.group(1).rate = nm0_day2_rate;
experiment_indicies.group(2).rate = nm2_day2_rate;
experiment_indicies.group(3).rate = nm5_day2_rate;
experiment_indicies.group(4).rate = nm10_day2_rate;
experiment_indicies.group(5).rate = nm39_day2_rate;
experiment_indicies.group(6).rate = nm_15deg_day2_rate;
experiment_indicies.group(7).rate = nm_cntrot_day2_rate;
experiment_indicies.group(8).rate = nm_5min_day2_rate;

%% load data
% load('dat_struc_070114B.mat');
load('dat_struc_070614_all.mat');



