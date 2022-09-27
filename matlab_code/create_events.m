function EEG = create_events(EEG, info_table, tms, target, category)

    if tms == "True"
        info_table = info_table(info_table.TMS == 1,:);
        sufix = '_t';
    elseif tms == "False"
        info_table = info_table(info_table.TMS == 0,:);
        sufix = '_f';
    end

    if target == "Tongue"
        info_table = info_table(strcmpi(info_table.TMStarget, 'tongue'),:);
        sufix = [sufix 't'];
    elseif target == "Lip"
        info_table = info_table(strcmpi(info_table.TMStarget, 'lip'),:);
        sufix = [sufix 'l'];
    end
    
    if category == "Bilabial"
        info_table = info_table(strcmpi(info_table.Category, 'bilabial'),:);
        sufix = [sufix 'b'];
    elseif category == "Alveolar"
        info_table = info_table(strcmpi(info_table.Category, 'alveolar'),:);
        sufix = [sufix 'a'];
    end

    table_size = size(info_table);
    number_events = table_size(1);

    events = {};
    events.base_line = info_table.Base_Line;
    events.task_onset = info_table.Onset_TSidx;
    events.tms_1 = info_table.TMS0_TSidx;
    events.tms_2 = info_table.TMS_TSidx;
    events.stim_1 = info_table.P1_TSidx;
    events.stim_2 = info_table.P2_TSidx;
    events.task_final = info_table.Final_TSidx;

    events_types = fieldnames(events);
    for type = 1:length(events_types)
        for index = 1:number_events 
            EEG.event(end+1).latency = events.(events_types{type})(index);
            EEG.event(end).type = string(events_types{type}) + sufix;
        end
    end
   
    EEG = eeg_checkset(EEG, 'eventconsistency'); % Check all events for consistency
end