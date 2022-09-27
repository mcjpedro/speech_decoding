clear
clc

data_set = ["2019", "2020"];
category = ["c", "tl", "tt"];
mse_or_std = "std";

plot_psd = 1;
plot_erp = 1;
plot_std_per_subject = 1;
plot_dist_per_ch = 1;
erp_per_subject = 1;
plot_types = [plot_psd, plot_erp, plot_std_per_subject, plot_dist_per_ch, erp_per_subject];

for d = 1:length(data_set)
    for c = 1:length(category)
        main_path = pwd;
        path_name = "F:\\ucla_analysis\\eeg_analysis_joao\\data_" + data_set(d);  % Opens a pop-up to folder selection 
        cd(path_name)
        file_list_psd = dir("*\*\*\*_" + category(c) + "_psd.mat");
        file_list_erp = dir("*\*\*\*_" + category(c) + "_erp.mat");
        cd(main_path)
    
        plot_group_results(file_list_psd, file_list_erp, data_set(d), category(c), plot_types, mse_or_std);
    end
end

%%

path_name = uigetdir();                                     % Opens a pop-up to folder selection

figure_list = findobj(allchild(0), 'flat', 'Type', 'figure');
for fig = 1:length(figure_list)
  figure_handler = figure_list(fig);
  exportgraphics(figure_handler, path_name + "\figure_" + string(fig) + ".png",'Resolution', 800);
end

disp("DONE!");

close all




