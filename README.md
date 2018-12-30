# NYUDataScience1001-edTech

## Problem Definition:

[NYC Deptartment Of Education - Call for Innovation](http://www.nyc.gov/html/cfi/html/DOE/index.html#collapse1)  
NYC Department of Education
Predictive Model for Population Growth Business Case

## Project Business Justification 	
This project will be submitted to a competition with the NYC Department of Education.  The New York City Department of Education is the largest school district in the United States, serving 1.1 million students over 1,800 schools.  In this call for innovations, the city is looking for data scientists and enthusiasts to help build new data models and predictive tools to accurately project future public school student population trends and changes in communities.

Since 2010, the city population has grown 4.6%, the highest rate of growth since the 1920’s.  These trends make it very important to predict trends for accommodating the rapidly growing Pre-K – 12 student population.  The competition requirements ask for projections of counts of students residing within each census tract within School District 20 enrolled in any of the school years between 2011-2012 and 2016-2017 in any grade K-5.

This data would be used for funding decisions and allocating resources to Pre-K districts.



## Project Description 
The city needs help projecting the number of prospective students at different age groups by city block with projections at 1-year, 2-year and 5-year increments.

## Project Details
**Data Understanding:**
The dataset included contained counts of DOE students:  
●	Enrolled in any of the school years between 2001-2002 and 2010-2011  
●	Enrolled in a public school  
●	Resided in census tracts located within Community School District 20  
●	Enrolled in any grade K-5  
The given data set includes 4 fields:  

|   |  |
| ------------- | ------------- |
| 2010 Census Tract  | A census tract is essentially a city block.  |
| School Year  |  |
| Grade Level  | K through 5 |
| Count of Students  | Based on audited register as of October 31st of the given school year. |



In addition to the data provided, we scraped the internet for additional leads including the following:  
●	[Census Birth Data](http://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml)  
●	[Child Care Center Data](https://data.ny.gov/Human-Services/Child-Care-Regulated-Programs-Map/s8uq-s4wq)  
●	[Zillow Housing Data](http://www.zillow.com/research/data/)  
●	[Other Housing and Demographic Data](http://datasearch.furmancenter.org/)  
●	[311 Data](https://nycopendata.socrata.com/)  

The above datasets are specifically plagued with various issues, most notably missing years or not being able to drill down to census tract granularity consistent with the provided dataset.  As an example, we contacted Zillow for a more granular view into Kings County data and were told that our request would violate their terms of service.  The only data that is available on the census tract level is data on foreclosure rates, but conspicuously a lot of the demographic data available from the Furman Center is missing 2008 and does not include data before 2005.  The child care data only includes center openings and closings, which may produce useful features or may not.  We decided this was a stretch and opted not to pursue.  

The 311 data was our best lead, but was massive and required considerable work to extract features.  Using Python, we connected to the Census Geographic Services API to extract Census Tract based on latitude/longitude of each ticket.  This took several days of computing.  From there, we moved on to extracting features from each request.  We found that Microsoft SQL Server performed our feature extraction scripts several orders of magnitude faster than iPython Notebooks for this task.  Using SQL Scripts, we dynamically generated features based on latitude and longitude, 311 ticket category, the count of each of these categories by tract and year, and the running year over year averages.  

We extracted features for 2006-2010 based on the category of 311 ticket and ended up with more than 1024 features.   SQL Server can only handle tables with 1024 columns so we stopped there.  At this point due to time constraints, before downloading the data from 2001-2005, we focused our efforts on our baseline and features that we engineered from the original dataset to see if the “cost” of extracting the 2001-2005 data would be worth the effort.

As outlined in the Data Preparation section, by engineering the data provided by the contest, we were able to extract favorable features that resulted in surprisingly good AUC scores.  With this discovery, we ultimately decided that the effort required engineering features based on the provided data set would provide more utility and value than scraping, cleaning, and engineering external data and scrapped all other leads.  More info on how we came to this conclusion is outlined in the data preparation section below.


**Data Instance:**
Annual school aged population by city block 

**Target Variable:**  
* **Detail** the number of prospective students at different age groups by city block with projections at 1-year, 2-year and 5-year increments.  We probably need a separate model for each age group/projection. 
* **Variable** population

**Features:**

From 
[Child Care Data Set](https://data.ny.gov/Human-Services/Child-Care-Regulated-Programs-Map/s8uq-s4wq )    
* Facility Opened Date (# of new facilities each year) 
* Facility Status (# of facilities each year) 
* Increase/Decrease in # of facilities from previous year 
* Total Infant Capacity each year 
* Total Toddler Capacity each year 
* Total Preschool Capacity each year 
* School Aged Capacity each year 
* Increase/Decrease in each capacity type each year
From [NYC Home Sales Data](http://www1.nyc.gov/site/finance/taxes/property-annualized-sales-update.page) 
* Median Home Value each year 
* YoY Median Home Value 
* 5 Year Diff 
* 10 Year Diff 



### Other Data:
**Housing Maintenance Code Violations:** https://data.cityofnewyork.us/Housing-Development/Housing-Maintenance-Code-Violations/wvxf-dwi5  
**Child Care Center Info:**  https://data.ny.gov/Human-Services/Child-Care-Regulated-Programs-Map/s8uq-s4wq  
**Grade School Assessment:** https://data.nysed.gov/downloads.php  
**Zillow:** Time Series home and rental prices: http://www.zillow.com/research/data/#median-home-value  

## To Be Determined:
### Problem Type: 
### Evaluation Metric:
### Training Data: 
* How are we sampling?  

### Testing Data:
