function [save_subfolder, sufix, events] = select_trials_subset(category, with_tms, with_task)

if with_tms == "False" && with_task == "True"
    if category == "C" 
        save_subfolder = "\\control\\";
        sufix = "_c";
        events = {'stim_1_fa', 'stim_1_fb'};
    elseif category == "L"
        save_subfolder = "\\tms_true_lip\\";
        sufix = "_tl";
        events = {'stim_1_tla', 'stim_1_tlb'};
    elseif category == "T"
        save_subfolder = "\\tms_true_tongue\\";
        sufix = "_tt";
        events = {'stim_1_tta', 'stim_1_ttb'};
    elseif category == "CA"
        save_subfolder = "\\control_alveolar\\";
        sufix = "_ca";
        events = {'stim_1_fa'}; 
    elseif category == "CB"
        save_subfolder = "\\control_bilabial\\";
        sufix = "_cb";
        events = {'stim_1_fb'}; 
    elseif category == "LA"
        save_subfolder = "\\tms_true_lip_alveolar\\";
        sufix = "_tla";
        events = {'stim_1_tla'}; 
    elseif category == "LB"
        save_subfolder = "\\tms_true_lip_bilabial\\";
        sufix = "_tlb";
        events = {'stim_1_tla'}; 
    elseif category == "TA"
        save_subfolder = "\\tms_true_tongue_alveolar\\";
        sufix = "_tta";
        events = {'stim_1_tta'}; 
    elseif category == "TB"
        save_subfolder = "\\tms_true_tongue_bilabial\\";
        sufix = "_ttb";
        events = {'stim_1_ttb'}; 
    end
elseif with_tms == "True" && with_task == "True"
    if category == "C" 
            save_subfolder = "\\control\\";
            sufix = "_c";
            events = {'base_line_fa', 'base_line_fb'};
    elseif category == "L"
            save_subfolder = "\\tms_true_lip\\";
            sufix = "_tl";
            events = {'base_line_tla', 'base_line_tlb'};
    elseif category == "T"
            save_subfolder = "\\tms_true_tongue\\";
            sufix = "_tt";
            events = {'base_line_tta', 'base_line_ttb'};
    elseif category == "CA"
            save_subfolder = "\\control_alveolar\\";
            sufix = "_ca";
            events = {'base_line_fa'}; 
    elseif category == "CB"
            save_subfolder = "\\control_bilabial\\";
            sufix = "_cb";
            events = {'base_line_fb'}; 
    elseif category == "LA"
            save_subfolder = "\\tms_true_lip_alveolar\\";
            sufix = "_tla";
            events = {'base_line_tla'}; 
    elseif category == "LB"
            save_subfolder = "\\tms_true_lip_bilabial\\";
            sufix = "_tlb";
            events = {'base_line_tla'}; 
    elseif category == "TA"
            save_subfolder = "\\tms_true_tongue_alveolar\\";
            sufix = "_tta";
            events = {'base_line_tta'}; 
    elseif category == "TB"
            save_subfolder = "\\tms_true_tongue_bilabial\\";
            sufix = "_ttb";
            events = {'base_line_ttb'}; 
    end
elseif with_tms == "False" && with_task == "False"
    if category == "C" 
        save_subfolder = "\\control\\";
        sufix = "_c";
        events = {'stim_1_f'};
    elseif category == "L"
        save_subfolder = "\\tms_true_lip\\";
        sufix = "_tl";
        events = {'stim_1_tl'};
    elseif category == "T"
        save_subfolder = "\\tms_true_tongue\\";
        sufix = "_tt";
        events = {'stim_1_tt'};
    end
elseif with_tms == "True" && with_task == "False"
    if category == "C" 
            save_subfolder = "\\control\\";
            sufix = "_c";
            events = {'base_line_f'};
    elseif category == "L"
            save_subfolder = "\\tms_true_lip\\";
            sufix = "_tl";
            events = {'base_line_tl'};
    elseif category == "T"
            save_subfolder = "\\tms_true_tongue\\";
            sufix = "_tt";
            events = {'base_line_tt'};
    end
end       
end