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
