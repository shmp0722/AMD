# import packages
library(pROC)
library(readr)
setwd('~/Documents/Code/git/AMD/DiffusionMeasure/OphthalmicParameter')

# load csv
FA <- read_csv("~/Documents/Code/git/AMD/DiffusionMeasure/OphthalmicParameter/OR03_FA.csv", 
                    col_names = FALSE)
View(FA)

# define disease and controls
disease = rep(0, 20)
disease[1:8] = 1
FA$disease = disease

for(ii in 1:50)
roc_1 <- roc(FA$disease, FA$X(ii), auc=T, ci=T, plot=TRUE) #gives AUC and CI
roc_1


roc_object_2 <- roc(mtcars$am, mtcars$wt, auc=T, ci=T) #gives AUC and CI

roc.test(roc_object_1, roc_object_2) #gives p-value