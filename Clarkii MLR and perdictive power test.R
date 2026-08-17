## this is the MLR script. Here the model is made, values are predicted for gps coordinates,
## and these values are ran against ROC

##install.packages("data.frame")
#install.packages("ggpubr")
#library(data.frame)
library(pROC)
library(ggpubr)
library(ggplot2)
library(spdev)

clarkii_data <- read.csv("PCNM_results clarkii w pca.csv")

##for testing purposes later, we need to reformat the data so that we can pull out tes
##samples. Because there are so few presences, we have to use Pearson's (2007)
##"leave one out" method.

##first step is to sort the data by presence/absence

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


full.model.PCNM.c <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 #+ PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + PCNM15 + PCNM16 
                       +pca_1
                       +pca_2
                       +pca_3
                       +pca_4
                       +pca_5, data = clarkii_data #, family = "binomial"
                       )
anova(full.model.PCNM.c)
#write.csv(anova(full.model.PCNM), file = "simulans.anova.results.w.PCNM.csv", row.names = FALSE)

full.model.c <- lrm(presence ~ 
                    pca_1
                  +pca_2
                  +pca_3
                  +pca_4
                  +pca_5, data = clarkii_data #, family = "binomial"
                  )

anova(full.model.c)
#write.csv(anova(full.model), file = "simulans.anova.results.csv", row.names = FALSE)



AUC <- NULL
AUC.train <- NULL
AUC.diff <- NULL
COR <- NULL
KAPPA <- NULL
TSS <- NULL
DEV <- NULL

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
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 #+ PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + PCNM15 + PCNM16 
                         +pca_1
                         +pca_2
                         +pca_3
                         +pca_4
                         +pca_5
                         +pca_6, data = mlr.data #, family = "binomial"
               )
  
  
  
  #predict habitat suitability of absence and test presence points
  
  test.presences <- presence_data[start.row:end.row, ]
  
  test.absences <- absence_data[start.row.a:end.row.a, ]
  
  test.points <- rbind(test.presences,test.absences)
  
  habitat.suitability <- predict(model, newdata = test.points, type = "fitted")
  
  

  
  #training auc data
  
  train.habitat.suitability <- predict(model, newdata = mlr.data, type = "fitted")
  
  
  
  rocdata.train <- train.habitat.suitability
  
  rocdata2.train <- cbind(mlr.data$presence, rocdata.train)
  
  colnames(rocdata2.train) <- c("presence", "suitability")
  
  rocdata3.train <- data.frame(rocdata2.train)
  
  roc_obj.train <- roc(presence ~ suitability, rocdata3.train)
  
  AUC.train <- c(AUC.train, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
       
   
      
  AUC <- c(AUC, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff <- c(AUC.diff, auc.diff.i)
    
 
  
  
   fold.cor <- cor.test(test.points$presence, habitat.suitability, method=c("pearson"))
  
  COR <- c(COR, unlist(fold.cor[4]))
  
 
  
   threshold <- roc_obj$auc
  
  habitat.suitability.w.threshold <- ifelse(habitat.suitability >= threshold, 1, 0)
  
  suitability.prediction.vs.real <- cbind(habitat.suitability.w.threshold,test.points$presence)
  
  colnames(suitability.prediction.vs.real) <- c("prediction", "presence")
  
  suitability.prediction.vs.realdf <- as.data.frame(suitability.prediction.vs.real)
  
  predicted.present <- subset(suitability.prediction.vs.realdf, prediction == 1)
  
  predicted.absent <- subset(suitability.prediction.vs.realdf, prediction == 0)
  
  a <- length(which(predicted.present[,"presence"] == 1))
  b <- length(which(predicted.present[,"presence"] == 0))
  c <- length(which(predicted.absent[,"presence"] == 1))
  d <- length(which(predicted.absent[,"presence"] == 0))
  n <- a+b+c+d
  
  Kappa.mod1 <- (a+d)/n
  Kappa.mod2 <- (((a+b)*(a+c))+((c+d)*(d+b)))/(n*n)
  Kappa <- (Kappa.mod1-Kappa.mod2)/(1-Kappa.mod2)
  
  
  KAPPA <- c(KAPPA,Kappa)
  
  
  sensitivity <- a/(a+c)
  specificity <- d/(b+d)
  
  T.S.S <- sensitivity + specificity - 1
  
  TSS <- c(TSS, T.S.S)
  ####
  dev <- deviance(model)
  DEV <- c(DEV,dev)
 
   }
  
  avg.auc <- mean(AUC)

  avg.auc.train <- mean(AUC.train)
  
  avg.auc.diff <- mean(AUC.diff)
  
  avg.cor <- mean(COR)
  
  avg.kappa <- mean(KAPPA)
  
  avg.tss <- mean(TSS)
  
  avg.deviance <- mean(DEV)

model.perf.res <- c(avg.auc,avg.auc.diff,avg.auc.train,avg.cor,avg.deviance,avg.kappa,avg.tss)  


# Column names for each number
colnam <- c("avg auc", "avg auc dif", "avg auc train", "avg cor", "avg dev", "avg kappa", "avg tss")

# Combine into a one-row data frame
d.f <- as.data.frame(t(model.perf.res))
colnames(d.f) <- colnam

# Write to file
write.table(d.f, file = "clarkii model performance res.txt", row.names = FALSE, col.names = TRUE)




  
  # Create a function to plot response for each principal component
  plot_response_curve_ggplot <- function(model, pc_data, pc_name, n_points = 100) {
    
    # Create a new dataset: vary one PC across its range
    new_data <- as.data.frame(matrix(0, nrow = n_points, ncol = ncol(pc_data)))
    colnames(new_data) <- colnames(pc_data)
    
    # Set all other PCs to mean (or 0 if centered), vary the one of interest
    pc_range <- range(pc_data[[pc_name]])
    new_data[[pc_name]] <- seq(pc_range[1], pc_range[2], length.out = n_points)
    
    # Predict habitat suitability
    new_data$predicted_suitability <- predict(model, newdata = new_data, type = "response")
    
    # Extract only occurrence PC values
    occurrences <- pc_data
    
    # Predict habitat suitability for occurrences
    occurrences$predicted_suitability <- predict(model, newdata = occurrences, type = "response")
    
    
    pc_number <- gsub("[^0-9]", "", pc_name)
    
    # ggplot
    ggplot() +
      geom_line(data = new_data, aes_string(x = pc_name, y = "predicted_suitability"), 
                color = "blue", size = 1) +
      geom_point(data = occurrences, aes_string(x = pc_name, y = "predicted_suitability"), 
                 color = "black", size = 2, alpha = 0.6) +
      geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
      labs(x = paste0("PC", pc_number),
           y = "Habitat Suitability",
           title = paste0("Clarkii Response to PC", pc_number)) +
      theme_minimal(base_size = 14)  +
      theme(plot.title = element_text(hjust = 0.5))
  }
  
  # Example for PC1
  plot_response_curve_ggplot(full.model.PCNM, clarkii_data, "pca_1")
  
  plot_response_curve_ggplot(full.model, clarkii_data, "pca_1")
  
  
  
  #####Compute morans I to observe spatial dependencies in the models residuals
  
  
  # extract residuals for both models
  res.pcnm.c.model <- residuals(full.model.PCNM.c, type = "pearson")
  res.c.model <- residuals(full.model.c, type = "pearson")
  
  # coordinates
  coords.c <- cbind(clarkii_data$X, clarkii_data$Y)
  
  # define neighbors (K = n-nearest neighbors), how do i settle on a definitive k value?
  #AI reccomendation : k = 4–8 for dense sampling
  #                    k = 8–15 for sparse or irregular sampling
  
  knn.c <- knearneigh(coords.c, k = 5)
  nb.c <- knn2nb(knn.c)
  
  # spatial weights
  lw.c <- nb2listw(nb.c, style = "W")
  
  # Moran's I test
  moran.I.c.w.pcnm <- moran.test(res.pcnm.c.model, lw.c)
  moran.I.c <- moran.test(res.c.model,lw.c)
  
  
