# CODES

The codes provided were used for the technical validation using only the phoneme pair tasks. The analyzes focused only on differentiating control and the two TMS regions. 
However, the routine was written to be modified, like many comments and tips.

## 1. **analysis.m**

This is the main code that conducts the analysis following the pipeline described in Figure 1 (repository README.md). In it, each processing step is saved as a checkpoint and 
pictures of the signal state are generated for analysis tracking. At the end, a report of the manual modifications made can also be generated, 
as well as the ERP and PSD signal obtained for each channel.

### 1.1 create_events.m

This is a function that generates the events to be considered in the data processing and analysis (stimuli, test start, test end) from the information tables provided 
in each participant's database (.csv file).

### 1.2 select_trials_subset.m

This function separates, based on the events defined by the function described above, the type of task to be studied in a given analysis (control, TMS on tongue or lip 
target, TMS on tongue or lip target with bilbial or alveolar).

### 1.3 plot_results.m

This function is responsible for generating and saving the pipeline graphs. ERP, PSD and ERP charts with topographic representation have been implemented so far.

## 2. **group_results.m**

If the analysis is followed according to the pipeline and the correct directories are compatible, it is possible to run this routine to group and analyze the ERP and 
PSD of all participants. This was the code used to produce the results of the technical validation.

### 2.1 plot_results.m

This function is responsible for generating and saving the group analysis graphs. General ERP, ERP per participant, general PSD and ways to see the channels 
distribuitions have been implemented so far.
