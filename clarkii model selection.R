
library(rms)


clarkii_data <- read.csv("PCNM_results clarkii w pca.csv")


output_full  <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + PCNM15 + PCNM16 
                         +pca_1
                         +pca_2
                         +pca_3
                         +pca_4
                         +pca_5, data = clarkii_data)

range(fitted(output_full))

output_full$u

output_full$gradient

max(abs(output_full$u))

H <- output_full$info.matrix

eigen(H)$values

# perform a model selection
drop1(output_full, test = 'F')
# -> remove PCNM13(the least significant variable)


output_1 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM14 + PCNM15 + PCNM16 
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = clarkii_data, family = "binomial")
drop1(output_1, test = 'F')
# -> remove PCNM 11

output_2 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = clarkii_data, family = "binomial")
drop1(output_2, test = 'F')
# -> remove SQ.WATRES






#####what oes the first 3 pcnm look like
output_full  <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 
                    +pca_1
                    +pca_2
                    +pca_3
                    +pca_4
                    +pca_5, data = clarkii_data, family = "binomial")

summary(output_full)
anova(output_full)



###checking for multicolliniarity in the data

library(performance)
check_collinearity(full.model.PCNM.c)



preds <- clarkii_data[, c(
  paste0("PCNM",1:16),
  paste0("pca_",1:5)
)]


round(cor(preds), 2)




####Okay lets look at the way the each PNCM variable is defining because we have high correlation
#### between some pca variables and PCNM variabels


library(ggplot2)

ggplot(clarkii_data, aes(x = X, y = Y, color = PCNM1)) +
  geom_point(size = 3) +
  scale_color_viridis_c() +
  coord_fixed()

ggplot(clarkii_data, aes(x = X, y = Y, color = pca_1)) +
  geom_point(size = 3) +
  scale_color_viridis_c() +
  coord_fixed()


library(lme)
###regrenlme###regress the PCNM data on the PCA data
model <- lm(pca_1 ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + PCNM15 + PCNM16 , data = clarkii_data)
summary(model)



full.model.PCNM.C.lrm <- lrm(
  presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + PCNM15 + PCNM16 +
    pca_1 +
    pca_2 +
    pca_3 +
    pca_4 +
    pca_5,
  data = clarkii_data
  
)

lp <- predict(full.model.PCNM.C.lrm, type = "lp")

range(lp)


predict(full.model.PCNM.C.lrm, type = "fitted.ind")

max(abs(coef(full.model.PCNM.C.lrm)))

kappa(model.matrix(full.model.PCNM.C.lrm))

full.model.PCNM.C.lrm$fail

full.model.PCNM.C.lrm

#### I am looking at what happens as you continue to add pcnm variables and ploting how that
#affects the auc changes over that course as well as the coefficient uncertainty





clarkii_data_sorted <- clarkii_data[order(clarkii_data[,"presence"]),]

##find which row the presences begin on, and create an R object with this information
presence.begin <- min(which(clarkii_data_sorted[,"presence"] == 1))

##find the last row of acutus_data_sorted, and save this row number as an r object
presence.end <- max(which(clarkii_data_sorted[,"presence"] == 1))

##find which row the absence begin on, and create an R object with this information
absence.begin <- min(which(clarkii_data_sorted[,"presence"] == 0))

##find the last row of acutus_data_sorted, and save this row number as an r object
absence.end <- max(which(clarkii_data_sorted[,"presence"] == 0))

##create an object of just the presences

presence_data <- subset(clarkii_data_sorted, presence == 1)

absence_data <- subset(clarkii_data_sorted, presence == 0)
## determine number of rows in data

row.ct <- nrow(presence_data)

row.ct.a <- nrow(absence_data)
##find 10% of the amount of rows for each bin
pre.n <- row.ct * .1

bin.size <- floor(pre.n)

ab.n <- row.ct.a * .1

bin.size.a <- floor(ab.n)

# determine if the bins need remainders added to there size
# The total number of entries
rm(loop.remainder)
remainder <- row.ct %% 10  # Calculate the remainder
loop.remainder <- remainder

rm(loop.remainder.a)
remainder.a <- row.ct.a %% 10  # Calculate the remainder
loop.remainder.a <- remainder.a

##here run multiple logistic regression without 10% of data for test data, then predict values of 
##omitted data and absence data to then be used in AUC ROC
#rm(start.row.no.remainder)
#rm(start.row)
#rm(end.row)
#rm(end.row.no.remainder)


AUC.3 <- NULL
AUC.train.3 <- NULL
AUC.diff.3 <- NULL



for (i in 1:10) {
  start.row.no.remainder <- (i - 1) * bin.size + 1
  end.row.no.remainder <- i * bin.size
  
  # If there are extra elements, distribute them to the last y fractions
  if (loop.remainder > 0) {
    end.row <- end.row.no.remainder + i
    loop.remainder <- loop.remainder - 1
  } else {
    end.row <- end.row.no.remainder + remainder
    loop.remainder <- loop.remainder - 1
  }
  if (loop.remainder > -1) {
    start.row <- start.row.no.remainder + i - 1
  } else {
    start.row <- start.row.no.remainder + remainder
  }
  
  
  # If there are extra elements, distribute them to the last y fractions
  start.row.no.remainder.a <- (i - 1) * bin.size.a + 1
  end.row.no.remainder.a <- i * bin.size.a
  
  if (loop.remainder.a > 0) {
    end.row.a <- end.row.no.remainder.a + i
    loop.remainder.a <- loop.remainder.a - 1
  } else {
    end.row.a <- end.row.no.remainder.a + remainder.a
    loop.remainder.a <- loop.remainder.a - 1
  }
  if (loop.remainder.a > -1) {
    start.row.a <- start.row.no.remainder.a + i - 1
  } else {
    start.row.a <- start.row.no.remainder.a + remainder.a
  }
  
  
  #create dataset excluding test points
  
  mlr.presence.data <- presence_data[-start.row:-end.row, ]
  
  mlr.absence.data <- absence_data[-start.row.a:-end.row.a, ]
  
  mlr.data <- rbind(mlr.presence.data, mlr.absence.data)
  
  ##run regression
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 
               +pca_1
               +pca_2
               +pca_3
               +pca_4
               +pca_5
               +pca_6, data = mlr.data)
  
  
  
  #predict habitat suitability of absence and test presence points
  
  test.presences <- presence_data[start.row:end.row, ]
  
  test.absences <- absence_data[start.row.a:end.row.a, ]
  
  test.points <- rbind(test.presences,test.absences)
  
  habitat.suitability <- predict(model, newdata = test.points, type = "lp")
  
  
  
  
  #training auc data
  
  train.habitat.suitability <- predict(model, newdata = mlr.data, type = "lp")
  
  
  
  rocdata.train <- train.habitat.suitability
  
  rocdata2.train <- cbind(mlr.data$presence, rocdata.train)
  
  colnames(rocdata2.train) <- c("presence", "suitability")
  
  rocdata3.train <- data.frame(rocdata2.train)
  
  roc_obj.train <- roc(presence ~ suitability, rocdata3.train)
  
  AUC.train.3 <- c(AUC.train.3, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
  
  
  
  AUC.3 <- c(AUC.3, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff.3 <- c(AUC.diff.3, auc.diff.i)
}





AUC.5 <- NULL
AUC.train.5 <- NULL
AUC.diff.5 <- NULL



for (i in 1:10) {
  start.row.no.remainder <- (i - 1) * bin.size + 1
  end.row.no.remainder <- i * bin.size
  
  # If there are extra elements, distribute them to the last y fractions
  if (loop.remainder > 0) {
    end.row <- end.row.no.remainder + i
    loop.remainder <- loop.remainder - 1
  } else {
    end.row <- end.row.no.remainder + remainder
    loop.remainder <- loop.remainder - 1
  }
  if (loop.remainder > -1) {
    start.row <- start.row.no.remainder + i - 1
  } else {
    start.row <- start.row.no.remainder + remainder
  }
  
  
  # If there are extra elements, distribute them to the last y fractions
  start.row.no.remainder.a <- (i - 1) * bin.size.a + 1
  end.row.no.remainder.a <- i * bin.size.a
  
  if (loop.remainder.a > 0) {
    end.row.a <- end.row.no.remainder.a + i
    loop.remainder.a <- loop.remainder.a - 1
  } else {
    end.row.a <- end.row.no.remainder.a + remainder.a
    loop.remainder.a <- loop.remainder.a - 1
  }
  if (loop.remainder.a > -1) {
    start.row.a <- start.row.no.remainder.a + i - 1
  } else {
    start.row.a <- start.row.no.remainder.a + remainder.a
  }
  
  
  #create dataset excluding test points
  
  mlr.presence.data <- presence_data[-start.row:-end.row, ]
  
  mlr.absence.data <- absence_data[-start.row.a:-end.row.a, ]
  
  mlr.data <- rbind(mlr.presence.data, mlr.absence.data)
  
  ##run regression
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5
               +pca_1
               +pca_2
               +pca_3
               +pca_4
               +pca_5
               +pca_6, data = mlr.data)
  
  
  
  #predict habitat suitability of absence and test presence points
  
  test.presences <- presence_data[start.row:end.row, ]
  
  test.absences <- absence_data[start.row.a:end.row.a, ]
  
  test.points <- rbind(test.presences,test.absences)
  
  habitat.suitability <- predict(model, newdata = test.points, type = "lp")
  
  
  
  
  #training auc data
  
  train.habitat.suitability <- predict(model, newdata = mlr.data, type = "lp")
  
  
  
  rocdata.train <- train.habitat.suitability
  
  rocdata2.train <- cbind(mlr.data$presence, rocdata.train)
  
  colnames(rocdata2.train) <- c("presence", "suitability")
  
  rocdata3.train <- data.frame(rocdata2.train)
  
  roc_obj.train <- roc(presence ~ suitability, rocdata3.train)
  
  AUC.train.5 <- c(AUC.train.5, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
  
  
  
  AUC.5 <- c(AUC.5, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff.5 <- c(AUC.diff.5, auc.diff.i)
}




AUC.8 <- NULL
AUC.train.8 <- NULL
AUC.diff.8 <- NULL



for (i in 1:10) {
  start.row.no.remainder <- (i - 1) * bin.size + 1
  end.row.no.remainder <- i * bin.size
  
  # If there are extra elements, distribute them to the last y fractions
  if (loop.remainder > 0) {
    end.row <- end.row.no.remainder + i
    loop.remainder <- loop.remainder - 1
  } else {
    end.row <- end.row.no.remainder + remainder
    loop.remainder <- loop.remainder - 1
  }
  if (loop.remainder > -1) {
    start.row <- start.row.no.remainder + i - 1
  } else {
    start.row <- start.row.no.remainder + remainder
  }
  
  
  # If there are extra elements, distribute them to the last y fractions
  start.row.no.remainder.a <- (i - 1) * bin.size.a + 1
  end.row.no.remainder.a <- i * bin.size.a
  
  if (loop.remainder.a > 0) {
    end.row.a <- end.row.no.remainder.a + i
    loop.remainder.a <- loop.remainder.a - 1
  } else {
    end.row.a <- end.row.no.remainder.a + remainder.a
    loop.remainder.a <- loop.remainder.a - 1
  }
  if (loop.remainder.a > -1) {
    start.row.a <- start.row.no.remainder.a + i - 1
  } else {
    start.row.a <- start.row.no.remainder.a + remainder.a
  }
  
  
  #create dataset excluding test points
  
  mlr.presence.data <- presence_data[-start.row:-end.row, ]
  
  mlr.absence.data <- absence_data[-start.row.a:-end.row.a, ]
  
  mlr.data <- rbind(mlr.presence.data, mlr.absence.data)
  
  ##run regression
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8
               +pca_1
               +pca_2
               +pca_3
               +pca_4
               +pca_5
               +pca_6, data = mlr.data)
  
  
  
  #predict habitat suitability of absence and test presence points
  
  test.presences <- presence_data[start.row:end.row, ]
  
  test.absences <- absence_data[start.row.a:end.row.a, ]
  
  test.points <- rbind(test.presences,test.absences)
  
  habitat.suitability <- predict(model, newdata = test.points, type = "lp")
  
  
  
  
  #training auc data
  
  train.habitat.suitability <- predict(model, newdata = mlr.data, type = "lp")
  
  
  
  rocdata.train <- train.habitat.suitability
  
  rocdata2.train <- cbind(mlr.data$presence, rocdata.train)
  
  colnames(rocdata2.train) <- c("presence", "suitability")
  
  rocdata3.train <- data.frame(rocdata2.train)
  
  roc_obj.train <- roc(presence ~ suitability, rocdata3.train)
  
  AUC.train.8 <- c(AUC.train.8, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
  
  
  
  AUC.8 <- c(AUC.8, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff.8 <- c(AUC.diff.8, auc.diff.i)
}





AUC.12 <- NULL
AUC.train.12 <- NULL
AUC.diff.12 <- NULL



for (i in 1:10) {
  start.row.no.remainder <- (i - 1) * bin.size + 1
  end.row.no.remainder <- i * bin.size
  
  # If there are extra elements, distribute them to the last y fractions
  if (loop.remainder > 0) {
    end.row <- end.row.no.remainder + i
    loop.remainder <- loop.remainder - 1
  } else {
    end.row <- end.row.no.remainder + remainder
    loop.remainder <- loop.remainder - 1
  }
  if (loop.remainder > -1) {
    start.row <- start.row.no.remainder + i - 1
  } else {
    start.row <- start.row.no.remainder + remainder
  }
  
  
  # If there are extra elements, distribute them to the last y fractions
  start.row.no.remainder.a <- (i - 1) * bin.size.a + 1
  end.row.no.remainder.a <- i * bin.size.a
  
  if (loop.remainder.a > 0) {
    end.row.a <- end.row.no.remainder.a + i
    loop.remainder.a <- loop.remainder.a - 1
  } else {
    end.row.a <- end.row.no.remainder.a + remainder.a
    loop.remainder.a <- loop.remainder.a - 1
  }
  if (loop.remainder.a > -1) {
    start.row.a <- start.row.no.remainder.a + i - 1
  } else {
    start.row.a <- start.row.no.remainder.a + remainder.a
  }
  
  
  #create dataset excluding test points
  
  mlr.presence.data <- presence_data[-start.row:-end.row, ]
  
  mlr.absence.data <- absence_data[-start.row.a:-end.row.a, ]
  
  mlr.data <- rbind(mlr.presence.data, mlr.absence.data)
  
  ##run regression
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12
               +pca_1
               +pca_2
               +pca_3
               +pca_4
               +pca_5
               +pca_6, data = mlr.data)
  
  
  
  #predict habitat suitability of absence and test presence points
  
  test.presences <- presence_data[start.row:end.row, ]
  
  test.absences <- absence_data[start.row.a:end.row.a, ]
  
  test.points <- rbind(test.presences,test.absences)
  
  habitat.suitability <- predict(model, newdata = test.points, type = "lp")
  
  
  
  
  #training auc data
  
  train.habitat.suitability <- predict(model, newdata = mlr.data, type = "lp")
  
  
  
  rocdata.train <- train.habitat.suitability
  
  rocdata2.train <- cbind(mlr.data$presence, rocdata.train)
  
  colnames(rocdata2.train) <- c("presence", "suitability")
  
  rocdata3.train <- data.frame(rocdata2.train)
  
  roc_obj.train <- roc(presence ~ suitability, rocdata3.train)
  
  AUC.train.12 <- c(AUC.train.12, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
  
  
  
  AUC.12 <- c(AUC.12, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff.12 <- c(AUC.diff.12, auc.diff.i)
}






AUC.16 <- NULL
AUC.train.16 <- NULL
AUC.diff.16 <- NULL



for (i in 1:10) {
  start.row.no.remainder <- (i - 1) * bin.size + 1
  end.row.no.remainder <- i * bin.size
  
  # If there are extra elements, distribute them to the last y fractions
  if (loop.remainder > 0) {
    end.row <- end.row.no.remainder + i
    loop.remainder <- loop.remainder - 1
  } else {
    end.row <- end.row.no.remainder + remainder
    loop.remainder <- loop.remainder - 1
  }
  if (loop.remainder > -1) {
    start.row <- start.row.no.remainder + i - 1
  } else {
    start.row <- start.row.no.remainder + remainder
  }
  
  
  # If there are extra elements, distribute them to the last y fractions
  start.row.no.remainder.a <- (i - 1) * bin.size.a + 1
  end.row.no.remainder.a <- i * bin.size.a
  
  if (loop.remainder.a > 0) {
    end.row.a <- end.row.no.remainder.a + i
    loop.remainder.a <- loop.remainder.a - 1
  } else {
    end.row.a <- end.row.no.remainder.a + remainder.a
    loop.remainder.a <- loop.remainder.a - 1
  }
  if (loop.remainder.a > -1) {
    start.row.a <- start.row.no.remainder.a + i - 1
  } else {
    start.row.a <- start.row.no.remainder.a + remainder.a
  }
  
  
  #create dataset excluding test points
  
  mlr.presence.data <- presence_data[-start.row:-end.row, ]
  
  mlr.absence.data <- absence_data[-start.row.a:-end.row.a, ]
  
  mlr.data <- rbind(mlr.presence.data, mlr.absence.data)
  
  ##run regression
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12 + PCNM13  + PCNM14 + PCNM15 + PCNM16
               +pca_1
               +pca_2
               +pca_3
               +pca_4
               +pca_5
               +pca_6, data = mlr.data)
  
  
  
  #predict habitat suitability of absence and test presence points
  
  test.presences <- presence_data[start.row:end.row, ]
  
  test.absences <- absence_data[start.row.a:end.row.a, ]
  
  test.points <- rbind(test.presences,test.absences)
  
  habitat.suitability <- predict(model, newdata = test.points, type = "lp")
  
  
  
  
  #training auc data
  
  train.habitat.suitability <- predict(model, newdata = mlr.data, type = "lp")
  
  
  
  rocdata.train <- train.habitat.suitability
  
  rocdata2.train <- cbind(mlr.data$presence, rocdata.train)
  
  colnames(rocdata2.train) <- c("presence", "suitability")
  
  rocdata3.train <- data.frame(rocdata2.train)
  
  roc_obj.train <- roc(presence ~ suitability, rocdata3.train)
  
  AUC.train.16 <- c(AUC.train.16, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
  
  
  
  AUC.16 <- c(AUC.16, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff.16 <- c(AUC.diff.16, auc.diff.i)
}


##### calculate all AUC averages and proceed to plotting
AUC.3.AVG <- mean(AUC.3)

AUC.5.AVG <- mean(AUC.5)

AUC.8.AVG <- mean(AUC.8)

AUC.12.AVG <- mean(AUC.12)

AUC.16.AVG <- mean(AUC.16)

auc.avgs <- c(AUC.3.AVG,AUC.5.AVG,AUC.8.AVG,AUC.12.AVG,AUC.16.AVG)

n.pcnm <- c(3,5,8,12,16)

plot(auc.avgs ~ n.pcnm)

#####This is the explanation for the rational behind why we are using three vairables for clarkii

#The number of PCNM spatial eigenvectors included in candidate models was evaluated using 
#independent test AUC. Increasing the number of PCNM variables beyond the first three resulted 
#in declining predictive performance, suggesting that additional spatial components captured 
#fine-scale spatial variation that did not generalize beyond the training data. Therefore, the
#most parsimonious spatial structure consisting of three PCNM variables was retained for
#subsequent habitat suitability modeling.

# =============================================================================
# Map PCNM spatial eigenvectors
#
# Purpose:
# Visualize spatial structures represented by PCNM variables.
#
# Requirements:
# install.packages(c("sf", "ggplot2", "tidyr", "patchwork"))
# =============================================================================


library(sf)
library(ggplot2)
library(tidyr)
library(dplyr)
library(patchwork)


# =============================================================================
# 1. DATA INPUT — EDIT THIS SECTION
# =============================================================================

# Your species dataset containing:
# - coordinates
# - PCNM variables

pcnm_data <- clarkii_data


# Coordinate column names
# CHANGE THESE TO YOUR COLUMN NAMES

x_coord <- "X"
y_coord <- "Y"


# PCNM variables to map

pcnm_vars <- c(
  "PCNM1",
  "PCNM2",
  "PCNM3",
  "PCNM4",
  "PCNM5",
  "PCNM6",
  "PCNM7",
  "PCNM8",
  "PCNM9",
  "PCNM10",
  "PCNM11",
  "PCNM12",
  "PCNM13",
  "PCNM14",
  "PCNM15",
  "PCNM16"
)


# Output file

output_file <- "PCNM_spatial_structure.png"



# =============================================================================
# 2. CONVERT DATA TO SPATIAL OBJECT
# =============================================================================


pcnm_sf <- st_as_sf(
  pcnm_data,
  coords = c(x_coord, y_coord),
  crs = 4326
)


# =============================================================================
# 3. TRANSFORM INTO LONG FORMAT FOR FACET PLOTTING
# =============================================================================


pcnm_long <- pcnm_sf |>
  pivot_longer(
    cols = all_of(pcnm_vars),
    names_to = "PCNM",
    values_to = "value"
  )


# Make PCNM order correct

pcnm_long$PCNM <- factor(
  pcnm_long$PCNM,
  levels = pcnm_vars
)



# =============================================================================
# 4. CREATE PCNM MAP
# =============================================================================


pcnm_plot <- ggplot(pcnm_long) +
  
  geom_sf(
    aes(color = value),
    size = 2,
    alpha = 0.9
  ) +
  
  facet_wrap(
    ~PCNM,
    ncol = 3
  ) +
  
  scale_color_gradient2(
    midpoint = 0,
    name = "PCNM\nvalue"
  ) +
  
  theme_classic(base_size = 12) +
  
  theme(
    strip.text = element_text(
      face = "bold",
      size = 12
    ),
    
    axis.text = element_text(
      size = 9
    ),
    
    legend.position = "right"
  ) +
  
  labs(
    title = "Spatial structures represented by PCNM eigenvectors",
    subtitle = "Positive and negative values represent opposing spatial patterns"
  )


# Display plot

print(pcnm_plot)

OUT_WIDTH_CM <- 31
OUT_HEIGHT_CM <- 24
OUT_DPI <- 600


ggsave(
  filename = paste0("clarkii_pcnm_spatial_structures", ".png"),
  plot = pcnm_plot,
  width = OUT_WIDTH_CM,
  height = OUT_HEIGHT_CM,
  units = "cm",
  dpi = OUT_DPI,
  bg = "white"
)


##The spatial patterns for our data set can be seen in this plot 
# by pcnm 4 or 5 there is clearly confusing environmental gradients that could be ecologically 
# confouding our model. three variables seem to be preferable. 


