% EEG DATA ANALYSIS 29-Aug-2022
% João Pedro Carvalho Moreira
% mcjpedro@gmail.com

%% SET THE ENVIRONMENT

% Sets all importatnt folders that are need to do the analysis

clear
clc

% Open a dialog to select the subject folder
save_folder = uigetdir('', 'Select the folder to save the code outputs');
[table_file_name, table_file_path] = uigetfile('*.csv', 'Select the table with the events');

% The info file used here is the same one used to set the events in BIDS 
% format. It can be loaded from the GitHub repository file 
% 'events_information'.

% Display the defined values
fprintf('Save Folder: %s\n', save_folder);
fprintf('Info Table File: %s\n', info_table_file);

%% CREATE FOLDERS (FOR NEW ANALYSIS)

% Creates folders to save the analysis

mkdir(save_folder);
mkdir(save_folder + "\\control");
%mkdir(save_folder + "\\control_alveolar");
%mkdir(save_folder + "\\control_bilabial");
mkdir(save_folder + "\\tms_true_lip");
%mkdir(save_folder + "\\tms_true_lip_alveolar");
%mkdir(save_folder + "\\tms_true_lip_bilabial");
mkdir(save_folder + "\\tms_true_tongue");
%mkdir(save_folder + "\\tms_true_tongue_alveolar");
%mkdir(save_folder + "\\tms_true_tongue_bilabial");

eeglab

%% LOAD FILES

% Loads the .set (descriotive folder)

[file_name, path_name, ~] = uigetfile({'*.set'}, 'Select recording');       % Opens a pop-up to folder selection

[ALLEEG, ~, ~, ALLCOM] = eeglab;                                            % Opens EEGLab window
EEG = pop_loadset('filename',file_name,'filepath',path_name);               % Opens a .set file
[ALLEEG, EEG, ~] = eeg_store(ALLEEG, EEG, 0);                      % Stores the .set file into a EEGLab datset
EEG = eeg_checkset( EEG );                                                  % Checks the current dataset

eeglab redraw;                                                              % Updates the interface

%% EVENTS SETTINGS AND DATA REJECTION

% Reads the info table and sets the events on the data

sample_frequency = EEG.srate;                                               % Gets the samplnig frequency

info_table = readtable(info_table_file);                                    % Gets the info table
phonemes_task_rows = find(string(info_table.Task) == "phonemes");           % Gets the "phonemes" index
info_table = info_table(phonemes_task_rows,:);                              % Gets only the "phonemes" tasks

info_table.Base_Line = info_table.P1_TSidx - 0.5*sample_frequency;          % The base line interval is 500ms before the fisrt audiotry stimulus (P1_TSidx)
info_table.Onset_TSidx = info_table.P1_TSidx - 0.2*sample_frequency;        % The onset is 200ms before the fisrt audiotry stimulus (P1_TSidx)
info_table.TMS0_TSidx = info_table.P1_TSidx - 0.1*sample_frequency;         % The first TMS is 100ms the fisrt audiotry stimulus (P1_TSidx)
info_table.TMS_TSidx = info_table.P1_TSidx - 0.05*sample_frequency;         % The first TMS is 100ms the fisrt audiotry stimulus (P1_TSidx)
info_table.Final_TSidx = info_table.P1_TSidx + sample_frequency;            % Each trial ends 1 second after the first audiotry stimulus (P1_TSidx)

EEG = create_events(EEG, info_table, 'True', 'Tongue', 'None');             % Creates events: TMS on tongue target
%EEG = create_events(EEG, info_table, 'True', 'Tongue', 'Bilabial');         % Creates events: TMS on tongue target to "bilabial" tasks
%EEG = create_events(EEG, info_table, 'True', 'Tongue', 'Alveolar');         % Creates events: TMS on tongue target to "alveolat" tasks

EEG = create_events(EEG, info_table, 'True', 'Lip', 'None');                % Creates events: TMS on lip target
%EEG = create_events(EEG, info_table, 'True', 'Lip', 'Bilabial');            % Creates events: TMS on LIP target to "bilabial" tasks
%EEG = create_events(EEG, info_table, 'True', 'Lip', 'Alveolar');            % Creates events: TMS on tongue target to "alveolar" tasks

EEG = create_events(EEG, info_table, 'False', 'None', 'None');              % Create events: control
%EEG = create_events(EEG, info_table, 'False', 'None', 'Bilabial');          % Creates events: control to "bilabial" tasks
%EEG = create_events(EEG, info_table, 'False', 'None', 'Alveolar');          % Creates events: control to "alveolar" tasks
 
name = char(fullfile(save_folder, [subject '_1_set_events.set']));
[ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 2,'setname','Set events',...
    'savenew', name, 'gui','off');                                                           % Saves the data

eeglab redraw;

%% BAD TMS SEGMENTS INTERPOLATION 

% Interpolates a part of the signal (relatives to setted events) 

tms_true_rows = find(info_table.TMS == 1);                                  % Gets only the TMS true index from info table
tms_true_index = info_table.TMS0_TSidx(tms_true_rows);                      % Gets only the first TMS stimulation 
tms_true_index = [tms_true_index; info_table.TMS_TSidx(tms_true_rows)];     % Gets only the both TMS stimulations
tms_index = [];                                                             % Creates a empty vector

for index = tms_true_index'                                                                 % Runs through all TMS events
    tms_interval = (index - 0.005*sample_frequency):(index + 0.025*sample_frequency);     % In the interval 0.007s around all TMS stimulus
    EEG.data(:,tms_interval) = nan;                                                         % Fills with NaNs
end

for channel = 1:EEG.nbchan
    disp("Bad TMS ringing/step artifect removed from channel " + string(channel));
    EEG.data(channel,:) = fillgaps(double(EEG.data(channel,:)), 0.25*sample_frequency, 25);
end
 
name = char(fullfile(save_folder, [subject '_2_tms_interpolated.set']));
[ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 3,'setname','Interpolate TMS true','savenew', name,'gui','off'); 

eeglab redraw;

%% SAVE STAGE FIGURE

% Creates figures that describes the current data analysis state 

stage = "After Removing TMS Ringing/Step Artifect";
save_file = char(fullfile(save_folder, [subject '_2_tms_interpolated']));
plot_results(EEG, 1, 0, 0, 1, save_file, stage, "False");

%% RESAMPLE, NOTCH FILTER AND BANDPASS FILTER

% Applies filters and resample the data

EEG = pop_resample( EEG, 128);                                              % Resemple the data to 256Hz
sample_frequency = EEG.srate;                                               % Gets the samplnig frequency 

%EEG = pop_eegfiltnew(EEG, 'locutoff',59,'hicutoff',61,'revfilt',1);
EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',50); 

name = char(fullfile(save_folder, [subject '_3_filtered_data.set']));
[ALLEEG, EEG, ~] = pop_newset(ALLEEG, EEG, 4,'setname','Filtered data','savenew', name,'gui','off');  
EEG = eeg_checkset( EEG );

eeglab redraw;

%% SAVE STAGE FIGURE

% Creates figures that describes the current data analysis state 

stage = "After Filtering and Resampling";

save_file = char(fullfile(save_folder, [subject '_3_filtered_data']));
plot_results(EEG, 1, 0, 0, 1, save_file, stage, "False");

%% TRIALS SEPARATION

% Possible trials categories
% - stim_1_f: Control (C)
% - stim_1_fa: Control alveolar (CA)
% - stim_1_fb: Control bilabial (CB)
% - stim_1_tl: TMS on lip (L)
% - stim_1_tla: TMS on lip alveolar (LA)
% - stim_1_tlb: TMS on lip bilabial (LB)
% - stim_1_tt: TMS on tongue (T)
% - stim_1_tta: TMS on tongue alveolar (TA)
% - stim_1_ttb: TMS on tongue bilabial (TB)

category = "C";
with_tms = "False";
with_task = "False";
[save_subfolder, sufix, events] = select_trials_subset(category, with_tms, with_task);

EEG = pop_epoch(EEG, events, [0 1], 'newname', 'Epochs', 'epochinfo', 'yes');
EEG = pop_rmbase(EEG, [] ,[]);
name = char(fullfile(save_folder, [subject '_4_set_trials' sufix '.set']));
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'setname','Set trials','savenew', name,'gui','off'); 
EEG = eeg_checkset( EEG );

%%

pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );

eeglab redraw;

% In the end of this section, you need to select the bad trials and delete
% them. To do this, follow the instructions below:
%   - Click "Plot"
%   - Click "Channel data (scroll)"
%   - Select by eye the bad trials
%   - Delete them by clicking "Reject"
%   - Rename the dataset as "Remove bad trials" and save as "SOX_5_remove_bad_trials.set" the modification

%% REPORT THE BAD TRIALS

bad_trials_1 = extractBetween(EEG.history, "pop_rejepoch( EEG, [", "]");
bad_trials_1 = bad_trials_1(end);
fprintf("Removed trials in the first inspection: ");
fprintf(string(bad_trials_1));
fprintf("\n");

%% SAVE STAGE FIGURE

stage = "After Removing Bad Trials - " + category;
save_file = char(fullfile(save_folder, save_subfolder, [subject '_5_remove_bad_trials' sufix]));
plot_results(EEG, 1, 1, 1, 1, save_file, stage, "False");

%% ICA DECOMPOSITION

EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1, 'interrupt', 'on');
[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset(EEG);
name = char(fullfile(save_folder, [subject '_6_ica_decomposition' sufix '.set']));
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'setname','ICA components','savenew',name,'gui','off');
pop_selectcomps(EEG, 1:35);

% In the end of this section, you need to select the bad ICA components and delete
% them. To do this, follow the instructions below:
%   - Click "Tools"
%   - Click "Inspect/label components by map"
%   - Select by eye the bad components (blink, muscle, TMS artifacts)
%   - Delete them by clicking "Tools/Remove components from data"
%   - Rename the dataset as "Remove bad components" and save as "SOX_7_remove_bad_components.set" the modification

%% REPORT THE BAD COMPONENTS 

bad_components_1 = extractBetween(EEG.history, "pop_subcomp( EEG, [", "], 0");
bad_components_1 = bad_components_1(end);
fprintf("Removed ICA components in the first inspection: ");
fprintf(string(bad_components_1));
fprintf("\n");

%% SAVE STAGE FIGURE

stage = "After Removing Bad ICA Components - " + category;
save_file = char(fullfile(save_folder, save_subfolder, [subject '_7_remove_bad_components' sufix]));
plot_results(EEG, 1, 1, 1, 1, save_file, stage, "False");

%% REMOVE BAD TRIALS 2

pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );

eeglab redraw;

% In the end of this section, you need to select the bad trials and delete
% them. To do this, follow the instructions below:
%   - Click "Plot"
%   - Click "Channel data (scroll)"
%   - Select by eye the bad trials
%   - Delete them by clicking "Reject"
%   - Rename the dataset as "Remove bad trials" and save as "SOX_8_remove_bad_trials_2.set" the modification

%% REPORT THE BAD TRIALS

bad_trials_2 = extractBetween(EEG.history, "pop_rejepoch( EEG, [", "] ,0");
bad_trials_2 = bad_trials_2(end);
%bad_trials_2 = "None";
fprintf("Removed trials in the second inspection: ");
fprintf(string(bad_trials_2));
fprintf("\n");

%% SAVE STAGE FIGURE

stage = "After Removing Bad Trials Twice - " + category;
save_file = char(fullfile(save_folder, save_subfolder, [subject '_8_remove_bad_trials_2' sufix]));
plot_results(EEG, 1, 1, 1, 1, save_file, stage, "False");

%% ICA DECOMPOSITION 2

EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1, 'interrupt', 'on');
[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset(EEG);
name = char(fullfile(save_folder, [subject '_9_ica_decomposition_2' sufix '.set']));
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 9,'setname','ICA components 2','savenew',name,'gui','off');
pop_selectcomps(EEG, 1:35);

% In the end of this section, you need to select the bad ICA components and delete
% them. To do this, follow the instructions below:
%   - Click "Tools"
%   - Click "Inspect/label components by map"
%   - Select by eye the bad components (blink, muscle, TMS artifacts)
%   - Delete them by clicking "Tools/Remove components from data"
%   - Rename the dataset as "Remove bad components 2" and save as "SOX_7_remove_bad_components_2.set" the modification

%% REPORT THE BAD COMPONENTS 

bad_components_2 = extractBetween(EEG.history, "pop_subcomp( EEG, [", "], 0);");
bad_components_2 = bad_components_2(end);
%bad_components_2 = "None";
fprintf("Removed ICA components in the first inspection: ");
fprintf(string(bad_components_2));
fprintf("\n");

%% SAVE STAGE FIGURE

stage = "After Removing Bad ICA Components Twice - " + category;
save_file = char(fullfile(save_folder, save_subfolder, [subject '_10_remove_bad_components_2' sufix]));
plot_results(EEG, 1, 1, 1, 1, save_file, stage, "False");

%% SAVE FINAL STAGE FIGURE

stage = "Final Result";
save_file = char(fullfile(save_folder, save_subfolder, [subject '_final' sufix]));
plot_results(EEG, 1, 1, 1, 1, save_file, stage, "True");

%% SAVE REPORT

category = "C";

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

name = char(fullfile(save_folder, save_subfolder,  [subject '_report' sufix '.txt']));
report_file = fopen(name, 'w');
fprintf(report_file,"Removed trials in the first inspection: ");
fprintf(report_file, string(bad_trials_1));
fprintf(report_file,"\n");
fprintf(report_file,"Removed ICA components in the first inspection: ");
fprintf(report_file, string(bad_components_1));
fprintf(report_file,"\n");
fprintf(report_file,"Removed trials in the second inspection: ");
fprintf(report_file, string(bad_trials_2));
fprintf(report_file,"\n");
fprintf(report_file,"Removed ICA trials in the second inspection: ");
fprintf(report_file, string(bad_components_2));
fprintf(report_file,"\n");
fprintf(report_file,"\n");
fprintf(report_file,"Observation: ");

fprintf("\nDone!\n")

%% TO TRY

tmp = reshape(EEG.data, [size(EEG.data, 1) size(EEG.data, 2) * size(EEG.data, 3)]); 
tmp = zscore(tmp, 0, 2); 
tmp = reshape(tmp, size(EEG.data)); 
EEG.data = tmp;

fprintf("OK")


