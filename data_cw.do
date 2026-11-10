// data importation
// firstrow means we are specifying where the col names are if not stata denotes it as var1,...,varn

import excel "C:\Users\hp\Desktop\SchoolOfStatisticians\Data_CW2.xlsx", sheet("Automobile") firstrow

describe
//clearing data from memory 
clear // c;ear data
clear all //clearing datasets and variables and results



import excel "C:\Users\hp\Desktop\SchoolOfStatisticians\Data_CW2.xlsx", sheet("Automobile") firstrow
// Data Inspections

// Describes the data by showing columns types numeric and  charcaters
describe

// view data works like view in R

browse

// Cleaning data

//  Check for missing variables
misstable summarize

// Duplicates check 

duplicates report

//duplicates specfici list

duplicates list

// renaming column names to ensure spaces are sorted

rename SaleID sale_id
rename saledate sale_date
rename Modelage model_age
rename proximitytourbancentres proximity_urban
rename numberofdealershipsnearby dealerships_nearby
rename vechiclesaleprice vehicle_sale_price


/// Date formatting YYY-MM-DD 

gen sale_date_num = mdy(1, 1, floor(sale_date)) + round((sale_date - floor(sale_date)) * 365.25)

format sale_date_num %td

// dropping missing values
drop if missing(sale_id) | missing(sale_date) | missing(model_age) | missing(proximity_urban) | missing(dealerships_nearby) | missing(vehicle_sale_price)

// list this prinst wholedata in the terminal output

list

//summary statistics
summarize sale_id sale_date model_age proximity_urban dealerships_nearby vehicle_sale_price

// histogram

// model age histogram
histogram model_age, width(5) kdensity title("Histogram of Model Age with Kernel Density")

// proximity to urban areas hist

histogram proximity_urban, width(1) kdensity title("Histogram of Proximity to Urban Centres with Kernel Density")

// nearby dealerships hist

histogram dealerships_nearby, width(1) kdensity title("Histogram of Dealerships Nearby with Kernel Density")

// vehicle sale price

histogram vehicle_sale_price, width(1000) kdensity title("Histogram of Vehicle Sale Price with Kernel Density")

// normla curve included

histogram model_age, width(5) normal title("Histogram of Model Age with Normal Curve")

histogram proximity_urban, width(1) normal title("Histogram of Proximity to Urban Centres with Normal Curve")


histogram dealerships_nearby, width(1) normal title("Histogram of Dealerships Nearby with Normal Curve")

// visualizations
//🚗 1. Trend Over Time: Vehicle Sale Price vs. Sale Date
twoway (scatter vehicle_sale_price sale_date), ///
    title("Vehicle Sale Price Over Time") ///
	
// vehicle price over time

twoway scatter vehicle_sale_price sale_date_num, ///
    title("Vehicle Sale Price Over Time") ///
    xtitle("Sale Date") ytitle("Vehicle Sale Price") ///
    mcolor(blue)

twoway (scatter vehicle_sale_price sale_date_num, mcolor(blue)) ///
       (lfit vehicle_sale_price sale_date_num, lcolor(red)), ///
       title("Sale Price Trend Over Time") ///
       xtitle("Sale Date") ytitle("Vehicle Sale Price")

// 2. Vehicle Sale Price vs. Model Age

scatter vehicle_sale_price model_age, ///
    title("Vehicle Sale Price vs. Model Age") ///
    xtitle("Model Age") ytitle("Sale Price") ///
    mcolor(blue)



// 🏙️ 3. Vehicle Sale Price vs. Proximity to Urban Centres

scatter vehicle_sale_price proximity_urban, ///
    title("Sale Price vs. Proximity to Urban Centres") ///
    xtitle("Proximity to Urban Centres") ytitle("Sale Price") ///
    mcolor(green)

//  4. Vehicle Sale Price vs. Number of Dealerships Nearby

scatter vehicle_sale_price dealerships_nearby, ///
    title("Sale Price vs. Dealerships Nearby") ///
    xtitle("Dealerships Nearby") ytitle("Sale Price") ///
    mcolor(maroon)



//Question 1.1

// (a) Build a linear regression model to predict vehicle value. 

regress vehicle_sale_price model_age proximity_urban dealerships_nearby sale_date_num


// (b) Interpret your regression results for your customer. (14 marks) 

/* Question 1.2 Your group manager questions whether the model may suffer from 
potential heteroskedasticity and multicollinearity issues, but you do not agree.
*/



/*
 (a) please briefly explain the concepts of heteroskedasticity and multicollinearity;
*/

// refers to a situation in statistics where the variability (or spread) of the error terms (residuals) in a statistical model is not constant across all levels of the independent variable(s

// Multicollinearity (also often called collinearity) is a statistical phenomenon that occurs in multiple regression analysis when two or more predictor variables (independent variables) in the model are highly correlated or linearly related to each other

/*
 (b) and show evidence on why your results in Question 1 do not suffer from such issues;
*/

estat hettest


// If the p-value is less than the significance level1 (e.g., < 0.05): We would reject the null hypothesis. This would mean there's strong enough evidence to say that the variance of the errors is not constant, and therefore, heteroscedasticity is likely present

// no heterosdacticity

vif

// Based on these VIF values, it appears that multicollinearity is not a significant problem in your current regression model

// Around 1 indicate no multicollinearity.

// There is no mulitcolinearity 

 /*
 (c) what are possible methods to address the issues of heteroskedasticity and  multicollinearity? (12 marks) 
 */
 
 
 /*
 Question 1.3
 One of your colleagues suggests using a nonlinear model instead of a linear model. Please analyse the data and evaluate whether a nonlinear model is a better choice. (5 marks) 31 marks in total 
*/

gen model_age2 = model_age^2
gen proximity_urban2 = proximity_urban^2

regress vehicle_sale_price model_age model_age2 proximity_urban proximity_urban2 dealerships_nearby sale_date_num


estat ic

//(a) Did a nonlinear model improve prediction?

// YEs

/*
Both squared terms are highly statistically significant:

model_age2: p < 0.001

proximity_urban2: p < 0.001

This suggests curvature:

For example, vehicle value decreases with age at a decreasing rate (perhaps rapid depreciation early on, then stabilizing).

Similarly, proximity to urban centres has a nonlinear impact on price.
*/

// (b) Did the model fit improve?

// yes 

// BIC and AIC values are better imporved
/*


Question 2 
You are building an algorithm to determine varieties of iris (versicolor or virginica). You 
have collected data for a sample of iris. The data include sepal length, sepal width, 
petal length, petal width, and the variety of the flower. The data are available in the 
Excel file attached.
*/
