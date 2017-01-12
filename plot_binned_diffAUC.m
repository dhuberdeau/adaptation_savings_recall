setup_exp_constants;

MRKR_SZE = 17;
LIN_SZE = 2;
CORRECT_BASELINE = 1;
PLOT_BUTTLOAD = 1;
N_PER_BIN = 5;
%% for reach direction at target measure:
load('dir_data_mat_070814_all.mat');

%% for initial reach direction measure:
% load('dir_data_mat_072214.mat')

%%
analysis_groups = [1, 2, 3, 4, 5];
% analysis_groups = [1, 3, 7];
baseline_all = nan(1, 10*length(analysis_groups));
% analysis_groups = [6 7 8];
% 6 = 15DEG; 7 = 5MIN; 8 = CNT_ROT;
% analysis_groups = [1 2 3 4 5 6 7 8];
grp_clrs = {'k', 'b', 'g', 'r', 'm', 'm', 'c', 'y'};


%% 

binned_signal = nan(10, 1+ floor((length(experiment_indicies.group(1).day2)-1)/N_PER_BIN), length(analysis_groups));
k_baseline_bias = 40:59;
for i_grp = 1:length(analysis_groups)
    k_bias = experiment_indicies.group(analysis_groups(i_grp)).bias;
    k_binning_sig = experiment_indicies.group(analysis_groups(i_grp)).day2(2:end); %bc 1 is bias
    
    for i_sub = 1:length(dat_struc.group(analysis_groups(i_grp)).subject)
        baseline_array = nan(1, length(k_baseline_bias));
        for i_tr = 1:length(k_baseline_bias)
            baseline_array(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_baseline_bias(i_tr)).scalarDir;
        end

        temp_day2_signal = nan(1, length(experiment_indicies.group(analysis_groups(i_grp)).day2));
        for i_tr = 1:length(k_binning_sig)
            temp_day2_signal(i_tr) = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_binning_sig(i_tr)).scalarDir - ...
                (CORRECT_BASELINE)*nanmean(baseline_array);
        end
        temp_day2_bias = dat_struc.group(analysis_groups(i_grp)).subject(i_sub).trial(k_bias).scalarDir - ...
                (CORRECT_BASELINE)*nanmean(baseline_array);
        temp_day2_binned = mafilt(temp_day2_signal', N_PER_BIN)';
        binned_signal(i_sub, :, i_grp) = [temp_day2_bias, temp_day2_binned(1:floor((length(experiment_indicies.group(1).day2)-1)/N_PER_BIN))];
    end
end

%% Plot:
grp_offsets = 3*[-.05, -.025, .025, .05, .075];
bin_actual_trials = [1 4:5:63];
figure;
for i_grp = 1:size(binned_signal,3)
%     subplot(2, 3, i_grp);
    hold on;
    for i_tr = 1:size(binned_signal, 2)
        errorbar(bin_actual_trials(i_tr)+grp_offsets(i_grp), nanmean(binned_signal(:, i_tr, i_grp), 1), sqrt(nanvar(binned_signal(:, i_tr, i_grp), [], 1)/sum(~isnan(binned_signal(:, i_tr, i_grp)))), [grp_clrs{analysis_groups(i_grp)}, '.'], 'MarkerSize', MRKR_SZE);
    end
    plot(bin_actual_trials+grp_offsets(i_grp), nanmean(binned_signal(:, :, i_grp), 1), grp_clrs{analysis_groups(i_grp)}, 'LineWidth', LIN_SZE);
end

%% Plot aligned by total adaptation trial count:
grp_offsets = 3*[-.05, -.025, .025, .05, .075];
% bin_actual_trials = [1 linspace(4,64,12)];
bin_actual_trials = [1 4:5:63];
figure;
for i_grp = 1:size(binned_signal,3)
%     subplot(2, 3, i_grp);
    trial_adapt1_end = experiment_indicies.group(analysis_groups(i_grp)).day1(end);
    hold on;
    for i_tr = 1:size(binned_signal, 2)
        errorbar(trial_adapt1_end + bin_actual_trials(i_tr), nanmean(binned_signal(:, i_tr, i_grp), 1), sqrt(nanvar(binned_signal(:, i_tr, i_grp), [], 1)/sum(~isnan(binned_signal(:, i_tr, i_grp)))), [grp_clrs{i_grp}, '.'], 'MarkerSize', MRKR_SZE);
    end
    plot(trial_adapt1_end + bin_actual_trials, nanmean(binned_signal(:, :, i_grp), 1), grp_clrs{i_grp}, 'LineWidth', LIN_SZE);
end

%% stats on 3rd bin (savings-2)

[p, junk, s] = anova1(reshape(binned_signal(:,3,:), 10, length(analysis_groups)));
multcompare(s);

figure; hold on;
for i_grp = 1:length(analysis_groups)
    bar(i_grp, nanmean(binned_signal(:, 3, i_grp), 1), grp_clrs{analysis_groups(i_grp)});
    errorbar(i_grp, nanmean(binned_signal(:, 3, i_grp), 1), sqrt(nanvar(binned_signal(:, 3, i_grp), [], 1)/sum(~isnan(binned_signal(:,3,i_grp)))), 'k.');
end
axis([0 length(analysis_groups)+1, -10 30]);

%% compute groups' difference from group-0 signals:
k_grp_0 = 1;
cntrl_sig = nanmean(binned_signal(:, :, k_grp_0), 1);
diff_binned_sigs = nan(size(binned_signal, 1), size(binned_signal,2), size(binned_signal,3)-1);
% bin_actual_trials = [1 linspace(4,64,12)];
bin_actual_trials = [1 4:5:63];
i_grp_diff = 1;
for i_grp = 2:length(analysis_groups)
    for i_sub = 1:10
        for i_bin = 1:size(binned_signal,2)
            diff_binned_sigs(i_sub, i_bin, i_grp_diff) = binned_signal(i_sub, i_bin, i_grp) - cntrl_sig(i_bin);
        end
    end
    i_grp_diff = i_grp_diff + 1;
end

figure; hold on;
for i_grp = 1:size(diff_binned_sigs,3)
    for i_bin = 1:size(diff_binned_sigs,2)
        errorbar(bin_actual_trials(i_bin) + grp_offsets(i_grp), nanmean(diff_binned_sigs(:, i_bin, i_grp),1), sqrt(nanvar(diff_binned_sigs(:, i_bin, i_grp),[],1)/sum(~isnan(diff_binned_sigs(:, i_bin, i_grp)))), [grp_clrs{analysis_groups(i_grp+1)}, '.'], 'MarkerSize', MRKR_SZE);
    end
    plot((bin_actual_trials) + grp_offsets(i_grp), nanmean(diff_binned_sigs(:,:, i_grp),1), [grp_clrs{analysis_groups(i_grp+1)}], 'LineWidth', LIN_SZE);
end
axis([0 65 -6 12])


