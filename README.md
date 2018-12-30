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

## Data Preparation
Some of our data prep is outlined above, but generally we spent a lot of time mapping our data to census tract or zip code.  Initially we thought that a regression problem would be the obvious fit for this challenge, but we decided to prepare the data for a classification problem instead.  Looking at the data, the distribution of counts by census tract/school year/grade level looks almost geometric, with a significant number of tracts with zero students, as shown in Figure 1

| Figure 1 | |
| ------------- | ------------- |
| ![figure 1](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/CensusTractCounts.png) | ![figure 1](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/CensusTractCountsBelow10.png) |

We were concerned that a regression where such a large number of tracts have zero population would produce noisy results, or results that make no sense.  For example, the regression may return a negative number of students for a specific census tract, or if it has a 95% confidence interval of +/- 3 students, then any result given on a tract with a small number of students to begin with is essentially a guess.  

As such, we focused on classifying whether a census tract would increase the total number of students or not so we prepared our data with that as our target variable.   We started with 1 year change, but we can easily modify our target for 2, 3, 4, or 5 years and re-run our analysis.  

## Feature Engineering:
Once we chose our target, we built a baseline model engineered exclusively from the given data set.  For our baseline model, we used very simple features, including Count, Total Count, Total Count by Grade, and Total Count By Tract.  The totals are for the entire district.  Using a decision tree classifier and ranking on entropy, we found the feature importance ranking shown in Figure 2.  Figure 3 shows features ranked by accuracy.   

| Figure 2 | Figure 3 |
| ------------- | ------------- |
| ![Figure 2](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/BaselineModel.png) | ![Figure 3](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/BaselineModelFeatures.png) |

Figure 4 shows an analysis of Area Under the ROC curve for decision matrix, logistic regression, and support vector machine.  Logistic regression seems to be the best algorithm, but we kept all three as we tuned more parameters and features.

| Figure 4 |
| ------------- |
| ![Figure 4](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/BaselineAUCROC.png) |

*The purpose of our baseline was to have something to compare against and improve upon.  Since eliciting features from external sources was proving to be difficult, we next engineered several features from the existing dataset as a starting point. The initial set of engineered features follows:*  
#*TotalCount = Total number of students for a given year across all tract and grade*  
#*TotalCountByGrade = Total number of students for a given year and grade across all tract*  
#*TotalCountByTract = Total number of students for a given year and tract across all grade*  
#*TotalCountByZip = Total number of studetns for a given year and zip across all grade*  
#*TotalCountByZipGrade = Total number of students for a given year, zip and grade*  
#*TotalCountByTractGrade = Same as Count // can be removed*  
#*PrevGradeCount = Total number of students from prior grade for a given year and tract*  
#*e.g, for year 2010, tract 18, grade 5, its PrevGradeCount will be Count from year 2010, tract 18 and grade 4*  
#*PrevGradeCountmavg3 = 3 year average of PrevGradeCount*  
#*PrevGradeCountmavg5 = 5 year average of PreveGradeCount*  
#*OneYearGrowth = one year growth rate of Count for a given tract and grade*  
#*ThreeYearGrowth = three year growth rate of Count for a given tract and grade*  
#*OneYearGrowthmavg3 = 3 year average of OneYearGrowth*  
#*ThreeYearGrowthmavg3 = 3 year average of ThreeYearGrowth*  
#*Y = Target variable 1 = Increase in count in the next year, 0 = decrease/stay the same in the next year*  
#*NeighborCount = Total number of students in the six closest geographic tracts for a given year and tract and grade*  
#*NeighborThreeYearGrowthmavg = Combined 3 year average of PrevGradeCount*  
#*NeighborThreeYearGrowth = Total number of students for a given year across all tract and grade*


