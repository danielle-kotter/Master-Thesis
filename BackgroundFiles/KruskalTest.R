data <- read_excel("Main doc survey.xlsx")
attach(data)

dani <- c( "#ffa500", "#34495E", "#69b3a2", "#ffd561", "#ee5c42", "#DAF7A6", "#C8A2C8", "#5c3170", "#990000", "#C70039", "#34495E", "#909497")
pal9 <- jcolors("pal9")
library(FactoMineR)
library(factoextra)

data <- separate(
  data,
  Criteria_Type_Coffee,
  into = c("Criteria_A", "Criteria_B"),
  sep = "([,])",
  remove = TRUE,
  convert = FALSE,
  extra = "drop",
  fill = "right",
)

data <- separate(
  data,
  Subscription_Not_Likely,
  into = c("Subscription_A", "Subscription_B"),
  sep = "([,])",
  remove = TRUE,
  convert = FALSE,
  extra = "drop",
  fill = "right",
)

data <- separate(
  data,
  "Supermarket_Negative_ Reasons",
  into = c("Supermarket_NO_A", "Supermarket_NO_B"),
  sep = "([,])",
  remove = TRUE,
  convert = FALSE,
  extra = "drop",
  fill = "right",
)

data <- separate(
  data,
  "Supermarket_Positive_ Reasons",
  into = c("Supermarket_YES_A", "Supermarket_YES_B"),
  sep = "([,])",
  remove = TRUE,
  convert = FALSE,
  extra = "drop",
  fill = "right",
)

data <- data[,-match(c("Language", "Participant", "Home", "Occupation", "Gender", "Education", "AgeCategory", "Criteria_A", "Criteria_B", "Subscription_B", "Supermarket_NO_B", "Supermarket_YES_A", "Supermarket_YES_B", "Subscription_A", "Supermarket_NO_A"),names(data))]
dataf <- dummy_cols(data, select_columns = c("BrandChange", "PurchaseLocation", "Frequency_Specialty", "Machine", "MoneyGroceries", "AmountOutMonth"), remove_selected_columns = TRUE, ignore_na = TRUE)

Orgdata <- na.omit(dataf) # listwise deletion of missing
NewData <- scale(Orgdata) # standardize variables

head(NewData)

set.seed(1234)

fit2 <- kmeans(na.omit(NewData), centers = 3, nstart = 50) #3 cluster solution

# append cluster assignment
mydata <- data.frame(na.omit(dataf), cluster = fit2$cluster)
mydata <- mydata[,c(3:31, 92)]

## perform nonparametric ANOVA between-clusters to get chi-squares and p-values
var_names <- colnames(mydata[,-ncol(mydata)])

anova_tests <- list() 
for (var_name in var_names) {
  anova_tests[[var_name]] <- kruskal.test(get(var_name) ~ cluster, data = mydata)
}
anova_tests
