function [psd_data, frequency, erp_data, time] = plot_results(EEG, psd_flag, erp_flag, erp_topo_flag, save_flag, save_file, stage, save_mat)
    psd_data = [];
    frequency = [];
    erp_data = [];
    time = [];

    if stage == "Final Result"
        stage = "";
    else
        stage = "(" + stage + ")";
    end
    
    figures = [];
    
    if psd_flag == 1
        figure_1 = figure;
        figures = [figures figure_1];
        [psd_data, frequency] = pop_spectopo(EEG, 1, [0 EEG.times(end)], 'EEG', 'freqrange', [0.1 55], 'electrodes', 'off');
        psd_data = psd_data';
        close(figure_1)
        figure_1 = figure;
        plot(frequency, psd_data, 'HandleVisibility','off');
        hold
        plot(frequency, mean(psd_data,2), '-k', 'LineWidth', 2);
        legend("Mean");
        title(["Power Spectral Density"  stage])
        xlabel('Frequency (Hz)')
        ylabel('10*log_{10}(\mu V^{2}/Hz)')
        set(gcf,'color','w');
        [min, max] = bounds(frequency);
        xlim([min max]);
        [min, max] = bounds(psd_data, 'all');
        ylim([min max]);
        if save_flag == 1
           exportgraphics(figure_1, save_file + "_psd.png", 'Resolution', 300);
        end
        if save_mat == "True"
            save_mat_file = char(save_file + "_psd.mat");
            save(save_mat_file, 'psd_data', 'frequency');
        end
    end
    if erp_flag == 1       
        figure_2 = figure;
        figures = [figures figure_2];
        data_reshaped = reshape(EEG.data, size(EEG.data,1), EEG.pnts, EEG.trials);
        time_range = [0 EEG.times(end)];
        posi = round((time_range(1)/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;
        posf = round((time_range(2)/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;

        erp_data = mean(data_reshaped(:,posi:posf,:),3);
        time = EEG.times;
        
        plot(time, erp_data, 'HandleVisibility','off');
        hold
        plot(time, mean(erp_data,1), '-k', 'LineWidth', 2);
        legend("Mean");
        title(["Event Related Potentials" stage])
        xlabel('Latency (ms)')
        ylabel('Potentials (\muV)') 
        set(gcf,'color','w');
        xlim([0 time(end)]);
        [min, max] = bounds(erp_data, 'all');
        ylim([min max]);
        if save_flag == 1
           exportgraphics(figure_2, save_file + "_erp.png",'Resolution', 300)
        end
        if save_mat == "True"
            save_mat_file = char(save_file + "_erp.mat");
            save(save_mat_file, 'erp_data', 'time');
        end
    end
    if erp_topo_flag == 1
        figure_3 = figure;
        figures = [figures figure_3];
        pop_plottopo(EEG, [1:EEG.nbchan], 'Topographic Event Related Potential', 0, 'ydir', 1, 'ylim', [-35 35]);
        set(gcf,'color','w');
        if save_flag == 1
           exportgraphics(figure_3, save_file + "_erp_topo.png",'Resolution', 300);
        end
    end
    
    %close(figures);
        
end