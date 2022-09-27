# An open-access EEG dataset for speech decoding: Exploring the role of articulation and coarticulation

$$
\author[1,$\dag$]{Vinícius Rezende Carvalho}
\author[1]{Eduardo Mazoni Andrade Marçal Mendes}
\author[2]{Ariah Fallah}
\author[3,4,5]{Terrence J. Sejnowski}
\author[3,4]{Claudia Lainscsek}
\author[2,6,*,$\dag$]{Lindy Comstock}
\affil[1]{Postgraduate Program in Electrical Engineering, Federal University of Minas Gerais, Belo Horizonte, MG 31270-901, Brazil}
\affil[2]{Department of Neurosurgery, University of California, Los Angeles, Los Angeles, CA 90095, USA}
\affil[3]{Computational Neurobiology Laboratory, The Salk Institute for Biological Studies, La Jolla, CA 92037, USA}
\affil[4]{Institute for Neural Computation University of California San Diego, La Jolla, CA 92093, USA}
\affil[5]{Division of Biological Sciences, University of California San Diego, La Jolla, CA 92093, USA}
\affil[6]{Department of Linguistics, National Research University Higher School of Economics, Moscow 101000, RF}
$$

## ABSTRACT

Electroencephalography (EEG) holds promise for brain-computer interface (BCI) devices as a non-invasive measure of neural activity. With increased attention to EEG-based BCI-systems, publicly available datasets that can represent the complex tasks required for naturalistic speech decoding are necessary to establish a common standard of performance within the BCI community. Effective solutions must overcome noise in the EEG signal and remain reliable across sessions and subjects without overfitting to a specific dataset or task. We present two validated datasets (N=8 and N=16) for classification at the phoneme and word level and by the articulatory properties of phonemes. EEG signals were recorded from 64 channels while subjects listened to and repeated six consonants and five vowels. Individual phonemes were combined in different phonetic environments to produce coarticulated variation in forty consonant-vowel pairs, twenty real words, and twenty pseudowords. Phoneme pairs and words were presented during a control condition and during transcranial magnetic stimulation targeted to suppress or augment the EEG signal associated with specific articulatory processes.

## CODE AVAILABILITY

The codes used for the production of this work were made available in the [OSF](https://osf.io/e82p9/) and [GithHub](https://github.com/mcjpedro/speech_decoding) repositories as a way to allow reproducibility and sharing of information. In the former, the routines are in the EEG_Data_Processing folder and are responsible for the analyses available in the technical validation section. Also available in the same folder are the results obtained in two different signal processing steps, as discussed in section Z. In the second one, the same code is available, however it is located in a platform that allows version control and more resources for discussing the implementation and the analysis done. 

The routines set up to obtain the ERP using only ICA signal cleaning were done using the pipeline described in Figure 1, based on the EEGLab library versions 2022.0 and 2022.1 native to MATLAB.

![alt text](https://github.com/mcjpedro/speech_decoding/blob/main/code_structure.png?raw=true)
**Figure 1** - Code structure to data processing.
