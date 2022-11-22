# An open-access EEG dataset for speech decoding: Exploring the role of articulation and coarticulation


João Pedro Carvalho Moreira<sup> 1,#</sup>, Vinícius Rezende Carvalho<sup> 1</sup>, Eduardo Mazoni Andrade Marçal Mendes<sup> 1</sup>, Ariah Fallah<sup> 2</sup>, Terrence J. Sejnowski<sup> 3,4,5</sup>, Claudia Lainscsek<sup> 3,4</sup>, Lindy Comstock<sup> 2,6,*,#</sup><br>

<sup>1</sup> Postgraduate Program in Electrical Engineering, Federal University of Minas Gerais, Belo Horizonte, MG 31270-901, Brazil<br>
<sup>2</sup> Department of Neurosurgery, University of California, Los Angeles, Los Angeles, CA 90095, USA<br>
<sup>3</sup> Computational Neurobiology Laboratory, The Salk Institute for Biological Studies, La Jolla, CA 92037, USA<br>
<sup>4</sup> Institute for Neural Computation University of California San Diego, La Jolla, CA 92093, USA<br>
<sup>5</sup> Division of Biological Sciences, University of California San Diego, La Jolla, CA 92093, USA<br>
<sup>6</sup> Department of Linguistics, National Research University Higher School of Economics, Moscow 101000, RF<br>
<sup>*</sup> Corresponding author(s): Lindy Comstock (lbcomstock@ucla.edu)<br>
<sup>#</sup> These authors contributed equally to this work


## ABSTRACT

Electroencephalography (EEG) holds promise for brain-computer interface (BCI) devices as a non-invasive measure of neural activity. With increased attention to EEG-based BCI-systems, publicly available datasets that can represent the complex tasks required for naturalistic speech decoding are necessary to establish a common standard of performance within the BCI community. Effective solutions must overcome noise in the EEG signal and remain reliable across sessions and subjects without overfitting to a specific dataset or task. We present two validated datasets (N=8 and N=16) for classification at the phoneme and word level and by the articulatory properties of phonemes. EEG signals were recorded from 64 channels while subjects listened to and repeated six consonants and five vowels. Individual phonemes were combined in different phonetic environments to produce coarticulated variation in forty consonant-vowel pairs, twenty real words, and twenty pseudowords. Phoneme pairs and words were presented during a control condition and during transcranial magnetic stimulation targeted to suppress or augment the EEG signal associated with specific articulatory processes.

## CODE AVAILABILITY

The codes used in this work are available at [OSF](https://osf.io/e82p9/) to allow reproducibility and sharing of information. The routines are in the
Study/EEG_Data_Processing/Code folder and are responsible for the analyses available in the technical validation section. The results obtained in two different signal processing steps, as discussed in Data Processing section, are placed at the same folder 

The same code is also available on [GithHub](https://github.com/mcjpedro/speech_decoding) so as to allow version control and user’s discussion on the implementation and analysis carried I out in this work. The routines were built to obtain the ERP using only ICA and signal cleaning was performed using the pipeline described in Figure 1, based on the EEGLab library versions 2022.0 and 2022.1 native to MATLAB.

![alt text](https://github.com/mcjpedro/speech_decoding/blob/main/figures/code_structure.png?raw=true)
**Figure 1** - Code structure to data processing.
