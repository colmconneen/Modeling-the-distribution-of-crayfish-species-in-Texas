
species_data <- read.csv("PCNM_results simulans w pca.csv")



output_full <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 
                         +pca_1
                         +pca_2
                         +pca_3
                         +pca_4
                         +pca_5, data = species_data, family = "binomial")

# perform a model selection
drop1(output_full, test = 'F')
# -> remove PCNM13(the least significant variable)


output_1 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM14
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = species_data, family = "binomial")
drop1(output_1, test = 'F')
# -> remove PCNM 11

output_2 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM12 + PCNM14
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = species_data, family = "binomial")
drop1(output_2, test = 'F')

# -> remove PCNM14
output_3 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM12 
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = species_data, family = "binomial")
drop1(output_3, test = 'F')

# -> remove PCNM7
output_4 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6  + PCNM8 + PCNM9 + PCNM10 + PCNM12 
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = species_data, family = "binomial")
drop1(output_4, test = 'F')


# -> remove PCNM7
output_5 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3  + PCNM5 + PCNM6  + PCNM8 + PCNM9 + PCNM10 + PCNM12 
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = species_data, family = "binomial")
drop1(output_5, test = 'F')



# -> remove PCNM3
output_6 <- glm(presence ~ PCNM1  + PCNM5 + PCNM6  + PCNM8 + PCNM9 + PCNM10 + PCNM12 
                +pca_1
                +pca_2
                +pca_3
                +pca_4
                +pca_5, data = species_data, family = "binomial")
drop1(output_6, test = 'F')



####what does just 3 PCNM variables do 

output_full <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 
                   +pca_1
                   +pca_2
                   +pca_3
                   +pca_4
                   +pca_5, data = species_data, family = "binomial")







###checking for multicolliniarity in the data

library(performance)
check_collinearity(full.model.PCNM.s)
check_collinearity(model.1)


preds <- species_data[, c(
  paste0("PCNM",1:14),
  paste0("pca_",1:5)
)]


round(cor(preds), 2)




####Okay lets look at the way the each PNCM variable is defining because we have high correlation
#### between some pca variables and PCNM variabels


library(ggplot2)

ggplot(species_data, aes(x = X, y = Y, color = PCNM2)) +
  geom_point(size = 3) +
  scale_color_viridis_c() +
  coord_fixed()

ggplot(species_data, aes(x = X, y = Y, color = pca_1)) +
  geom_point(size = 3) +
  scale_color_viridis_c() +
  coord_fixed()


###regress the PCNM data on the PCA data
model <- lm(pca_1 ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + PCNM15 + PCNM16 , data = clarkii_data)
summary(model)


#####LEts look at the distribution of the data for each pca_variable see if there is 
## different distribution we need to fit with the model
p.1 <- ggplot(species_data, aes(x = pca_1, y = presence))+
  geom_point(size = 3) +
  scale_color_viridis_c() 
p.2 <- ggplot(species_data, aes(x = pca_2, y = presence))+
  geom_point(size = 3) +
  scale_color_viridis_c() 
p.3 <- ggplot(species_data, aes(x = pca_3, y = presence))+
  geom_point(size = 3) +
  scale_color_viridis_c() 
p.4 <- ggplot(species_data, aes(x = pca_4, y = presence))+
  geom_point(size = 3) +
  scale_color_viridis_c() 
p.5 <- ggplot(species_data, aes(x = pca_5, y = presence))+
  geom_point(size = 3) +
  scale_color_viridis_c() 
## Now look at the ddistribution of predicted points

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
         title = paste0("Simulans Response to PC", pc_number)) +
    theme_minimal(base_size = 14)  +
    theme(plot.title = element_text(hjust = 0.5))
}

pp.1 <- plot_response_curve_ggplot(full.model.PCNM.s, species_data, "pca_1")
pp.2 <- plot_response_curve_ggplot(full.model.PCNM.s, species_data, "pca_2")
pp.3 <- plot_response_curve_ggplot(full.model.PCNM.s, species_data, "pca_3")
pp.4 <- plot_response_curve_ggplot(full.model.PCNM.s, species_data, "pca_4")
pp.5 <- plot_response_curve_ggplot(full.model.PCNM.s, species_data, "pca_5")


p.1 + pp.1 + pppp.1
p.2 + pp.2 + pppp.2
p.3 + pp.3 + pppp.3
p.4 + pp.4 + pppp.4
p.5 + pp.5 + pppp.5

######Okay so interesting, the predicted points from the model are accurately predicting
##### Habitat suitability/ presence or absence when looking at variation across a single 
##### PC variable with all other values held at the mean.
##### Because we see this pattern do we get the same response curves when adding a response
##### curve to the presence/absence data 
##### response is super sensitive to our model

plot_response_curve_ggplot_species_data <- function(model, pc_data, pc_name, n_points = 100) {
  
  pc_number <- gsub("[^0-9]", "", pc_name)
  
  # ggplot
  ggplot() +
    geom_line(data = pc_data, aes_string(x = pc_name, y = "presence"), 
              color = "blue", size = 1) +
    geom_point(data = pc_data, aes_string(x = pc_name, y = "presence"), 
               color = "black", size = 2, alpha = 0.6) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
    labs(x = paste0("PC", pc_number),
         y = "Habitat Suitability",
         title = paste0("Simulans Response to PC", pc_number)) +
    theme_minimal(base_size = 14)  +
    theme(plot.title = element_text(hjust = 0.5))
}



ppp.1 <- plot_response_curve_ggplot_species_data(full.model.PCNM.s, species_data, "pca_1")

####wait that looks rediculous. the line added is from the prediction an the points 
#### are from the occurance. lets look at the line as it relates to predicted points

plot_response_curve_ggplot_w_predicted_points <- function(model, pc_data, pc_name, n_points = 100) {
  
  # Create a new dataset: vary one PC across its range
  new_data <- as.data.frame(matrix(0, nrow = n_points, ncol = ncol(pc_data)))
  colnames(new_data) <- colnames(pc_data)
  
  # Set all other PCs to mean (or 0 if centered), vary the one of interest
  pc_range <- range(pc_data[[pc_name]])
  new_data[[pc_name]] <- seq(pc_range[1], pc_range[2], length.out = n_points)
  
  # Predict habitat suitability
  new_data$predicted_suitability <- predict(model, newdata = new_data, type = "response")
  
  pc_number <- gsub("[^0-9]", "", pc_name)
  
  # ggplot
  ggplot() +
    geom_line(data = new_data, aes_string(x = pc_name, y = "predicted_suitability"), 
              color = "blue", size = 1) +
    geom_point(data = new_data, aes_string(x = pc_name, y = "predicted_suitability"), 
               color = "black", size = 2, alpha = 0.6) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
    labs(x = paste0("PC", pc_number),
         y = "Habitat Suitability",
         title = paste0("Simulans Response to PC", pc_number)) +
    theme_minimal(base_size = 14)  +
    theme(plot.title = element_text(hjust = 0.5))
}


pppp.1 <- plot_response_curve_ggplot_w_predicted_points(full.model.PCNM.s, species_data, "pca_1")
pppp.2 <- plot_response_curve_ggplot_w_predicted_points(full.model.PCNM.s, species_data, "pca_2")
pppp.3 <- plot_response_curve_ggplot_w_predicted_points(full.model.PCNM.s, species_data, "pca_3")
pppp.4 <- plot_response_curve_ggplot_w_predicted_points(full.model.PCNM.s, species_data, "pca_4")
pppp.5 <- plot_response_curve_ggplot_w_predicted_points(full.model.PCNM.s, species_data, "pca_5")





###### lets reurn to this idea of multicollinearity
###### 

space_model_s <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 
                       , data = species_data, family = "binomial")

anova(space_model_s, full.model.PCNM.s, test="Chisq")




#####after all this lets look at how the model preforms under only 3 PCNM varibles 


model.1 <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 
               +pca_1
               +pca_2
               +pca_3
               +pca_4
               +pca_5, data = species_data, family = "binomial")



check_collinearity(model.1)



preds <- species_data[, c(
  paste0("PCNM",1:3),
  paste0("pca_",1:5)
)]


round(cor(preds), 2)

space_model_s_n <- glm(presence ~ PCNM1 + PCNM2 + PCNM3 
                     , data = species_data, family = "binomial")



anova(space_model_s_n, model.1, test="Chisq")

###deviance is not zero overfitting / complete seperation not occurring
### lets look at some plots again


f.1  <- plot_response_curve_ggplot(model.1, species_data, "pca_1")
f.2  <- plot_response_curve_ggplot(model.1, species_data, "pca_2")
f.3  <- plot_response_curve_ggplot(model.1, species_data, "pca_3")
f.4  <- plot_response_curve_ggplot(model.1, species_data, "pca_4")
f.5  <- plot_response_curve_ggplot(model.1, species_data, "pca_5")



p.1 + f.1 
p.2 + f.2 
p.3 + f.3
p.4 + f.4 
p.5 + f.5 


##### Look at model significance now
summary(model.1)
anova(model.1)







# --------------------------------
# here I am going to repeat the auc analysis that we just performed with Clarkii
# along with this we will visualize the first 5 PCNM variables and see how the 
# spatially gradient they are defining is structured.
# --------------------------------

full.model.PCNM.S.lrm <- lrm(
  presence ~ PCNM1 + PCNM2 + PCNM3 +# PCNM4 + PCNM5 + PCNM6 + PCNM7 + PCNM8 + PCNM9 + PCNM10 + PCNM11 + PCNM12 + PCNM13 + PCNM14 + 
    pca_1 +
    pca_2 +
    pca_3 +
    pca_4 +
    pca_5,
  data = species_data
  
)

lp <- predict(full.model.PCNM.S.lrm, type = "lp")

range(lp)


predict(full.model.PCNM.S.lrm, type = "fitted.ind")

max(abs(coef(full.model.PCNM.S.lrm)))

kappa(model.matrix(full.model.PCNM.S.lrm))

full.model.PCNM.S.lrm$fail

full.model.PCNM.S.lrm


species_data_sorted <- species_data[order(species_data[,"presence"]),]

##find which row the presences begin on, and create an R object with this information
presence.begin <- min(which(species_data_sorted[,"presence"] == 1))

##find the last row of _data_sorted, and save this row number as an r object
presence.end <- max(which(species_data_sorted[,"presence"] == 1))

##find which row the absence begin on, and create an R object with this information
absence.begin <- min(which(species_data_sorted[,"presence"] == 0))

##find the last row of _data_sorted, and save this row number as an r object
absence.end <- max(which(species_data_sorted[,"presence"] == 0))

##create an object of just the presences

presence_data <- subset(species_data_sorted, presence == 1)

absence_data <- subset(species_data_sorted, presence == 0)
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






AUC.14 <- NULL
AUC.train.14 <- NULL
AUC.diff.14 <- NULL



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
  
  model <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12 + PCNM13  + PCNM14 
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
  
  AUC.train.14 <- c(AUC.train.14, roc_obj.train$auc)
  
  # test auc data
  
  rocdata <- habitat.suitability
  
  rocdata2 <- cbind(test.points$presence, rocdata)
  
  colnames(rocdata2) <- c("presence", "suitability")
  
  rocdata3 <- data.frame(rocdata2)
  
  roc_obj <- roc(presence ~ suitability, rocdata3)
  
  
  
  AUC.14 <- c(AUC.14, roc_obj$auc)
  
  auc.diff.i <- roc_obj.train$auc - roc_obj$auc
  
  AUC.diff.14 <- c(AUC.diff.14, auc.diff.i)
}


##### calculate all AUC averages and proceed to plotting
AUC.3.AVG <- mean(AUC.3)

AUC.5.AVG <- mean(AUC.5)

AUC.8.AVG <- mean(AUC.8)

AUC.12.AVG <- mean(AUC.12)

AUC.14.AVG <- mean(AUC.14)

auc.avgs <- c(AUC.3.AVG,AUC.5.AVG,AUC.8.AVG,AUC.12.AVG,AUC.14.AVG)

n.pcnm <- c(3,5,8,12,14)

auc.output <- rbind(n.pcnm, auc.avgs)

plot(auc.avgs ~ n.pcnm)


model.3 <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 #+ PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12 + PCNM13  + PCNM14 
             +pca_1
             +pca_2
             +pca_3
             +pca_4
             +pca_5
             +pca_6, data = mlr.data)

model.5 <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  #+ PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12 + PCNM13  + PCNM14 
             +pca_1
             +pca_2
             +pca_3
             +pca_4
             +pca_5
             +pca_6, data = mlr.data)

model.8 <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8# + PCNM9  + PCNM10 + PCNM11 + PCNM12 + PCNM13  + PCNM14 
             +pca_1
             +pca_2
             +pca_3
             +pca_4
             +pca_5
             +pca_6, data = mlr.data)

model.12 <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12# + PCNM13  + PCNM14 
             +pca_1
             +pca_2
             +pca_3
             +pca_4
             +pca_5
             +pca_6, data = mlr.data)

model.14 <- lrm(presence ~ PCNM1 + PCNM2 + PCNM3 + PCNM4 + PCNM5  + PCNM6 + PCNM7 + PCNM8 + PCNM9  + PCNM10 + PCNM11 + PCNM12 + PCNM13  + PCNM14 
             +pca_1
             +pca_2
             +pca_3
             +pca_4
             +pca_5
             +pca_6, data = mlr.data)

model.names <- grep("^model\\.[0-9]+$", ls(), value = TRUE)

model.list <- mget(model.names)

results.model.metric <- data.frame(
  Model = names(model.list),
  LP_Min = NA_real_,
  LP_Max = NA_real_,
  Max_Coef = NA_real_,
  Kappa = NA_real_,
  Fail = NA
)

for (i in seq_along(model.list)) {
  
  model <- model.list[[i]]
  
  lp <- predict(model, type = "lp")
  
  model.range <- range(lp)
  
  model.max <- max(abs(coef(model)))
  
  model.kappa <- kappa(model.matrix(model))
  
  model.fail <- model$fail
  
  results.model.metric$LP_Min[i]   <- model.range[1]
  results.model.metric$LP_Max[i]   <- model.range[2]
  results.model.metric$Max_Coef[i] <- model.max
  results.model.metric$Kappa[i]    <- model.kappa
  results.model.metric$Fail[i]     <- model.fail
}

### Here we see that AUC increases as you add pcnm variables, however other parts of the 
### model are effected by having such a high number of PCNM variables 

#Candidate models containing increasing numbers of PCNM variables were evaluated using 
#independent test-set AUC together with diagnostic measures of model stability. Although 
#test AUC increased from 0.775 with three PCNM variables to 0.875 with twelve and fourteen
#PCNM variables, the accompanying model diagnostics indicated progressively unstable model
#behavior. Models containing larger numbers of PCNM variables exhibited extremely large
#ranges of the linear predictor (e.g., −260 to 564), very large regression coefficients 
#(up to |β| ≈ 967), and high condition numbers (κ > 300), all of which are characteristic 
#of severe multicollinearity and near-complete separation in logistic regression. These 
#diagnostics suggest that the apparent improvement in predictive performance was achieved
#through increasingly extreme parameter estimates rather than a more robust representation 
#of the underlying ecological relationships.

#Consequently, the model containing three PCNM variables was retained as the final model.
#Although its test AUC (0.775) was lower than that of more complex models, it exhibited
#substantially more stable parameter estimates (linear predictor range −3.0 to 5.7, maximum
#coefficient |β| = 8.7), while avoiding the numerical instability associated with models 
#containing larger numbers of spatial eigenvectors. The selected model therefore represents
#a compromise between predictive performance, interpretability, and numerical stability,
#reducing the risk of overfitting while adequately accounting for broad-scale spatial 
#autocorrelation.

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

pcnm_data <- species_data


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
  "PCNM14"
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


ggsave(
  filename = output_file,
  plot = pcnm_plot,
  width = 10,
  height = 7,
  dpi = 300
)


#####Okay so some important take aways
## AUC increases with more spatial variables
# when looking at the spatial variables though, higher PCNM variables exhibit a fairly mosaic
# pattern, but are informative in the models predictability.
# however compare the outputs of lrm model with 3 vs 14 variables.
# model metrics show a very different story.




