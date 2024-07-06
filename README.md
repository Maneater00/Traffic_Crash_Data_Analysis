# Traffic_Crash_Data_Analysis
Project for Traffic_Crash_Data_Analysis on FARS Data


# FARS2022 Traffic Crash Data Analysis

## Overview
This repository contains the SAS program and datasets for a comprehensive analysis of traffic crash data from the Fatality Analysis Reporting System (FARS) for the year 2022. The analysis includes data cleaning, exploratory data analysis, visualizations, statistical tests, and predictive modeling to gain insights into traffic crash patterns and factors contributing to crash severity.

## Datasets
The following datasets are included in this repository:
- `accident.sas7bdat`
- `cevent.sas7bdat`
- `crashrf.sas7bdat`
- `damage.sas7bdat`
- `distract.sas7bdat`
- `drimpair.sas7bdat`
- `driverrf.sas7bdat`
- `drugs.sas7bdat`
- `factor.sas7bdat`
- `maneuver.sas7bdat`
- `nmcrash.sas7bdat`
- `nmdistract.sas7bdat`
- `nmimpair.sas7bdat`
- `nmprior.sas7bdat`
- `parkwork.sas7bdat`
- `pbtype.sas7bdat`
- `person.sas7bdat`
- `personrf.sas7bdat`
- `pvehiclesf.sas7bdat`
- `race.sas7bdat`
- `safetyeq.sas7bdat`
- `vehicle.sas7bdat`
- `vehiclesf.sas7bdat`
- `vevent.sas7bdat`
- `violatn.sas7bdat`
- `vision.sas7bdat`
- `vpicdecode.sas7bdat`
- `vpictrailerdecode.sas7bdat`
- `vsoe.sas7bdat`
- `weather.sas7bdat`
- `miacc.sas7bdat`
- `midrvacc.sas7bdat`
- `miper.sas7bdat`

## SAS Program
The SAS program, named `FARS2022_Traffic_Crash_Analysis.sas`, performs the following tasks:
1. **Data Import**: Imports all datasets from GitHub.
2. **Data Cleaning**: Handles missing values and outliers.
3. **Merging Datasets**: Combines relevant datasets based on common keys.
4. **Exploratory Data Analysis**: Provides summary statistics, frequency distributions, and visualizations.
5. **Statistical Analysis**: Performs correlation analysis, hypothesis testing, regression analysis, logistic regression, clustering, principal component analysis, and decision tree modeling.
6. **Reporting**: Generates detailed reports in PDF format.
