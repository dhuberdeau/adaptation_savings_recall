%% setup and load data:
setup_exp_constants;

CORRECT_BASELINE = 1;
%% for reach direction at target measure:
load('dir_data_mat_070814_all.mat');

%% for initial reach direction measure:
% load('dir_data_mat_072214.mat')

%%
analysis_groups = [1, 2, 3, 4, 5];
% analysis_groups = [1 3 7];
% 6 = 15DEG; 7 = 5MIN; 8 = CNT_ROT;
% analysis_groups = [1 2 3 4 5 6 7 8];
grp_clrs = {'k', 'b', 'g', 'r', 'm', 'm', 'c', 'y'};

%% gather up all group and subject data from relearning curves (day2)

biasDir = nan(10, length(analysis_groups));
k_baseline_bias = 40:59;
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        
        baseline_array = nan(1, length(k_baseline_bias));
        for i_tr = 1:length(k_baseline_bias)
            baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
        end
        
        i_tr_bias = experiment_indicies.group(analysis_groups(i_grp)).bias;
        biasDir(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_bias).scalarDir - (CORRECT_BASELINE)*nanmean(baseline_array);
            
     end
end

%% stats
t_test_p_vals = nan(1, size(biasDir,2));
figure; hold on
for i_grp = 1:size(biasDir, 2)
    bar(i_grp, nanmean(biasDir(:, i_grp), 1), grp_clrs{analysis_groups(i_grp)});
    errorbar(i_grp, nanmean(biasDir(:, i_grp), 1), sqrt(nanvar(biasDir(:, i_grp), 0, 1)./size(biasDir,1)), 'k.');
    [h, t_test_p_vals(i_grp)] = ttest(biasDir(:,i_grp));
end
axis([min(analysis_groups)-1, max(analysis_groups)+1, -10, 30]);
t_test_p_vals

