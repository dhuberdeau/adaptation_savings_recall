%% setup and load data:
setup_exp_constants;


%% for reach direction at target measure:
load('dir_data_mat_070814_all.mat');

%% for initial reach direction measure:
% load('dir_data_mat_072214.mat')

%%
analysis_groups = [2 3 4 5];
% analysis_groups = [6 7 8];
% 6 = 15DEG; 7 = 5MIN; 8 = CNT_ROT;
% analysis_groups = [1 2 3 4 5 6 7 8];
grp_clrs = {'k', 'b', 'g', 'r', 'm', 'm', 'c', 'y'};

%% gather up all group and subject data from relearning curves (day2)

learn_curves = nan(10, length(analysis_groups));
relearn_curves = nan(10, length(analysis_groups));
init_bias = nan(10, length(analysis_groups));
learn1_attained = nan(10, length(analysis_groups));
for i_grp = 1:length(analysis_groups)
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        if ~isempty(experiment_indicies.group(analysis_groups(i_grp)).learn1(1))
            if analysis_groups(i_grp) == 8
                % CNT_ROT
                i_tr_learn = experiment_indicies.group(analysis_groups(i_grp)).learn1(1);
                i_tr_bias = experiment_indicies.group(analysis_groups(i_grp)).learn1(1)-1;
                learn_curves(i_sub, i_grp) = -dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_learn).scalarDir - ...
                    dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_bias).scalarDir;
                
                i_tr_attain = experiment_indicies.group(analysis_groups(i_grp)).bias-1;
                learn1_attained(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_attain).scalarDir;
            else
                i_tr_learn = experiment_indicies.group(analysis_groups(i_grp)).learn1(1);
                i_tr_bias = experiment_indicies.group(analysis_groups(i_grp)).learn1(1) - 1;
                learn_curves(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_learn).scalarDir - ...
                    dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_bias).scalarDir;
                
                i_tr_attain = experiment_indicies.group(analysis_groups(i_grp)).bias-1;
                learn1_attained(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_attain).scalarDir;
            end
            
            i_tr_relearn = experiment_indicies.group(analysis_groups(i_grp)).learn2(1);
            i_tr_bias = experiment_indicies.group(analysis_groups(i_grp)).bias;
            relearn_curves(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_relearn).scalarDir - ...
                dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_bias).scalarDir;
            
            init_bias(i_sub, i_grp) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(i_tr_bias).scalarDir;
            
        end
     end
end

%% stats

diff_response = relearn_curves - learn_curves;
t_test_p_vals = nan(1, size(learn_curves, 2));
t_test_t_vals = nan(1, size(learn_curves, 2));
for i_grp = 1:size(diff_response, 2)
    [h, t_test_p_vals(i_grp), s] = ttest(diff_response(:,i_grp));
    t_test_t_vals(i_grp) = s(1);
end
disp('rotation response T-Test p-Vals:');
t_test_p_vals
t_test_t_vals*sqrt(2)


anova1(diff_response);

%% show trial biases:
disp('initial bias (learn2)');
nanmean(init_bias)
disp('attained dir (learn1)');
nanmean(learn1_attained)

%% plot bar plots:
figure; hold on
for i_grp = 1:length(analysis_groups)
    bar(i_grp, nanmean(diff_response(:,i_grp),1), grp_clrs{analysis_groups(i_grp)});
    errorbar(i_grp, nanmean(diff_response(:,i_grp),1),...
        sqrt(nanvar(diff_response(:,i_grp),[], 1)./sum(~isnan(diff_response(:,i_grp)))),...
        'k');
end
axis([0 5 0 30]);