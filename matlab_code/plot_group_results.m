function limits = plot_group_results(file_list_psd, file_list_erp, data_set, category, plot_types, mse_or_std)

if category == "c"
    category_name = "Control";
    color = [0.6 0.6 0.6];
elseif category == "tl"
    category_name = "TMS on Lip Target";
    color = [0.961 0.514 0.133];
elseif category == "tt"
    category_name = "TMS on Tongue Target";
    color = [0.8 0.55 0.368];
end

if data_set == "2019"
    subjects = ["P01", "P02", "P04", "P05", "P06", "P07", "P08"];
    subplot_index_0 = 3;
    subplot_index_1 = 3;
    plot_sequence = [1:6 8];
else
    subjects = ["S01", "S02", "S03","S04", "S05", "S06", "S07", "S08", "S09", "S10", "S11", "S12", "S14", "S15", "S16"];
    subplot_index_0 = 4;
    subplot_index_1 = 4;
    plot_sequence = 1:15;
end

previus_lim = [-27.5 23.4 97.2];
channel_name = ["Fp1", "Fpz", "Fp2", "F7", "F3", "Fz", "F4", "F8", "FC5", ...
    "FC1", "FC2", "FC6", "T7", "C3", "Cz", "C4", "T8", "CP5", "CP1", ...
    "CP2", "CP6", "P7", "P3", "Pz", "P4", "P8", "POz", "O1", "O2", "AF7", ...
    "AF3", "AF4", "AF8", "F5", "F1", "F2", "F6", "FC3", "FCz", "FC4", ...
    "C5", "C1", "C2", "C6", "CP3", "CP4", "P5", "P1", "P2", "P6", "PO5", ...
    "PO3", "PO4", "PO6", "FT7", "FT8", "TP7", "TP8", "PO7", "PO8", "Oz"];

psd_struct.psd_data = [];
psd_struct.frequency = [];

for file = 1:length(file_list_psd)
    new_psd_data = load(strcat(file_list_psd(file).folder, "\", file_list_psd(file).name)).psd_data;
    psd_struct.psd_data = [psd_struct.psd_data new_psd_data];
    psd_struct.frequency = [psd_struct.frequency load(strcat(file_list_psd(file).folder, "\", file_list_psd(file).name)).frequency];    
end

erp_struct.erp_data = [];
erp_struct.time = [];
erp_struct.subject_index = 0;

if plot_types(5) == 1
    figure('Position', get(0, 'Screensize'))
    sgtitle (["Event-Related Potentials" category_name + " - " + data_set + " Dataset"])
end
for file = 1:length(file_list_erp)
    new_erp_data = load(strcat(file_list_erp(file).folder, "\", file_list_erp(file).name)).erp_data;
    erp_struct.erp_data = [erp_struct.erp_data; new_erp_data];
    new_erp_time = load(strcat(file_list_erp(file).folder, "\", file_list_erp(file).name)).time;
    erp_struct.time = [erp_struct.time; new_erp_time];
    [number_records, ~] = size(new_erp_data);
    erp_struct.subject_index = [erp_struct.subject_index erp_struct.subject_index(end) + number_records];

    if plot_types(5) == 1
        subplot(subplot_index_0, subplot_index_1, plot_sequence(file))
        if mse_or_std == "mse"
            curve1 = mean(new_erp_data,1) + std(new_erp_data,0,1)/sqrt(length(new_erp_data));
            curve2 = mean(new_erp_data,1) - std(new_erp_data,0,1)/sqrt(length(new_erp_data));
        else
            curve1 = mean(new_erp_data,1) + std(new_erp_data,0,1);
            curve2 = mean(new_erp_data,1) - std(new_erp_data,0,1);
        end
        mean_curve = [new_erp_time(1,:), fliplr(new_erp_time(1,:))];
        inBetween = [smooth(curve1)', smooth(fliplr(curve2))'];
        fill(mean_curve, inBetween, color, 'FaceAlpha', 0.25, 'EdgeColor', 'none');
        hold on;
        %plot(erp_struct.time(1,:), erp_struct.erp_data, 'HandleVisibility','off');
        %hold
        plot(erp_struct.time(1,:), smooth(mean(new_erp_data,1)), 'color', color, 'LineWidth', 2);
        title(subjects(file))
        set(gcf,'color','w');
        xlim([0 erp_struct.time(end)]);
    end
end
if plot_types(5) == 1
    if mse_or_std == "mse"
        legend("RMSE", "Mean", 'Orientation', 'horizontal');
    else
        legend("Standard Error of Mean", "Mean", 'Orientation', 'horizontal');
    end
    Lgnd = legend('show');
    Lgnd.Position(1) = 0.38;
    Lgnd.Position(2) = 0.01;
    
    subplot(subplot_index_0, subplot_index_1, subplot_index_0*subplot_index_1)
    ylabel('Potentials (\muV)','FontSize', 8)
    xlabel('Latency (ms)','FontSize', 8)
    set(gcf,'color','w');
    set(gca,'TickLength',[0 .01])
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    box off
end

if plot_types(1) == 1
    figure()
    if mse_or_std == "mse"
        curve1 = mean(psd_struct.psd_data,2) + std(psd_struct.psd_data,0,2)/sqrt(length(psd_struct.psd_data));
        curve2 = mean(psd_struct.psd_data,2) - std(psd_struct.psd_data,0,2)/sqrt(length(psd_struct.psd_data));
    else
        curve1 = mean(psd_struct.psd_data,2) + std(psd_struct.psd_data,0,2);
        curve2 = mean(psd_struct.psd_data,2) - std(psd_struct.psd_data,0,2);
    end
    mean_curve = [psd_struct.frequency(:,1)', fliplr(psd_struct.frequency(:,1)')];
    inBetween = [curve1', fliplr(curve2')];
    fill(mean_curve, inBetween, color, 'FaceAlpha', 0.25, 'EdgeColor', 'none');
    hold on;
    %plot(psd_struct.frequency(:,1), psd_struct.psd_data, 'HandleVisibility','off');
    %hold
    plot(psd_struct.frequency(:,1), mean(psd_struct.psd_data,2), 'color', color, 'LineWidth', 2);
    if mse_or_std == "mse"
        legend("Standard Error of Mean", "Mean");
    else
        legend("Standard Deviation", "Mean");
    end
    title(["Power Spectral Density"  category_name + " - " + data_set + " Dataset"], 'FontWeight', 'bold')
    xlabel('Frequency (Hz)')
    ylabel('10*log_{10}(\mu V^{2}/Hz)')
    set(gcf,'color','w');
    [min_x, max_x] = bounds(psd_struct.frequency(:,1));
    xlim([min_x max_x]);
    ylim([min(curve2)-3 max(curve1)+3]);
end

%%

if plot_types(2) == 1
    figure()
    if mse_or_std == "mse"
        curve1 = mean(erp_struct.erp_data,1) + std(erp_struct.erp_data,0,1)/sqrt(length(new_erp_data));
        curve2 = mean(erp_struct.erp_data,1) - std(erp_struct.erp_data,0,1)/sqrt(length(new_erp_data));
    else
        curve1 = mean(erp_struct.erp_data,1) + std(erp_struct.erp_data,0,1);
        curve2 = mean(erp_struct.erp_data,1) - std(erp_struct.erp_data,0,1);
    end
    mean_curve = [erp_struct.time(1,:), fliplr(erp_struct.time(1,:))];
    inBetween = [smooth(curve1)', smooth(fliplr(curve2))'];
    fill(mean_curve, inBetween, color, 'FaceAlpha', 0.25, 'EdgeColor', 'none');
    hold on;
    %plot(erp_struct.time(1,:), erp_struct.erp_data, 'HandleVisibility','off');
    %hold
    plot(erp_struct.time(1,:), smooth(mean(erp_struct.erp_data,1)), 'color', color, 'LineWidth', 2);
    if mse_or_std == "mse"
        lg = legend("Standard Error of Mean", "Mean");
        lg.FontSize = 11;
    else
        lg = legend("Standard Deviation", "Mean");
        lg.FontSize = 11;
    end
    title(["Event-Related Potentials" category_name + " - " + data_set + " Dataset"], 'FontWeight', 'bold', 'FontSize', 15)
    xlabel('Latency (ms)', 'FontSize', 13)
    ylabel('Potentials (\muV)', 'FontSize', 13) 
    set(gcf, 'color','w');
    set(gca, 'FontSize', 11)
    xlim([0 erp_struct.time(end)]);
    if category == "c"
        ylim([-15 15]);
    else
        ylim([previus_lim(1)-2 previus_lim(2)+2]);
    end
    limits = [min(curve2)-2 max(curve1)+2];
end

if plot_types(3) == 1
    figure()
    [number_off_trials, ~] = size(erp_struct.erp_data);
    scatter(1:number_off_trials, std(erp_struct.erp_data,0,2), 5, 'filled', 'o', 'MarkerFaceColor', color, 'MarkerEdgeColor', 'none');
    hold on
    plot(1:number_off_trials, mean(erp_struct.erp_data,2), 'k', 'LineWidth', 1);
    if data_set == "2020"
        xline(erp_struct.subject_index(1:end-1), '--', {'S01', 'S02', 'S03', 'S04', 'S05', 'S06', 'S07', 'S08', 'S09', 'S10', 'S11', 'S12', 'S14', 'S15', 'S16'}, 'FontSize', 8, 'LabelVerticalAlignment', 'bottom')
    else
        xline(erp_struct.subject_index(1:end-1), '--', {'P01', 'P02', 'P04', 'P05', 'P06', 'P07', 'P08'}, 'FontSize', 8, 'LabelVerticalAlignment', 'bottom')
    end
    lg = legend("Standard Deviation", "Mean", "Location", 'southoutside', 'Orientation', 'horizontal');
    lg.FontSize = 11;
    title(["Standard Deviation On Each Channel"  category_name + " - " + data_set + " Dataset"], 'FontWeight', 'bold', 'FontSize', 15)
    xlabel('Channels of Each Subjects', 'FontSize', 13)
    ylabel('Potentials (\muV)', 'FontSize', 13) 
    xlim([0 number_off_trials]);
    ylim([-15 previus_lim(3)+5]);
    set(gcf,'color','w');
    set(gca,'TickLength',[0 .01], 'FontSize', 11)
    set(gca,'xtick',[])
    limits = [limits max(std(erp_struct.erp_data,0,2))+10];
end

if plot_types(4) == 1
    figure('Position', get(0, 'Screensize'))
    sgtitle(["ERP Distribution Of Each Channel" category_name + " - " + data_set + " Dataset"])
    reshaped_erp = zeros(61, 256*length(file_list_psd));
    last = 0;
    for row = 1:61
        for subject = 1:length(file_list_psd)
            reshaped_erp(row, last + 1:last + 256) = erp_struct.erp_data(row + 61*(subject-1),:);
            last = 256*subject;
        end
        last = 0;
    end
    
    channels = 1:61;
    plots = 1:62;
    
    for p = channels
        subplot(9,7,plots(p))
        histogram(reshaped_erp(p,:), 50, 'FaceColor', color, 'EdgeColor', 'none', 'Normalization', 'probability')
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        ylim([0 0.3]);
        xlim([-25 25]);
        title("(std = " + string(std(reshaped_erp(p,:))) + ")", 'FontSize', 7);
        ylabel(channel_name(p), "FontSize", 8, "FontWeight", 'bold')
    end
    
    subplot(9,7,63)
    plot([-25; -25], [0; 0.3], '-k', [-25; 25], [0; 0], '-k', 'LineWidth', 1)
    hold off
    %xlim([-10 30]);
    %ylim([-10 30]);
    ylabel('Probability','FontSize', 8)
    xlabel('Potentials (\muV)','FontSize', 8)
    set(gcf,'color','w');
    set(gca,'TickLength',[0 .01])
    set(gca,'YTickLabelRotation', 90)
    xlim([-25 25]);
    xticks([-25 0 25]);
    ylim([0 0.3]);
    yticks([0 0.3]);
    box off
end



















