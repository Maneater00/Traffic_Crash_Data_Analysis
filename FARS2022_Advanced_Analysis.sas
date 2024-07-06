/* Defining the base URL for the raw content in repository */
%let base_url = https://github.com/Maneater00/Traffic_Crash_Data_Analysis/new/main;

/* List of datasets to be imported */
%let datasets = accident cevent crashrf damage distract drimpair driverrf drugs factor maneuver nmcrash nmdistract nmimpair nmprior parkwork pbtype person personrf pvehiclesf race safetyeq vehicle vehiclesf vevent violatn vision vpicdecode vpictrailerdecode vsoe weather miacc midrvacc miper;

/* Macro to import datasets */
%macro import_datasets(base_url, datasets);
    %local i dataset;
    %do i = 1 %to %sysfunc(countw(&datasets));
        %let dataset = %scan(&datasets, &i);
        filename &dataset url "&base_url.&dataset..sas7bdat";
        proc import datafile=&dataset
            out=&dataset
            dbms=sas
            replace;
        run;
    %end;
%mend;

/* Call the macro to import all datasets */
%import_datasets(&base_url, &datasets);

/* Data cleaning: handle missing values, outliers */
proc means data=accident n nmiss mean std min max;
    var _numeric_;
run;

proc stdize data=accident reponly method=mean out=accident_cleaned;
    var _numeric_;
run;

/* Merge datasets based on common keys, e.g., caseid */
proc sql;
    create table full_data as
    select a.*, b.*, c.*, d.*, e.*, f.*, g.*, h.*, i.*, j.*
    from accident a
    left join cevent b on a.caseid = b.caseid
    left join crashrf c on a.caseid = c.caseid
    left join damage d on a.caseid = d.caseid
    left join distract e on a.caseid = e.caseid
    left join drimpair f on a.caseid = f.caseid
    left join driverrf g on a.caseid = g.caseid
    left join drugs h on a.caseid = h.caseid
    left join factor i on a.caseid = i.caseid
    left join maneuver j on a.caseid = j.caseid;
quit;

/* Data Cleaning for the merged dataset */
proc stdize data=full_data reponly method=mean out=full_data_cleaned;
    var _numeric_;
run;

/* Exploratory Data Analysis */

/* Summary statistics */
proc means data=full_data_cleaned mean median mode std;
    var _numeric_;
run;

/* Frequency distribution for categorical variables */
proc freq data=full_data_cleaned;
    tables weather crash_severity / plots=freqplot;
run;

/* Visualization */
proc sgplot data=full_data_cleaned;
    histogram crash_severity;
    density crash_severity / type=kernel;
run;

/* Time-series analysis */
proc timeseries data=full_data_cleaned out=timeseries_data;
    id crash_date interval=month;
    var crash_count;
run;

proc sgplot data=timeseries_data;
    series x=crash_date y=crash_count / markers;
    xaxis label="Date";
    yaxis label="Number of Crashes";
run;

/* Heatmap for crash occurrences by time of day and day of week */
proc sgplot data=full_data_cleaned;
    heatmap x=time_of_day y=day_of_week / colormodel=two;
    xaxis label="Time of Day";
    yaxis label="Day of Week";
run;

/* Correlation Matrix */
proc corr data=full_data_cleaned;
    var speed alcohol_involvement driver_age crash_severity;
run;

/* Hypothesis testing: impact of weather conditions on crash severity */
proc ttest data=full_data_cleaned;
    class weather;
    var crash_severity;
run;

/* Regression analysis */
proc reg data=full_data_cleaned;
    model crash_severity = speed alcohol_involvement driver_age weather;
run;

/* Logistic Regression for predicting severe crashes */
proc logistic data=full_data_cleaned;
    model severe_crash(event='1') = speed alcohol_involvement driver_age weather seatbelt_usage;
run;

/* Cluster Analysis to identify patterns in crash data */
proc fastclus data=full_data_cleaned maxclusters=3 out=clus_out;
    var speed alcohol_involvement driver_age weather;
run;

proc sgplot data=clus_out;
    scatter x=speed y=alcohol_involvement / group=cluster;
run;

/* Principal Component Analysis */
proc princomp data=full_data_cleaned out=princomp_out;
    var speed alcohol_involvement driver_age weather;
run;

proc sgplot data=princomp_out;
    scatter x=prin1 y=prin2 / group=cluster;
run;

/* Decision Tree for predicting crash severity */
proc hpsplit data=full_data_cleaned;
    class weather seatbelt_usage;
    model crash_severity = speed alcohol_involvement driver_age weather seatbelt_usage;
    grow entropy;
    prune costcomplexity;
run;

/* Create detailed reports */
ods pdf file="traffic_crash_analysis_report.pdf";
title "Comprehensive Analysis of Traffic Crash Data";
proc report data=full_data_cleaned;
    column crash_date crash_severity weather speed alcohol_involvement driver_age seatbelt_usage;
    define crash_date / group;
    define crash_severity / analysis mean;
    define weather / group;
    define speed / analysis mean;
    define alcohol_involvement / analysis mean;
    define driver_age / analysis mean;
    define seatbelt_usage / group;
run;
ods pdf close;

