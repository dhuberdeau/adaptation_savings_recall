%% setup and load data:
setup_exp_constants;

MRKR_SZE = 17;
LIN_SZE = 2;
CORRECT_BASELINE = 0;
PLOT_BUTTLOAD = 1;
%% for reach direction at target measure:
load('dir_data_mat_070814_all.mat');

%% for initial reach direction measure:
% load('dir_data_mat_072214.mat')

%%
% analysis_groups = [2, 3, 4, 5];
analysis_groups = [2, 3, 4, 5, 6 7 8];
% 6 = 15DEG; 7 = 5MIN; 8 = CNT_ROT;
% analysis_groups = [1 2 3 4 5 6 7 8];
grp_clrs = {'k', 'b', 'g', 'r', 'm', 'm', 'c', 'y'};

%% gather up all group and subject data from learning curves (day1)

attainedDir = nan(10, length(analysis_groups));
k_baseline_bias = 40:59;
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        baseline_array = nan(1, length(k_baseline_bias));
        for i_tr = 1:length(k_baseline_bias)
            baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
        end
        
        k_attained = experiment_indicies.group(analysis_groups(i_grp)).day1(end);
        attainedDir(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_attained).scalarDir - ...
            (CORRECT_BASELINE)*nanmean(baseline_array);
            
     end
end

%% Plot individual learning curves if desired:
if PLOT_BUTTLOAD
    learn_curve = nan(10, 39, length(analysis_groups));
    k_baseline_bias = 40:59;
    for i_grp = 1:length(analysis_groups)
        for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
            baseline_array = nan(1, length(k_baseline_bias));
            for i_tr = 1:length(k_baseline_bias)
                baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
            end

            k_learn1 = (experiment_indicies.group(analysis_groups(i_grp)).learn1(1)-1):experiment_indicies.group(analysis_groups(i_grp)).day1(end);
            for i_tr = 1:length(k_learn1)
                learn_curve(i_sub, i_tr, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_learn1(i_tr)).scalarDir - ...
                    (CORRECT_BASELINE)*nanmean(baseline_array);
            end

         end
    end
    
    % Plot the curves individually:
    for i_grp = 1:length(analysis_groups)
        k_learn1 = (experiment_indicies.group(analysis_groups(i_grp)).learn1(1)-1):experiment_indicies.group(analysis_groups(i_grp)).day1(end);
        curve_se = nan(1, length(k_learn1));
        for i_tr = 1:length(k_learn1)
            curve_se(i_tr) = sqrt(nanvar(learn_curve(:, i_tr, i_grp), [], 1)/sum(~isnan(learn_curve(:, i_tr, i_grp))));
        end
        figure; hold on;
        plot(1:length(k_learn1), nanmean(learn_curve(:, 1:length(k_learn1), i_grp), 1), grp_clrs{analysis_groups(i_grp)}, 'LineWidth', LIN_SZE);
        plot(1:length(k_learn1), nanmean(learn_curve(:, 1:length(k_learn1), i_grp), 1) + curve_se, grp_clrs{analysis_groups(i_grp)}, 'LineWidth', 1);
        plot(1:length(k_learn1), nanmean(learn_curve(:, 1:length(k_learn1), i_grp), 1) - curve_se, grp_clrs{analysis_groups(i_grp)}, 'LineWidth', 1);
        axis([0 40 -10 40])
    end
end


%% stats
t_test_p_vals = nan(1, size(attainedDir,2));
figure; hold on
for i_grp = 1:size(attainedDir, 2)
    bar(i_grp, nanmean(attainedDir(:, i_grp), 1), grp_clrs{i_grp});
    errorbar(i_grp, nanmean(attainedDir(:, i_grp), 1), sqrt(nanmean(attainedDir(:, i_grp), 1)./nanvar(attainedDir(:, i_grp), 0, 1)), 'k.');
    [h, t_test_p_vals(i_grp)] = ttest(attainedDir(:,i_grp));
end
axis([0, length(analysis_groups)+1, -10, 30]);
t_test_p_vals

