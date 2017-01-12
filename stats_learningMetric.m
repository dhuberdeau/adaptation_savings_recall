%% setup and load data:
setup_exp_constants;
% load('dir_data_mat_070214.mat')
CORRECT_BASELINE = 1;
%% for reach direction at target measure:
% load('dir_data_mat_070814_all.mat');

%% for initial reach direction measure:
% load('dir_data_mat_072214.mat')

grp_clrs = {'k', 'b', 'g', 'r', 'm', 'm', 'c', 'y'};

%%
analysis_groups = [1 2 3 4 5];
% analysis_groups = [2 3 4 5];
%  analysis_groups = [1 3 7];
% analysis_groups = [1 3 8];
% analysis_groups = [1 2 3 4 5 6 7 8];

%% populate data matrix for learning metric (the simple average)

learningMet_mat = nan(length(experiment_indicies.group(1).learn2), 10, length(experiment_indicies.group));
k_baseline_bias = 40:59;
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        i_ind = 1;
        for i_tr = experiment_indicies.group(analysis_groups(i_grp)).learn2
            learningMet_mat(i_ind, i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr).scalarDir;
            i_ind = i_ind + 1;
        end
    end
end

stat_mat = nan(10, length(analysis_groups));
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:size(stat_mat,1)
        
        baseline_array = nan(1, length(k_baseline_bias));
        for i_tr = 1:length(k_baseline_bias)
            baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
        end
        
        stat_mat(i_sub, i_grp) = nanmean(learningMet_mat(:, i_sub, i_grp)) - (CORRECT_BASELINE)*nanmean(baseline_array);
    end
end
    
figure; hold on;
for i_grp = 1:size(stat_mat,2)
        bar(i_grp, nanmean(stat_mat(:, i_grp)), grp_clrs{analysis_groups(i_grp)});
        errorbar(i_grp, nanmean(stat_mat(:, i_grp)), sqrt(var(stat_mat(:, i_grp), 0, 1)./sum(~isnan(stat_mat(:, i_grp)))), 'k.');
end
axis([0 6 -10 30]);
[p, junk, s] = anova1(stat_mat);
% mcomp = multcompare(s, 'ctype', 'lsd');
mcomp = multcompare(s, 'alpha', .05);
% simplt t-tests doing multi-comparison:
p_vals = nan(1, size(stat_mat,2));
for i_grp = 2:size(stat_mat,2)
    [h, p_vals(i_grp)] = ttest2(stat_mat(:,1), stat_mat(:,i_grp));
end
%% populate data matrix for rate metric

rateMet_mat = nan(length(dat_struc.group)*length(dat_struc.group(1).subject)*length(experiment_indicies.group(1).rate), 4);

exclude_this_sub = false;
i_ind = 1; i_sub_ind = 1; i_grp_num = 1;
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        exclude_this_sub = false;
        i_tr_ind = 1;
        this_sub_mat = nan(3,4);
        for i_tr = experiment_indicies.group(analysis_groups(i_grp)).rate
            rate_diff = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr).scalarDir - ...
                dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(experiment_indicies.group(analysis_groups(i_grp)).bias).scalarDir;
            if ~isnan(rate_diff)
                this_sub_mat(i_tr_ind,1) = rate_diff;
                this_sub_mat(i_tr_ind,2) = i_grp_num;
                this_sub_mat(i_tr_ind,3) = i_tr_ind;
                this_sub_mat(i_tr_ind,4) = i_sub_ind;
                
%                 rateMet_mat(i_ind,1) = rate_diff;
% 
%                 rateMet_mat(i_ind,2) = i_grp;
%                 rateMet_mat(i_ind,3) = i_tr_ind;
%                 rateMet_mat(i_ind,4) = i_sub_ind;
                i_tr_ind = i_tr_ind + 1;
%                 i_ind = i_ind + 1;
            else
                warning('Rate is nan! Excluding subject.');
                exclude_this_sub = true;
            end
        end
        if ~exclude_this_sub
            rateMet_mat(i_ind:(i_ind + 2),:) = this_sub_mat;
            i_sub_ind = i_sub_ind + 1;
            i_ind = i_ind + 3;
        end
    end
    i_grp_num = i_grp_num + 1;
end

%%
rateMet_mat_temp = nan(sum(~isnan(rateMet_mat(:,1))), size(rateMet_mat,2));
for i_col = 1:size(rateMet_mat_temp,2)
    rateMet_mat_temp(:,i_col) = rateMet_mat(~isnan(rateMet_mat(:,i_col)), i_col);
end
rateMet_mat = rateMet_mat_temp;
% col1 - variable, col2 - between subject factor, col3 - within subj
% factor, col4 - subject code
mixed_anova_output = mixed_between_within_anova(rateMet_mat);