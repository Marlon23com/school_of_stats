// data importation
// firstrow means we are specifying where the col names are if not stata denotes it as var1,...,varn

 import excel "C:\Users\hp\Desktop\SchoolOfStatisticians\Data_CW2.xlsx", sheet("Automobile") firstrow



describe
//clearing data from memory 
clear // c;ear data
clear all //clearing datasets and variables and results


 import excel "C:\Users\hp\Desktop\SchoolOfStatisticians\Data_CW2.xlsx", sheet("Automobile") firstrow

// Data Inspections

// Describes the data by showing columns types numeric and charcaters
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
summarize

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

estat ic
// (b) Interpret your regression results for your customer. (14 marks) 

/*
The model has an R-squared value of 0.5582, meaning it explains 55.82% of the 
variation in vehicle sale price. 
While not perfect, it indicates a moderate ability to predict vehicle prices 
using the given independent variables as it exceeds 50% threshold. 
*/


/* Question 1.2 Your group manager questions whether the model may suffer from 
potential heteroskedasticity and multicollinearity issues, but you do not agree.
*/



/*
 (a) please briefly explain the concepts of heteroskedasticity and multicollinearity;
*/

// Heteroskedasticity refers to a situation in statistics where the variability (or spread) of the error terms (residuals) in a statistical model is not constant across all levels of the independent variable(s

// Multicollinearity (also often called collinearity) is a statistical phenomenon that occurs in multiple regression analysis when two or more predictor variables (independent variables) in the model are highly correlated or linearly related to each other

/*
 (b) and show evidence on why your results in Question 1 do not suffer from such issues;
*/

rvfplot, yline(0)



// The residuals in the plot appear to be randomly scattered around the zero line, with no clear pattern of increasing or decreasing variance as fitted values rise. This suggests that heteroskedasticity may not be present in the model.

vif

// Since all VIF values are below 5 (<2), indicating no significant multicollinearity.


 /*
 (c) what are possible methods to address the issues of heteroskedasticity and  multicollinearity? (12 marks) 
 Fixing heteroskedasticity:
 -  Applying log transformation or weighted least squares regression can stabilize variance.
 - Using heteroskedasticity-consistent standard errors (HCSE) ensures reliable statistical inference.
 
 Fixing multicollinerarity:
 - Drop One of the Highly Correlated Variables: If two predictors are redundant, removing one may improve model reliability.
 - Centering Variables: Standardizing or mean-centering independent variables can help mitigate issues.
 */
 

 
 /*
 Question 1.3
 One of your colleagues suggests using a nonlinear model instead of a linear model. Please analyse the data and evaluate whether a nonlinear model is a better choice.  
*/

// polyynomial 


gen model_age2 = model_age^2
gen proximity_urban2 = proximity_urban^2

regress vehicle_sale_price model_age model_age2 proximity_urban proximity_urban2 dealerships_nearby sale_date_num


estat ic


/*
Adjusted R-squared:- Linear Model: 0.5541, Nonlinear Model: 0.6256 (Improved)

R-squared:- Linear Model: 0.5582, Nonlinear Model: 0.6307 (Improved)

Root Mean Square Error (RMSE):- Linear Model: 14.098, Nonlinear Model: 12.919 (Lower RMSE suggests better fit)

The nonlinear model shows an improvement in explanatory power (higher R-squared) and a better overall fit (lower RMSE).
*/


*//
Question 2 
You are building an algorithm to determine varieties of iris (versicolor or virginica). You 
have collected data for a sample of iris. The data include sepal length, sepal width, 
petal length, petal width, and the variety of the flower. The data are available in the 
Excel file attached.
*//

// importing the iris sheet from the Data_CW2.xlxs

import excel "D:\Personal\Projects\Datasets\Data_CW2.xlsx", sheet("Iris") firstrow clear


// split columns

 split A, parse(,) gen(col)
 
 // renaming columns
rename col1 sepal_length
rename col2 sepal_width
rename col3 petal_length
rename col4 petal_width
rename col5 species

// Since split treats everything as text, convert numeric columns like this:

destring sepal_length sepal_width petal_length petal_width, replace


// drop var1

drop A

// EDA

// summary stats

describe

summarize, detail


// vizualiizations

// corlation

correlate sepal_length sepal_width petal_length petal_width


// scatter plot matrix

graph matrix sepal_length sepal_width petal_length petal_width, half


// 3. Individual Scatter Plots with species Color


twoway (scatter petal_length petal_width, mcolor(blue)) 
       (scatter sepal_length sepal_width, mcolor(red))
	 
graph matrix sepal_length sepal_width petal_length petal_width, by(species)


// Histograms for individual variables
histogram sepal_length, width(0.5) color(blue) title("Histogram of Sepal Length")
histogram sepal_width, width(0.5) color(red) title("Histogram of Sepal Width")
histogram petal_length, width(0.5) color(green) title("Histogram of Petal Length")
histogram petal_width, width(0.5) color(orange) title("Histogram of Petal Width")

// Density plots for a smoother visualization of distributions
kdensity sepal_length, color(blue) title("Density Plot of Sepal Length")
kdensity sepal_width, color(red) title("Density Plot of Sepal Width")
kdensity petal_length, color(green) title("Density Plot of Petal Length")
kdensity petal_width, color(orange) title("Density Plot of Petal Width

// Pairwise scatter plots by species
scatter petal_length petal_width, by(species) title("Petal Length vs. Petal Width by Species")
scatter sepal_length sepal_width, by(species) title("Sepal Length vs. Sepal Width by Species")


/*
 Use a Kth-Nearest Neighbour model and the Euclidean distance 
algorithm to determine the variety of the following observation (6.6, 3.2, 5.1, 1.5). Use 
relevant theories of the model to justify your choice. (10 marks)
*/

// calculate eqlidiean distance first
gen d = sqrt((sepal_length - 6.6)^2 + ///
             (sepal_width - 3.2)^2 + ///
             (petal_length - 5.1)^2 + ///
             (petal_width - 1.5)^2)
			 
			 
/*

 How to Choose K (Why K=5?)
Odd Number (if classification is 3-class):

Since the Iris dataset has 3 classes (setosa, versicolor, virginica), an odd K (e.g., 3, 5, 7) helps avoid ties in majority voting.

Avoiding Overfitting and Underfitting:

Small K (e.g., 1): Very sensitive to noise, leads to overfitting.

Large K (e.g., 15+): Too smooth, may underfit the data.

K = 5 is a balanced choice: often used as a rule-of-thumb starting point.

Empirical Testing (Cross-Validation):

In practice, we test multiple K values (1, 3, 5, 7, ...) using cross-validation and pick the one with the highest accuracy.

*/

sort d
list species d in 1/5   // <- this gives K=5 nearest neighbors
list species d in 1/3   // <- try K=3

// count units in each neighbour

gen k5 = _n <= 5
tab species if k5

// justication

/*

found the 5 nearest neighbors to the observation (6.6, 3.2, 5.1, 1.5).

The species breakdown:

Iris-virginica: 3 occurrences

Iris-versicolor: 2 occurrences

✅ Prediction: Iris-virginica


Using the K-Nearest Neighbour (K-NN) classification algorithm with K = 5 and Euclidean distance as the metric, we classified 
the new observation (6.6, 3.2, 5.1, 1.5). The five closest data points in the training dataset included three instances of 
Iris-virginica and two of Iris-versicolor. Since Iris-virginica appeared most frequently, the model predicts this species.

The choice of K = 5 provides a balance between sensitivity to noise (as in K=1) and over-smoothing (as in large K).
 The Euclidean distance is suitable because all features are continuous and similarly scaled. This method works effectively
 for the Iris dataset due to its low dimensionality and well-separated classes.
*/

/*

Question 2.2 When we use the K-NN model to classify an unseen instance, a) what 
might be the problem if we set the value of K to an even number? Please provide the 
evidence combining the results from Question 2.1. b) What could be a possible 
solution?  (6 marks) 

*/

// (a) What might be the problem if K is an even number?

// causes  a tie which will lead to ambiguity 

// When K is an even number, there is a higher risk of a tie in the majority vote when classifying a new instance. That is, 
// two or more classes may have the same number of nearest neighbors, making it ambiguous which class to assign.

//  Evidence from Results (K=4 Example)

/*
From the K = 5 results in Question 2.1:

Iris-virginica: 3

Iris-versicolor: 2

Now when using K = 4 (an even number) instead:

You would take the first 4 nearest neighbors:

Iris-versicolor

Iris-virginica

Iris-versicolor

Iris-virginica

That gives:

Iris-versicolor: 2

Iris-virginica: 2

➡️ Tie between two species.

This creates uncertainty in the prediction—the algorithm can’t decide which class to assign

*/

// (b) What could be a possible solution?


// : Use an Odd Value of K

// using : Weighted K-NN. Assign weights to neighbors based on their distance (closer neighbors have more influence). even ties the one with higher weights win


/*
Question 2.3 Apply 5-NN, 7-NN, and 9-NN models, a) show the confusion matrix, and 
b) calculate the accuracy of these models. c) Which model do you think is the best? 
Please explain your choice. (16 marks) 
*/

drop d

	
gen id = _n

// Create empty prediction columns
gen pred5 = ""
gen pred7 = ""
gen pred9 = ""

// ---------- K = 5 ----------
forvalues i = 1/`=_N' {
    preserve
    keep if id != `i'
    gen d = sqrt((sepal_length - sepal_length[`i'])^2 + ///
                 (sepal_width - sepal_width[`i'])^2 + ///
                 (petal_length - petal_length[`i'])^2 + ///
                 (petal_width - petal_width[`i'])^2)
    sort d
    keep in 1/5
    egen mode = mode(species)
    local top_species = mode[1]
    restore
    replace pred5 = "`top_species'" in `i'
}

// ---------- K = 7 ----------
forvalues i = 1/`=_N' {
    preserve
    keep if id != `i'
    gen d = sqrt((sepal_length - sepal_length[`i'])^2 + ///
                 (sepal_width - sepal_width[`i'])^2 + ///
                 (petal_length - petal_length[`i'])^2 + ///
                 (petal_width - petal_width[`i'])^2)
    sort d
    keep in 1/7
    egen mode = mode(species)
    local top_species = mode[1]
    restore
    replace pred7 = "`top_species'" in `i'
}

// ---------- K = 9 ----------
forvalues i = 1/`=_N' {
    preserve
    keep if id != `i'
    gen d = sqrt((sepal_length - sepal_length[`i'])^2 + ///
                 (sepal_width - sepal_width[`i'])^2 + ///
                 (petal_length - petal_length[`i'])^2 + ///
                 (petal_width - petal_width[`i'])^2)
    sort d
    keep in 1/9
    egen mode = mode(species)
    local top_species = mode[1]
    restore
    replace pred9 = "`top_species'" in `i'
}

// ---------- Confusion Matrices ----------
di "Confusion Matrix for K = 5"
tab species pred5

di "Confusion Matrix for K = 7"
tab species pred7

di "Confusion Matrix for K = 9"
tab species pred9

// ---------- Accuracy ----------
gen correct5 = (species == pred5)
gen correct7 = (species == pred7)
gen correct9 = (species == pred9)

di "Accuracy for K = 5"
summarize correct5

di "Accuracy for K = 7"
summarize correct7

di "Accuracy for K = 9"
summarize correct9



tabulate species pred5    // Confusion matrix for 5-NN
tabulate species pred7    // Confusion matrix for 7-NN
tabulate species pred9    // Confusion matrix for 9-NN


//  Best Model & Justification
//Best accuracy ▶ 9-NN (54.29 %)


