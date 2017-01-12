%% setup and load data:
setup_exp_constants;
% load('dir_data_mat_070214.mat')
load('dir_data_mat_070814_all.mat');

analysis_groups = [1 2 3 4 5];
% analysis_groups = [6 7 8];
% analysis_groups = [1 2 3 4 5 6 7 8];
grp_clrs = {'k', 'b', 'g', 'r', 'm', 'm', 'c', 'y'};
CORRECT_BASELINE = 1;

%% gather up all group and subject data from relearning curves (day2)

learn_curves = nan(length(experiment_indicies.group(1).day1), 10, length(analysis_groups));
relearn_curves = nan(length(experiment_indicies.group(1).day2), 10, length(analysis_groups));
k_baseline_bias = 40:59;
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        
        baseline_array = nan(1, length(k_baseline_bias));
        for i_tr = 1:length(k_baseline_bias)
            baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
        end
        
        for i_tr = 1:length(experiment_indicies.group(analysis_groups(i_grp)).day1)
            learn_curves(i_tr, i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(experiment_indicies.group(analysis_groups(i_grp)).day1(i_tr)).scalarDir-...
                (CORRECT_BASELINE)*nanmean(baseline_array);
        end
        for i_tr = 1:length(experiment_indicies.group(analysis_groups(i_grp)).day2)
            relearn_curves(i_tr, i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(experiment_indicies.group(analysis_groups(i_grp)).day2(i_tr)).scalarDir-...
                (CORRECT_BASELINE)*nanmean(baseline_array);
        end
    end
end

%% Plot MEAN relearning curves appropriately aligned

figure; hold on;
x_offset = experiment_indicies.group(1).day2(1);
for i_grp = 1:size(relearn_curves,3)
    temp_relearn = nanmean(relearn_curves(:,:,i_grp), 2);
    plot(experiment_indicies.group(analysis_groups(i_grp)).day2 - x_offset + 1, temp_relearn, grp_clrs{analysis_groups(i_grp)});
    plot(experiment_indicies.group(analysis_groups(i_grp)).day2 - x_offset + 1, temp_relearn, [grp_clrs{analysis_groups(i_grp)}, '.']);
end
axis([0 60 -10 40])



