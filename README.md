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

Most engineered features revolved around 1, 3, and 5 year moving averages along with averages by district and zip code.  We also engineered several features based on longitude and latitude obtained using the Census Tract provided and Census Geographic Services API.  These features generated counts and moving averages for the six nearest Census Tracts based on distance between the lat/lng provided by the API.  The thought was that perhaps changes in the surrounding area may be predictive of the specific census tract itself.

Since all of these features were engineered from essentially an index and a target, we wanted to be sure that the each feature in the data we engineered was not just retelling the same story.  To help prove that we were not just restating the same original features in different ways, we looked at correlation coefficient of each engineered feature against every other feature.  The results can be seen in Figure 5:


| Figure 5 |
| ------------- |
| ![Figure 5](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/CorrelationMatrix.png) |

The results were obviously alarming.  There were a few highly positively correlated features that we expected.  The previous count, three year moving average, and five year moving average were highly correlated.  This makes sense and actually provides some peace of mind in that previous growth is a good indicator of future growth.   The concerning story that this data was telling us was all of the highly negatively correlated features.  What we found was that our test/train split was poorly designed and included look aheads.  With the original provided dataset, even though we were dealing with time series data, we thought it safe to split the data randomly since each row of data was independent of future and past rows.  Our engineered features, however, include data from future and past years as well as data from neighboring census tracts.  With this in mind, we split the test and training data based on year.  For our first attempt we split on the year 2007.  All data from 2001 through 2006 was used in our test dataset.  All data from 2007 to 2010 was used in our training dataset.  Note, with such a small training dataset to work with, we did not use a validation dataset, but instead used the testing dataset for validation since cross validation was not something that we could implement given the time series nature of the data.  After adjusting our testing and training split, we re-ran the correlation matrix and the results can be found in Figure 6.


| Figure 6 |
| ------------- |
| ![Figure 6](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/CorrelationMatrix2.png) |

The results after modifying our splits are much better.  There are still a few highly correlated features, but they are on features where we would expect to see this. 

Similar to the baseline, a Decision Tree Classifier was performed on the engineered dataset as well.  We used default hyper parameters at this point, but we developed a core framework where we could tune hyper parameters and add features as mentioned in Data Understanding over the next several weeks.  The results of our analysis are shown in Figures 7 and 8:

| Figure 7 | Figure 8 |
| ------------- | ------------- |
| ![Figure 7](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/FeatureImportance2.png) | ![Figure 8](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/FeatureImportance3.png) |

Again, similar to the baseline model, we compared the Area Under the ROC curve for Decision Matrix, Logistic Regression and Support Vector Machine with the new features.  Results shown in Figure 9.

We noticed a slight improvement from the baseline on both accuracy and AUC.  Our best AUC was .866 using default parameters except a very large C for essentially no regularization.  Nonetheless, the AUC of .866 is very good.


| Figure 9 |
| ------------- |
| ![Figure 9](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/AUCROC2.png) |

Armed with this information, we decided that the cost of finding, cleaning, and engineering features from external data did not provide enough value to justify the cost.

## Modeling & Evaluation
We performed Decision Tree Classification, Logistic Regression and SVM, with various hyper parameters and we evaluated performance using an ROC curve and Lift.

In terms of precision and recall, there are competing forces determining which is more important from a business perspective.  On one hand, precision is important because we assume the Department of Education has a limited budget and does not want to waste resources on school districts falsely identified as having significant growth.  On the other hand, from sort of an ethics standpoint, and certainly from the mission of the department, the DoE would not want to underfund a false negative.

When tuning hyper parameters for each algorithm, we tried to take into account several evaluation metrics.  We ended up primarily using AUC as our deciding metric when determining best model.  Because we have competing forces in terms of true positive and false positive importance, we used the AUC because it provides a metric that tells us which model delivers the best overall performance.  We also looked at lift against our base model as shown below, however, because we also compared tweaking our test and train split by changing which year to split on, we could not use it as our final decision metric because it is not base rate invariant.

Once we decided on a metric, the first thing we tuned was how the data was split.  One of the things we noticed when evaluating the data was how overall, the year over year growth for the entire district was fairly linear, but in 2007 growth accelerated as seen in Figure 10.  We wanted to capture a predictor of this acceleration without cannibalizing our training dataset so we ran through several scenarios with different testing / training year splits.  The results are shown in Figure 11.


| Figure 10 |
| ------------- |
| ![Figure 10](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/GrowthByYear.png) |

| Figure 11 |
| ------------- |
| ![Figure 11](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure11.png) |

Logistic regression consistently outperformed the other methods.  We also found that the difference in performance when changing the year that we split testing and training to be inconsistent and minimal.  With this, we determined that 2001-2007 testing and 2008-2009 data for training would be our best split.  Even though in the figure above, splitting on 2001-2005 testing and 2006-2009 training shows a better AUC, we felt 2001-2005 didn’t have enough data.  It also showed more variance each time we ran the model so we trusted the results using the original split the most.  This can also be seen looking at SVM.  It is interesting how the middle split performs better for SVM, but the book end splits perform better for logistic regression.  If we had time, it would be a good thought exercise to determine why.  We did not even try splitting on 2001-2008 training with only 2009 as our test data set because we felt the result would be too biased.

Nonetheless, at this point, the last thing we wanted to tune before focusing in on a single model was the sort of long tail distribution of the counts.  Recall from Figure 1 that there are a significant number of tracts with fewer than 10 students per tract and in fact, within that subset, a significant number of tracts with zero students.  We wanted to test if the predictive features on the low population areas were the same or different than those on highly populated areas.  To do this, we split the data once again three different ways and compared results.

| Figure 12 | Figure 13 |
| ------------- | ------------- |
| ![Figure 12](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure12.png) | ![Figure 13](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure13.png) |

| Figure 14 | Figure 15 |
| ------------- | ------------- |
| ![Figure 14](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure14.png) | ![Figure 15](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure15.png) |

| Figure 16 | Figure 17 |
| ------------- | ------------- |
| ![Figure 16](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure16.png) | ![Figure 17](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure17.png) |

Overall we found that consistently the top 5 predictors for both small and large population tracts remained the same, but the relative importance differs.  Count is a much better predictor for larger population tracts, whereas previous grade count is a very strong predictor for low population tracts.  

We got our best consistent performance when dividing the data on tracts with population of fewer than 10 students versus tracts with 10 or more students.  Also, throughout the entire experiment, we found that logistic regression consistently outperformed other methods.  Our final modeling task was tuning the actual logistic regression model. 

When tuning the Logistic Regression results, we focused on three hyper parameters: the algorithm, L1 versus L2 regularization, and the value of C.  We did not expect regularization to have a major effect on our performance because our dimensionality is relatively low.  We do have a small sample size, however, with only about 5,000 samples so we thought it to be a worthy effort.  Figures 18 and 19 show the results of our initial analysis.


| Figure 18 |
| ------------- |
| ![Figure 18](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/FIgure18.png) |

| Figure 19 |
| ------------- |
| ![Figure 19](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure19.png) |

From the data, it looks like, low and behold, the default parameters from sklearn are generally the best, however, for low density tracts, L1 regularization seems to perform a bit better.  To get a sense of feature weights for L2 vs L1, we compared the regularization paths using the same various values of C, but only on the liblinear solver, shown in Figures 20 and 21 below:


| Figure 20 |
| ------------- |
| ![Figure 20](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure20.png) |

| Figure 21 |
| ------------- |
| ![Figure 21](https://github.com/osuhomebase/NYUDataScience1001-edTech/blob/master/Analysis/Figure21.png) |

In the data above, it looks like the sweet spot is C=1.  There are some features that appear to be much more important in low density tracts than in high density tracts.  It is hard to see, but we pretty much proved the obvious, as the blue line on top of all four regularization paths is Previous Grade Count.   For high density tracts, the one year growth average over three years is the best predictor.  

To summarize, we found that our best model is a testing / training split on the year 2007 and by running separate models on low density tracts with fewer than 10 students and high density tracts with equal to or more than 10 students. We found that logistic regression seems to work best using the liblinear algorithm with a default C=1.  L1 regularization seems to work best for low density tracts, whereas method of regularization penalty does not seem to matter for higher density tracts.  We improved our performance from the baseline model from an AUC of .8 to an AUC consistently above .875 and as high as .88.

## Deployment
Overall, the model we generated is a good first step to solving the business problem, but certainly not the final step.  Primarily the model shows when there is a change, but does not tell us about the magnitude of the change.  An obvious flaw of this is exposed when looking at the population spike starting after 2007.  Our model would have predicted an increase, but not predict this accelerated growth behavior.  A good next iteration would be to add more classifications than simply if the tract will increase in school aged population or not.  We discussed sort of binning the classifications such as if the tract will increase or decrease by 1, 3, 5, 10 students or by bins of percentages.  We would need to discuss how money and resources are being allocated to school districts to determine the relative importance of knowing raw number of predicted change in student population versus a percent change, especially given that even in the small enclave of District 20 there is such a wide range of student populations, ranging from zero to 600 students in 133 census tracts.
	
In addition, before deploying we would also include some of the elusive data sets that we tried to find when the project started.  We tried hard to find data on consumer spending habits and birth data that we feel would provide extremely valuable features for solving this problem.  We also would extend the test and training data to beyond 2010.  We had a very difficult time extracting features prior to 2010, but the US Census has a fantastic data browser including a lot of household demographic data beyond 2010.  Data such as poverty rate, average household income, and education level attained would be great to analyze.  The census even has data on things like average commute time to work.  
	
It is worth mentioning how difficult the Department of Education made this task for the participants.  No information about the features or data was provided until the dataset was released in November.  The data set was not only surprisingly minimal, with only tract, year, grade level, and count of students, but it also did not include a definition of what a census tract even was.  The DOE also informed participants after Thanksgiving that 24 of the original 134 tracts provided were actually not part of the district we were supposed to be analyzing.  This helped explain wild results when analyzing neighboring tracts, but we had to put significant time into removing the tracts from the both the original and engineered data, which seems easy, but we had to recalculate all engineered features.
	
On the flip side, this is not a deployment consideration, but as a reflection starting out with such limited data helped our group recognize the importance of feature engineering and deeply understanding the hyper parameters of our model.  Out of necessity, we engineered features that we would have otherwise most likely not considered.  We ended up feeling as though these features were stronger than any of the other external data that we were looking to incorporate.  While frustrating, the barriers imposed by the contest probably helped us understand the lifecycle of a data science problem more so than if we had a good data set from the outset.
  
Once new features and more current data is inserted into our model, we would recommend essentially repeating the entire process every budget cycle.  Assuming budget cycles happen annually, the model can easily be retrained each year and analyzed for new trends in which features become more or less important.  There is no real production versus test environment where this model needs to be deployed as the end users would be consuming a report provided by a data scientist or analyst familiar with the data science.  As such, performance is not an issue.  
  
Finally, whoever consumes this data has a responsibility to ensure resources are allocated to Pre-K programs ethically.  Our proposed model after the enhancements mentioned in this section are implemented simply predicts the change in school aged population.  There are many other considerations when allocating resources for education, especially early education, where students come from varying degrees of privilege.  There is also the issue of kindergarten readiness.  The number of students about to enroll in Pre-K may not be indicative of the volume of resources required to prepare and support those who do enroll. 

