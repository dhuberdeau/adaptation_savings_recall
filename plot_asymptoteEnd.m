%% setup and load data:
setup_exp_constants;
CORRECT_BASELINE = 1;
N_ASYM_TRS = 40;
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

figure;
asymDir = nan(10, length(analysis_groups));
k_baseline_bias = 40:59;
for i_grp = 1:length(analysis_groups)
    relearnCurves = nan(10, length(experiment_indicies.group(analysis_groups(i_grp)).day2));
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        
        baseline_array = nan(1, length(k_baseline_bias));
        
        k_tr_day2 = experiment_indicies.group(analysis_groups(i_grp)).day2;
        relearn_array = nan(1, length(k_tr_day2));
        
        k_tr_asym = experiment_indicies.group(analysis_groups(i_grp)).day2((end-N_ASYM_TRS+1):end);
        asym_array = nan(1, length(k_tr_asym));
        
        for i_asym = 1:length(k_tr_asym)
            asym_array(i_asym) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_tr_asym(i_asym)).scalarDir;
        end
        for i_tr = 1:length(k_tr_day2)
            relearn_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_tr_day2(i_tr)).scalarDir;
        end
        for i_tr = 1:length(k_baseline_bias)
            baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
        end
        
        asymDir(i_sub, i_grp) = nanmean(asym_array) - (CORRECT_BASELINE)*nanmean(baseline_array);
        relearnCurves(i_sub,:) = relearn_array - (CORRECT_BASELINE)*nanmean(baseline_array);
    end
     subplot(ceil(sqrt(length(analysis_groups))), ceil(sqrt(length(analysis_groups))), i_grp);
     plot(1:length(k_tr_day2), nanmean(relearnCurves,1), [grp_clrs{i_grp}, '.']);
     hold on
     plot((length(k_tr_day2)- N_ASYM_TRS+1):length(k_tr_day2), repmat(nanmean(asymDir(:, i_grp),1), 1, N_ASYM_TRS), grp_clrs{i_grp});
     axis([0 70 -5 35])
end

%% stats
t_test_p_vals = nan(1, size(asymDir,2));
figure; hold on
for i_grp = 1:size(asymDir, 2)
    bar(i_grp, nanmean(asymDir(:, i_grp), 1), grp_clrs{analysis_groups(i_grp)});
    errorbar(i_grp, nanmean(asymDir(:, i_grp), 1), sqrt(nanvar(asymDir(:, i_grp), 0, 1)./size(asymDir,1)), 'k.');
    [h, t_test_p_vals(i_grp)] = ttest(asymDir(:,i_grp));
end
axis([min(analysis_groups)-1, max(analysis_groups)+1, -10, 30]);
t_test_p_vals

[p, junk, stats] = anova1(asymDir);

