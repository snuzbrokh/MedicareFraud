# MedicareFraud

This is the repository for my project to investigate claim fraud in medicare data. 
This was my capstone project at the NYC Data Science Academy. 

Dataset can be found [here](https://www.kaggle.com/rohitrox/healthcare-provider-fraud-detection-analysis).

[Blog Post](https://nycdatascience.com/blog/student-works/predicting-fraudulent-health-insurance-claims/)

[Personal portfolio](https://www.databough.com/art)


Largest Duplication Network found in the Claim Data - Corresponding to NYC metro area. 
![pic](https://github.com/snuzbrokh/MedicareFraud/blob/master/visualizations/networks/outpatientdup_largest.png)

## Brief Directory Descriptions

Below is a brief description of each directory in this repo:
 - [network_EDA](https://github.com/snuzbrokh/MedicareFraud/tree/master/network_EDA): Exploratory Data Analysis using networks. 
 - [scripts](https://github.com/snuzbrokh/MedicareFraud/tree/master/scripts): Contains various preprocessing scripts. 
 - [notebooks](https://github.com/snuzbrokh/MedicareFraud/tree/master/notebooks): Contains notebooks used in the project. 
 - [visualizations](https://github.com/snuzbrokh/MedicareFraud/tree/master/network_EDA): Contains visualizations used in the project.

## Brief Code File Descriptions
Below is a brief description of each code file in this repo:
 - [claimTrack.py](https://github.com/snuzbrokh/MedicareFraud/blob/master/scripts/claimTrack.py): Finds duplicate records within the claim data and writes to csv associated features of interest. 
 - [consolidate.py](https://github.com/snuzbrokh/MedicareFraud/blob/master/scripts/consolidate.py): Combines beneficiary, inpatient claim, and outpatient claims into one dataset. Also does preprocessing and feature engineering on the claim level. 
 - [provider.py](https://github.com/snuzbrokh/MedicareFraud/blob/master/scripts/provider.py): Takes in the consolidated claim data and aggregates features to the provider level. 
