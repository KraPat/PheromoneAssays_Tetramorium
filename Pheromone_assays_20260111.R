##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--#
#Title: "Belowground ants follow pheromones more quickly under dark conditions, but pheromones do not affect decision accuracy nor aggression"

# Authors
#Patrick Krapf, Michael Mitschke, Anna Lenninger, Nico Völlenklee, Tomer J. Czaczkes, Birgit C. Schlick-Steiner, Florian M. Steiner
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--#


###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###
# Check/Install R version, packages, etc. ####
###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###

##--##--##--##--##--##--##--##--##
## R version required ####
##--##--##--##--##--##--##--##--##
required_r <- "4.3.0"

if (getRversion() != required_r) {
  stop(
    "This script requires R version ", required_r,
    ". You are using ", getRversion()
  )
}


##--##--##--##--##--##--##--##--##
## Load and install packages ####
##--##--##--##--##--##--##--##--##
packages_needed <- c("ggplot2",
                     "tidyverse",
                     "rstatix",
                     "ggpubr",
                     "tibble",
                     "dplyr",
                     "rio",
                     "readxl",
                     "rnaturalearth",
                     "rnaturalearthdata",
                     "ggspatial",
                     "sf",
                     "ggmap",
                     "stringr",
                     "ggsn",
                     "tidyr",
                     "grid" 
)

pk_to_install <- packages_needed [!( packages_needed %in% rownames(installed.packages())  )]
if(length(pk_to_install)>0 ){
  install.packages(pk_to_install,repos="http://cran.r-project.org")
}


# ##--##--##--##--##--##--##--##--##
# ## Run "renv" for version control to run this code ###
# ##--##--##--##--##--##--##--##--##
# #Info from
# #https://rstudio.github.io/renv/articles/renv.html
# # as well as from
# #https://www.statology.org/how-to-manage-r-virtual-environments-for-data-projects-renv/
# #install.packages("renv")
# library(renv)
# renv::init() #adds three new files and directories to your project, library, lockfile, and project R profile
# 
# #The next important pair of tools is renv::snapshot() and renv::restore(). This pair of functions gives you the benefits of reproducibility and portability: you are now tracking exactly which package versions you have installed so you can recreate them on other machines.
# #snapshot() updates the lockfile with metadata about the currently-used packages in the project library. This is useful because you can then share the lockfile and other people or other computers can easily reproduce your current environment by running restore(), which uses the metadata from the lockfile to install exactly the same version of every package. Now that you’ve got the high-level lay of the land, we’ll show a couple of specific workflows before discussing some of the reproducibility challenges that renv doesn’t currently help with.
# 
# #After installing or updating packages, record the state of your environment by running
# renv::snapshot()
# #This updates the renv.lock file with the exact versions of packages currently in use. This file is essential for reproducing the environment later.
# 
# 
# #When you or a collaborator clone a project with an renv.lock file, you can recreate the exact environment using
# renv::restore() 
# #This command reads the renv.lock file and installs the correct package versions into a new project-local library.
# 
# #Cleaning Up
# #Over time, your project environment may accumulate unused or outdated packages. To keep things tidy and efficient, renv provides tools to help with cleanup and optimization.
# #1. Removing Unused Packages
# #To identify and remove packages that are no longer used in your project:
# renv::clean()
# #This function scans your project and helps you remove unused packages from the local library.


###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###
# Fig 1 - Map + inset ####
###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###---###

###---###---###---###---###---###---###
## Load packages, setwd, and load data ####
###---###---###---###---###---###---###
library(readxl); library("rnaturalearth"); library("rnaturalearthdata"); library("ggspatial"); library("sf"); library("ggmap"); library(ggplot2); library("viridis"); library("stringr"); library("ggsn")

# setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/")
# dataset_map <- readxl::read_xlsx("Ameisenkolonien.xlsx", sheet="R_Map")
setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/")
dataset_map <- readxl::read_xlsx("Dataset.xlsx", sheet="R_Map")
head(dataset_map)


###---###---###---###---###---###---###
## Load Europe tiles with stadia maps ####
###---###---###---###---###---###---###
##Europe
area <- c(left = 5, bottom = 35, right = 35 , top = 50) #all Europe  
map2 <- get_stadiamap(area, zoom = 5, maptype = "stamen_toner_lite", color="color") 


###---###---###---###---###---###---###
### Save PDF ####
###---###---###---###---###---###---###
pdf("Pheromones_Map_20260112.pdf")
#Europe_PW_20240610 former map
ggmap(map2) +
  ylab("Latitude")+
  xlab("Longitude")+ 
  geom_point(aes(y=dataset_map$Lat[1], x=dataset_map$Lon[1]), size=4, fill="#df2016", colour="black",pch=21) +  #Jaufenpass
  geom_point(aes(y=dataset_map$Lat[5], x=dataset_map$Lon[5]), size=4, fill="#6800bd", colour="black",pch=21) + #Kuehtai
  geom_point(aes(y=dataset_map$Lat[8], x=dataset_map$Lon[8]), size=4, fill="#0097f5", colour="black",pch=21) + #Hahntennjoch
  geom_point(aes(y=dataset_map$Lat[11], x=dataset_map$Lon[11]), size=4, fill="#f57a00", colour="black",pch=21) + #Penser Joch
  theme(plot.title = element_text(size=25),
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
dev.off()


###---###---###---###---###---###---###
## Create inset with detailed locations ####
###---###---###---###---###---###---###
area <- c(left = 10, bottom = 46.50, right = 12.00 , top = 47.5) #Austria
map3 <- get_stadiamap(area, zoom = 9, maptype = "stamen_terrain_background", color="color")  

###---###---###---###---###---###---###
### Save PDF ####
###---###---###---###---###---###---###
pdf("Austria_Italy_PW_20260112.pdf")
ggmap(map3)+
  ylab("Latitude")+
  xlab("Longitude")+
  geom_point(aes(y=dataset_map$Lat[1], x=dataset_map$Lon[1]), size=7, fill="#df2016", colour="black",pch=21) +  #Jaufenpass
  geom_point(aes(y=dataset_map$Lat[5], x=dataset_map$Lon[5]), size=7, fill="#6800bd", colour="black",pch=21) + #Kuehait
  geom_point(aes(y=dataset_map$Lat[8], x=dataset_map$Lon[8]), size=7, fill="#0097f5", colour="black",pch=21) + #Hahntennjoch
  geom_point(aes(y=dataset_map$Lat[11], x=dataset_map$Lon[11]), size=7, fill="#f57a00", colour="black",pch=21) + #Penser Joch
  
  geom_point(aes(y= 47.259659, x=11.400375) , size=4, fill="black", colour="black",pch=21) +  #Innsbruck
  annotate("text", y=47.259659, x=11.400375+0.2, label="Innsbruck", size=6, colour="black") + 
  annotate("text", y=47.40, x=10.75, label="Austria", size=11, colour="black") + 
  annotate("text", y=46.75, x=10.75, label="Italy", size=11, colour="black") + 
  theme(plot.title = element_text(size=25),
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
dev.off()
#END Fig1


##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
#   Q1. ABOVE- VS BELOWGROUND ASSAYS      ####
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##
# Important note: The aboveground assays were termed "bright" and the belowground assays "dark" in the section Q1

##--##--##--##--##--##--##--##--##--##--##
##   Load packages, set wd and load data     ####
##--##--##--##--##--##--##--##--##--##--##
library(dplyr)

# setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/Files_digitised")
# phero <- readxl::read_xlsx("Bright_dark_assay_.xlsx", sheet=1)
setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/")
phero <- readxl::read_xlsx("Dataset", sheet="Assay_AboveBelowground")
head(phero)

# Check how often decisions where made on the left and right side and no decision
table(phero$decision)
#84+76+24 #left, no dec, right
#tot 184

##--##--##--##--##--##--##--##--##--##--##
##   Descriptive statistics     ####
##--##--##--##--##--##--##--##--##--##--##

##--##--##--##--##
### Check if use same amount of L and R arm sides ####
##--##--##--##--##
#Below, we check whether we use the left and right (L, R) sides of the armes equally often in B = Bright D= Dark assays
table(phero$colony_id, phero$side_artif_phero, phero$bright_dark)

#Now, we exclude missing data (i.e. "NA")
phero_ <- phero %>%
  filter(correct != "") %>%
  as_tibble()

#We again check the numbers of test on left and right side ...
table(phero_$colony_id, phero_$side_artif_phero, phero_$bright_dark)
table(phero_$side_artif_phero, phero_$bright_dark)

# ... and conduct a binomial test whether the numbers used are sig different
binom.test(x=80, n=(80+80), p=.5, alternative = "two.sided") #
#No difference


##--##--##--##--##
### Binomial test if workers decided more often for left or right ####
##--##--##--##--##
#First, we have a look at the decision
table(phero_$decision)

#Then, we run the binomial test
binom.test(x=84, n=(84+76), p=.5, alternative = "two.sided") #
#Workers do not decide for left or right more frequently.


##--##--##--##--##
### Observer bias ####
##--##--##--##--##
#Now, we test if there is an observer bias of the two people running the assays
#First, we split the data into the observers
phero_MM <- phero %>%
  filter(correct != "" & Observer=="MM") %>%
  as_tibble()
phero_PK <- phero %>%
  filter(correct != "" & Observer=="PK") %>%
  as_tibble()

#Now, we separate the data into "bright" and "dark" and exclude missing values
bright_MM <- phero %>%
  filter(bright_dark  == "B" & correct != "" & Observer=="MM") %>%
  as_tibble()
dark_MM <- phero %>%
  filter(bright_dark == "D" & correct != "" & Observer=="MM") %>%
  as_tibble()

bright_PK <- phero %>%
  filter(bright_dark  == "B" & correct != "" & Observer=="PK") %>%
  as_tibble()
dark_PK <- phero %>%
  filter(bright_dark == "D" & correct != "" & Observer=="PK") %>%
  as_tibble()


##--##--##--##--##
### Chi-square test for observer bias ####
##--##--##--##--##
#First, we extract the data from the data, ie how often the observer recorded following and not following for the bright and dark assays
table(phero_MM$bright_dark, phero_MM$correct)
table(phero_PK$bright_dark, phero_PK$correct)

#We then combine this into a table and run a Chi-Square test
M <- as.table(rbind(c(6, 35, 1, 38), c(5, 36, 4, 35)))
dimnames(M) <- list(bright_dark = c("B", "D"),
                    correct = c("n_MM","y_MM", "n_PK", "y_PK"))
M
(Xsq <- chisq.test(M))  # Prints test summary
#Result: NO OBSERVER BIAS IN BRIGHT DARK ASSAYS


##--##--##--##--##--##--##--##--##--##--##
## Q1.1 Do T. ants follow pheromones under bright or dark conditions more often?   ####
##--##--##--##--##--##--##--##--##--##--##

#First, some descriptive stats
#Extract the data, note all data 
table(phero$bright_dark) #102B, 82D, total 184 tests
table(phero$decision) # L=84, R=76, no_dec = 24


##--##--##--##--##
###    Chi-square test testing whether ants follow pheromones more often ####
##--##--##--##--##
#Extract the data, combine them into a table and run the test
table(phero$bright_dark, phero$correct)
M <- as.table(rbind(c(7, 73), c(9, 71)))
dimnames(M) <- list(bright_dark = c("B", "D"),
                    correct = c("n","y")) 
M
(Xsq <- chisq.test(M))  # Prints test summary
#Res: No difference in choice


##--##--##--##--##
### Above- vs below-ground Binomial tests ###
##--##--##--##--##
#Aboveground
table(phero$bright_dark, phero$correct)
binom.test(x=73, n=80, p=.5, alternative = "two.sided") ##MS

#Belowground
binom.test(x=71, n=80, p=.5, alternative = "two.sided") ##MS



##--##--##--##--##
### Plot decision frequency #####
##--##--##--##--##
library(ggpubr)

#To plot the data, we exclude missing values, which were not used in the analysis anyway
phero_ <- phero %>%
  filter(correct != "") %>%
  as_tibble()

#Create plot
BrightDark_Following <- ggplot(phero_, aes(x=bright_dark , fill=correct))+ #y=decision
  geom_bar(position="dodge", color="black")+
  ylab("Frequency of decisions")+
  xlab("")+
  coord_cartesian(ylim = c(0,80)) +
  scale_y_continuous(breaks=seq(0,85,10)) +
  geom_text(
    stat = "count",
    aes(label = ..count..),
    position = position_dodge(width = 0.9),
    vjust = -0.5
  ) +
  scale_x_discrete(breaks=c("B", "D"),
                   labels=c("Aboveground", "Belowground")) +
  scale_fill_manual(values=c("#f4a162","#42923f"),
                    name ="Decision",
                    breaks=c("n", "y"),
                    labels = c("Not following", "Following")) +
  theme_bw() +
  theme(plot.title = element_text(size=25),
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        legend.position="none",
        panel.grid.minor.x = element_blank())
BrightDark_Following




##--##--##--##--##--##--##--##--##--##--##
##  Q1.2  Do decision times between bright and dark differ?        ####
##--##--##--##--##--##--##--##--##--##--##

##--##--##--##--##
#First, we select data and exclude missing values ###
##--##--##--##--##
bright_ <- phero %>%
  filter(bright_dark  == "B" & correct != "") %>%
  as_tibble()
dark_ <- phero %>%
  filter(bright_dark == "D" & correct != "") %>%
  as_tibble()

##--##--##--##--##
### Are decision times normally distributed? ###
##--##--##--##--##
shapiro.test(bright_$dec3)
shapiro.test(dark_$dec3)
#Both not normally distributed

##--##--##--##--##
### Calculate means and compare decision times using a Mann-Whitney-U-test ####
##--##--##--##--##
#Means
mean(bright_$dec3) #122.05
mean(dark_$dec3) #53.1625
# Mann-Whitney U test
wilcox.test(bright_$dec3, dark_$dec3)  ##MS
#Yes, decision times differ. IN dark conditions, decisions is reached sig faster.


##--##--##--##--##
### Plot bright dark decision time ####
##--##--##--##--##

BrightDark_DecTimes <- ggplot(phero_, aes(x=bright_dark , y=dec3, fill=bright_dark))+
  geom_boxplot()+
  ylab("Seconds until ants reached decision")+
  xlab("")+
  scale_x_discrete(breaks=c("B", "D"),
                   labels=c("Aboveground", "Aboveground")) +
  scale_fill_manual(values=c("#ffff9f","#617090"),  #    #ffffff  #707070
                    name ="Assay", 
                    labels = c("Aboveground", "Aboveground")) +
  geom_signif(
    comparisons = list(c("B", "D")),
    map_signif_level = TRUE) + 
  theme_bw() + 
  theme(plot.title = element_text(size=25),
   # legend.justification=c(0.1,0.4), legend.position=c(0.6901,0.6501),
   legend.position="none",
   axis.title.x = element_text(size=17),
   axis.text.x  = element_text(size=13, color="black"),
   axis.title.y = element_text(size=17),
   axis.text.y  = element_text(size=13, color="black"),
   panel.border = element_rect(colour = "black", fill=NA, size=1),
   panel.grid.minor.x = element_blank())
BrightDark_DecTimes


##--##--##--##--##
## Q1.3 Does the decision time differ between correct and wrong decision?  ####
##--##--##--##--##

##--##--##--##--##
### Aboveground assays ####
##--##--##--##--##
# Basically, do we see speed-accuracy trade-off?
# Split data into bright and dark and following (correct) and not following (not correct) using the data set with excluded values (phero_)
bright_Corr <- phero_ %>%
  filter(bright_dark  == "B" & correct == "y") %>%
  as_tibble()
bright_Wrong <- phero_ %>%
  filter(bright_dark  == "B" & correct == "n") %>%
  as_tibble()


##--##--##--##--##
#### Are decision times normally distributed? ####
##--##--##--##--##
#For aboveground ...
#...following
shapiro.test(bright_Corr$dec3) 
#not follogin
shapiro.test(bright_Wrong$dec3) 

##--##--##--##--##
#### Calculate means and Mann-Whitney U test  ####
##--##--##--##--##
# Means
mean(bright_Wrong$dec3) #87.86
mean(bright_Corr$dec3) #125.33

#Mann-Whitney U test
wilcox.test(bright_Wrong$dec3, bright_Corr$dec3) 
#NO sig diff


##--##--##--##--##
### Belowground assays ####
##--##--##--##--##

# Split data into bright and dark and following (correct) and not following (not correct) using the data set with excluded values (phero_)
dark_Corr <- phero_ %>%
  filter(bright_dark  == "D" & correct == "y") %>%
  as_tibble()
dark_Wrong <- phero_ %>%
  filter(bright_dark  == "D" & correct == "n") %>%
  as_tibble()


##--##--##--##--##
#### Are decision times normally distributed? ####
##--##--##--##--##
shapiro.test(dark_Corr$dec3) #
shapiro.test(dark_Wrong$dec3) #
#both not normally distributed

##--##--##--##--##
#### Calculate means and Mann-Whitney U test  ####
##--##--##--##--##
# Means
mean(dark_Wrong$dec3) #60.11
mean(dark_Corr$dec3) #52.28

#Mann-Whitney U test
wilcox.test(dark_Wrong$dec3, dark_Corr$dec3)
#not sig different

##--##--##--##--##
#### Plot dark and bright correct and wrong ####
##--##--##--##--##
BrightDark_SpeedAccuracy <- 
ggplot(phero_, aes(x=correct , y=dec3, fill=correct))+
  geom_boxplot()+
  facet_grid(~bright_dark, labeller = as_labeller(c("B"='Aboveground assays',
                                              "D"='Beloweground assays'))) +
  ylab("Seconds until ants crossed decision line")+
  xlab("")+
  scale_x_discrete(breaks=c("n", "y"),
                   labels=c("Not following", "Following")) +
  scale_fill_manual(values=c("#f4a162","#42923f"), #values=c("purple","#89ea37"),
                    name ="Assay",
                    labels = c("Not following", "Following")) +
  theme_bw() + 
  theme(plot.title = element_text(size=25),
        # legend.justification=c(0.1,0.4), legend.position=c(0.6901,0.6501),
        legend.position="none",
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
BrightDark_SpeedAccuracy


###---###---###---###---###---###---###
## Figure 2 - Above- vs belowground assays ####
###---###---###---###---###---###---###
library(ggpubr)
# Plot Brigt and Dark assays in compound figure
pdf("Fig2_BrightDark_20260112.pdf", width = 12, height = 5.84)  # half of 11.69 height
ggarrange(BrightDark_Following,
          BrightDark_DecTimes,
          BrightDark_SpeedAccuracy, 
          labels = c("A)", "B)", "C)"),  # Add custom labels
          nrow=1, ncol=3, legend="bottom", align = "h") #ncol=5, 
dev.off()



##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--#
#  Q2    MASS RECRUITMENT          ####
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--#

###---###---###---###---###---###---###
## Load packages, setwd, and load data ####
###---###---###---###---###---###---###
library(dplyr)

##set wd and load data
# setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/Files_digitised")
# mass_ <- readxl::read_xlsx("Auswertung_Mass_MM_PK.xlsx", sheet=1)
setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/")
mass_ <- readxl::read_xlsx("Dataset", sheet="Assay_NAT_GAS")

# Check how often decisions where made on the left and right side and no decision
head(mass_)
table(mass_$decision) #128+117+24
128+117+24
#269 total number of tests

#Now exclude all missing values
mass_ <- mass_ %>%
  filter(correct_all != "NA") %>%
  as_tibble()
#Note, we have three levels: mass, 5G, mass_5G
# "mass" = mass recruitment pheromone trails termed NAT vs ethanol as control termed CON
# "5G" = gaster extract from 5 gasters termed GAS, used as GAS vs CON
# "mass_5G" = NAT vs GAS

##Check left and right side for each assay
#table(mass_$assay, mass_$decision)


##--##--##--##--##--##--##--##--##--##--##
##   Descriptive statistics     ####
##--##--##--##--##--##--##--##--##--##--##

##--##--##--##--##
### Check if use same amount of L and R arm sides ####
##--##--##--##--##

##--##--##
#### NAT vs CON ####
##--##--##
#also called mass vs ethanol or blank

#Select NAT assays only ...
massAssay <- subset(mass_, assay=="mass")

#... and exclude missing values
massAssay_ <- massAssay %>%
  filter(correct_mass != "NA") %>%
  as_tibble()
table(massAssay_$colony_id, massAssay_$side_mass)
table(massAssay_$assay, massAssay_$side_mass)

# ... and conduct a binomial test whether the numbers used are sig different
binom.test(x=41, n=(41+39), p=.5, alternative = "two.sided") #
#slightly more often left than right

# #We again check the numbers of test on left and right side ...
# table(massAssay$colony_id, massAssay$decision)
# table(mass_$assay, mass_$correct_mass)
# #30 did not follow, 50 did follow
# #slightly more often left than right


##--##--##
#### NAT vs GAS ####
##--##--##
#Select NAT and GAS assays only ...
mass_5GAssay <- subset(mass_, assay=="mass_5G")

# ... Exclude missing values
mass_5GAssay_ <- mass_5GAssay %>%
  filter(correct_mass != "NA") %>%
  as_tibble()

#Check values ...
table(mass_5GAssay_$assay, mass_5GAssay_$side_mass)

#... and conduct a binomial test whether the numbers used are sig different
binom.test(x=44, n=(44+41), p=.5, alternative = "two.sided") #
#more or less equal 


##--##--##
#### GAS vs CON ####
##--##--##
#Select GAS assays only ...
G5Assay <- subset(mass_, assay=="5G")

# ... exclude missing values
G5Assay_ <- G5Assay %>%
  filter(correct_5G != "NA") %>%
  as_tibble()

# Check values ...
table(G5Assay_$assay, G5Assay_$side_5G)

# ... and conduct a binomial test whether the numbers used are sig different
binom.test(x=40, n=(40+40), p=.5, alternative = "two.sided") #
#not sig diff



##--##--##--##--##
### Binomial test if workers decided more often for left or right ####
##--##--##--##--##

##--##--##
#### NAT vs CON Binomial test####
##--##--##
table(massAssay_$decision)
47+33 #80
binom.test(x=47, n=80, p=.5, alternative = "two.sided") #ns

##--##--##
#### GAS vs NAT Binomial test####
##--##--##
table(mass_5GAssay_$decision)
35+50 #85 ###?
binom.test(x=35, n=85, p=.5, alternative = "two.sided") #ns

##--##--##
#### GAS vs CON Binomial test####
##--##--##
table(G5Assay$decision)
46+34 #80
binom.test(x=46, n=80, p=.5, alternative = "two.sided") #ns
#all three above not sid different between L or R decision
#no left/right bias in mass


##--##--##--##--##
### Observer bias ####
##--##--##--##--##

##--##--##
#### NAT vs CON ####
##--##--##

#Now, we test if there is an observer bias of the two people running the assays
#First, we split the data into the observers
massAssay_PK <- massAssay_ %>%
  filter(observer=="Patrick") %>%
  as_tibble()
massAssay_MM <- massAssay_ %>%
  filter(observer=="Michael") %>%
  as_tibble()


##--##--##--##--##
##### Chi-square test for observer bias in NAT ####
##--##--##--##--##
#First, we extract the data, ie how often the observer recorded following and not following for NAT
table(massAssay_$observer, massAssay_$correct_mass)

#We then combine this into a table and run a Chi-Square test
M <- as.table(rbind(c(11, 29), c(19, 21)))
dimnames(M) <- list(bright_dark = c("Michael", "Patrick"),
                    correct = c("n", "y"))
M
(Xsq <- chisq.test(M))  # Prints test summary
#in mass assay, no sig difference between observer, i.e., no observer bias in mass recruitment


##--##--##
#### GAS vs CON ####
##--##--##
#First, we extract the data, ie how often the observer recorded following and not following for GAS
table(G5Assay_$observer, G5Assay_$correct_5G)

##--##--##--##--##
##### Chi-square test for observer bias in GAS ####
##--##--##--##--##
#We then combine this into a table and run a Chi-Square test
M <- as.table(rbind(c(8, 22), c(8, 42)))
dimnames(M) <- list(bright_dark = c("Michael", "Patrick"),
                    correct = c("n", "y"))
M
(Xsq <- chisq.test(M))  # Prints test summary
#in GAS, no sig difference between observer, i.e., no observer bias in mass recruitment


##--##--##
#### GAS vs CON ####
##--##--##
#First, we extract the data, ie how often the observer recorded following and not following for GAS vs NAT
table(mass_5GAssay_$observer, mass_5GAssay_$correct_5G) + table(mass_5GAssay_$observer, mass_5GAssay_$correct_mass)

##--##--##--##--##
##### Chi-square test for observer bias in GAS vs NAT####
##--##--##--##--##
#We then combine this into a table and run a Chi-Square test
M <- as.table(rbind(c(50, 50), c(35, 35)))
dimnames(M) <- list(bright_dark = c("Michael", "Patrick"),
                    correct = c("n", "y"))
M
(Xsq <- chisq.test(M))  # Prints test summary
#In GAS vs NAT, no sig difference between observer, i.e., no observer bias


##--##--##--##--##
### Test if papers from mass recruitment loose pheromones over time and affect assay ####
##--##--##--##--##
# Papers are called alpha, beta, delta, epsilon, gamma, zeta

##--##--##
#### NAT vs CON ####
##--##--##
#Exclude missing data
massAssay_ <- mass_ %>%
  filter(correct_mass != "NA") %>%
  as_tibble()

#Check how many papers we have
factor(massAssay_$paper)
#Since we have six papers, we split them split into 3 and 3, called "A" and "B"
#A = alpha beta gamma
#B = delta epsilon zeta

#Separate pheromones
massAssay_A = massAssay_ %>% 
  filter(paper %in% c("alpha", "beta", "gamma")) %>%
  as_tibble()

massAssay_B = massAssay_ %>%
  filter(paper %in% c("delta", "epsilon", "zeta")) %>%
  as_tibble()

#Check numbers of workers following pheromones
table(massAssay_A$correct_mass) #ratio: 65/47 = 1.38
table(massAssay_B$correct_mass) #ratio: 30/23 = 1.30
#ratio quite similar


##--##--##--##--##
##### Chi-square test for observer bias ####
##--##--##--##--##
#table(massAssay_A$bright_dark, massAssay_A$correct_mass)
#table(phero_PK$bright_dark, phero_PK$correct_mass)
M <- as.table(rbind(c(65, 47), c(30, 23)))
dimnames(M) <- list(bright_dark = c("Papers_A", "Papers_B"),
                    correct = c("n","y"))
M
(Xsq <- chisq.test(M))  # Prints test summary
#Hyp: Are the correct/wrong decision made different in Papers B (older paper) from Papers A (younger paper)
#not sig different
binom.test(x=65, n=(65+47), p=.5, alternative = "two.sided")
binom.test(x=30, n=(30+23), p=.5, alternative = "two.sided")
#although more often not following, no sig difference


##--##--##--##--##
##### Are decision times normally distributed? ####
##--##--##--##--## 
#Select pheromone papers
massAssay_A = massAssay_ %>% 
  filter(paper %in% c("alpha", "beta", "gamma")) %>%
  as_tibble()

massAssay_B = massAssay_ %>%
  filter(paper %in% c("delta", "epsilon", "zeta")) %>%
  as_tibble()

#Run Shapiro-Wilk test
shapiro.test(massAssay_A$time_decision3) #sig
shapiro.test(massAssay_B$time_decision3) #sig
#both are sig different

#Means and Mann-Whitney-U test
#hyp: difference between decision times in 
mean(massAssay_A$time_decision3) #72.22
mean(massAssay_B$time_decision3) #78.81

#Mean test
wilcox.test(massAssay_A$time_decision3, massAssay_B$time_decision3)
#There is no sig difference between the data




###---###---###---###---###---###---###
## Q2.1 Do ants follow NAT or GAS or CON more often? ####
###---###---###---###---###---###---###

#First, we have a look at the different values
table(massAssay$correct_mass)
#Ants followed NAT more frequently than CON
table(mass_5GAssay$correct_mass)
#Ants followed GAS more frequently than NAT
table(G5Assay$correct_5G) 
#Ants followed GAS more frequently than CON


##--##--##--##--##
### Chi-square test testing whether ants follow one of the pheromones more frequently ####
##--##--##--##--##

#Combine into table and run test
M <- as.table(rbind(c(16, 64), c(65, 20), c(30, 50)))
dimnames(M) <- list(assays = c("5G", "G5_mass", "mass"),
                    correct = c("n","y"))
M
(Xsq <- chisq.test(M))  # Prints test summary


##--##--##
#### NAT vs CON ####
##--##--##
table(massAssay$correct_mass)  ##MS
binom.test(x=50, n=80, p=.5, alternative = "two.sided")

##--##--##
#### GAS vs CON ####
##--##--##
table(G5Assay$correct_5G)  ##MS
binom.test(x=64, n=80, p=.5, alternative = "two.sided")

##--##--##
#### GAS vs NAT ####
##--##--##
table(mass_5GAssay$correct_mass)  ##MS
binom.test(x=65, n=85, p=.5, alternative = "two.sided")

#Additional proportion test
#GAS vs NAT (ie GAS following vs natural trail following)
M <- as.table(rbind(c(16, 64), c(30, 50)))
prop.test(x = c(64, 50), n = c(80, 80), correct = T)
#80% following GAS vs 62.5% following NAT



##--##--##--##--##
### Plot Frequency of decision ####
##--##--##--##--##

Mass_frequency <- ggplot(mass_, aes(x=correct_combined, fill=correct_combined))+ #y=decision
  geom_bar(stat="count", col="black")+
  facet_grid(~assay, labeller = as_labeller(c("5G"='GAS vs CTR -\n Following GAS',
                                              "mass"='NAT vs CTR -\n Following NAT',
                                              "mass_5G"='NAT vs GAS -\n Following GAS'))) +
  ylim(0, 70) +
  coord_cartesian(ylim=c(0,70)) +
  scale_y_continuous(breaks=seq(0,70,10)) +
  ylab("Frequency of decisions")+
  xlab("Decision")  +  #
  geom_text(
    stat = "count",
    aes(label = ..count..),
    position = position_dodge(width = 0.9),
    vjust = -0.5
  ) +
  scale_x_discrete(breaks=c("n", "y"),
                   labels = c("Not following", "Following")) +
  scale_fill_manual(values=c("#f4a162","#42923f"),
                    name ="Decision",
                    breaks=c("n", "y"),
                    labels = c("Not following", "Following")) +
  theme_bw() +
  theme(plot.title = element_text(size=25),
        axis.title.x = element_text(size=17),
        axis.text.x  = element_blank(), #element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
Mass_frequency


###---###---###---###---###---###---###
##  Q2.2: Does the decision time differ between the pheromones ####
###---###---###---###---###---###---###

#First, exclude missing values
#NAT vs CON
massAssaySec = massAssay %>%
  filter(decision  != "X") %>%
  as_tibble()
#GAS vs NAT
mass_5GAssaySec = mass_5GAssay %>%
  filter(decision  != "X") %>%
  as_tibble()
#GAS vs CON
G5AssaySec = G5Assay %>%
  filter(decision  != "X") %>%
  as_tibble()


##--##--##--##--##
#### Are decision times normally distributed? ####
##--##--##--##--##

##--##--##--##--##
##### 'NAT vs CON' against 'GAS vs CON' ####
##--##--##--##--##
#NAT vs CON
shapiro.test(massAssaySec$time_decision3) #sig

#GAS vs NAT
shapiro.test(mass_5GAssaySec$time_decision3) #sig

#GAS vs CON
shapiro.test(G5AssaySec$time_decision3) #sig
#all not normally distributed


##--##--##--##--##
###### Calculate means and Mann-Whitney U test  ####
##--##--##--##--##
#Means
#GAS vs CON
mean(G5AssaySec$time_decision3) #65.46

#NAT vs CON
mean(massAssaySec$time_decision3) #85.31

#Mann-Whitney U 'GAS vs CON' against 'NAT vs CON'
wilcox.test(massAssaySec$time_decision3, G5AssaySec$time_decision3)


##--##--##--##--##
##### 'NAT vs CON' against 'GAS vs NAT' ####
##--##--##--##--##
#Means
#GAS vs NAT
mean(mass_5GAssaySec$time_decision3) #64.01176

#NAT vs CON
mean(massAssaySec$time_decision3) #85.31

#Mann-Whitney U 'GAS vs NAT' against 'NAT vs CON'
wilcox.test(massAssaySec$time_decision3, mass_5GAssaySec$time_decision3) #


##--##--##--##--##
##### 'GAS vs CON' against 'GAS vs NAT' ####
##--##--##--##--##
#Means
#GAS vs CON
mean(mass_5GAssaySec$time_decision3) #64.01176

#GAS vs NAT
mean(G5AssaySec$time_decision3) #65.4625

#Mann-Whitney U 'GAS vs CON' against 'GAS vs NAT'
wilcox.test(mass_5GAssaySec$time_decision3, G5AssaySec$time_decision3)


##--##--##--##--##
#### Bonferroni-Holm correction ####
##--##--##--##--##
#for the three values above
p.adjust(c(0.003, 0.0214, 0.8602))
#Both sig values remain significant



##--##--##--##--##
### Plot Decision times for Q2 ####
##--##--##--##--##
library(ggpubr)

Mass_DecisionTimes <- ggplot(mass_, aes(x=assay , y=time_decision3, fill=assay))+
  geom_boxplot()+
  ylab("Seconds until ants reached a decision")+  #rename
  xlab("")+
  scale_x_discrete(breaks=c("5G", "mass", "mass_5G"),
                   labels=c("GAS vs CON - \n Following GAS",
                            "NAT vs CON - \n Following NAT",
                            "NAT vs GAS - \n Following GAS")) +
  scale_fill_manual(values=c("#c2df23","#2ab07f", "#38588c"), #values=c("orange","darkgreen", "blue"),
                    name ="Assay",
                    labels=c("GAS vs CON - \n Following GAS",
                             "NAT vs CON - \n Following NAT",
                             "NAT vs GAS - \n Following GAS")) +
  geom_signif(
    comparisons = list(c("5G", "mass")),
    map_signif_level = TRUE,
    y_position = 315) +
  # geom_signif(
  #   comparisons = list(c("5G", "mass_5G")),
  #   map_signif_level = TRUE,
  #   y_position = 340) +
  geom_signif(
    comparisons = list(c("mass", "mass_5G")),
    map_signif_level = TRUE,
    y_position = 365) +
  theme_bw() + 
  theme(plot.title = element_text(size=25),
        axis.title.x = element_text(size=17),
        axis.text.x  = element_blank(), #element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
Mass_DecisionTimes


###---###---###---###---###---###---###
##  Q2.3 Does the decision time differ between following and not following? ####
###---###---###---###---###---###---###
#speed-accuracy bias?

#First, separae data sets into following and not following
#NAT vs CON
massAssaySec_Corr = massAssay_ %>%
  filter(correct_mass  == "y") %>%
  as_tibble()
massAssaySec_Wrong = massAssay_ %>%
  filter(correct_mass  == "n") %>%
  as_tibble()

#GAS vs NAT
G5AssaySec_Corr = G5Assay_ %>%
  filter(correct_5G  == "y") %>%
  as_tibble()
G5AssaySec_Wrong = G5Assay_ %>%
  filter(correct_5G  == "n") %>%
  as_tibble()

#GAS vs CON
mass_5GAssaySec_Corr = mass_5GAssay_ %>%
  filter(correct_5G  == "y") %>%
  as_tibble()
mass_5GAssaySec_Wrong = mass_5GAssay_ %>%
  filter(correct_5G  == "n") %>%
  as_tibble()

mass_5GAssaySec_Corr = mass_5GAssay_ %>%
  filter(correct_5G  == "y") %>%
  as_tibble()
mass__5GAssaySec_Corr = mass_5GAssay_ %>%
  filter(correct_mass  == "y") %>%
  as_tibble()


##--##--##
#### NAT vs CON ####
##--##--##

##--##--##--##--##
##### Are decision times normally distributed? ####
##--##--##--##--##
shapiro.test(massAssaySec_Corr$time_decision3) #sig
shapiro.test(massAssaySec_Wrong$time_decision3) #sig
#no, so Mann-Whitney-U

##--##--##--##--##
##### Means and Mann-Whtiney U tests ####
##--##--##--##--##
mean(massAssaySec_Corr$time_decision3) #79.51
mean(massAssaySec_Wrong$time_decision3) #70.53

#Mann-Whitney-U
wilcox.test(massAssaySec_Corr$time_decision3, massAssaySec_Wrong$time_decision3) ##MS


##--##--##
#### GAS vs CON ####
##--##--##

##--##--##--##--##
##### Are decision times normally distributed? ####
##--##--##--##--##
shapiro.test(G5AssaySec_Corr$time_decision3) #
shapiro.test(G5AssaySec_Wrong$time_decision3) #
#sig -> wilxcox


##--##--##--##--##
##### Means and Mann-Whitney U tests ####
##--##--##--##--##
#Means
mean(G5AssaySec_Corr$time_decision3) #67.98
mean(G5AssaySec_Wrong$time_decision3) #55.38

#Mann-Whitney-U
wilcox.test(G5AssaySec_Corr$time_decision3, G5AssaySec_Wrong$time_decision3) ##MS



##--##--##
#### GAS vs NAT ####
##--##--##

##--##--##--##--##
##### Are decision times normally distributed? ####
##--##--##--##--##
shapiro.test(mass_5GAssaySec_Corr$time_decision3) #sig
shapiro.test(mass_5GAssaySec_Wrong$time_decision3) #sig
#sig -> wilxcox


##--##--##--##--##
##### Means and Mann-Whitney U tests ####
##--##--##--##--##
#Means
mean(mass_5GAssaySec_Corr$time_decision3) #64.85
mean(mass_5GAssaySec_Wrong$time_decision3) #61.30

#Mann-Whitney-U
wilcox.test(mass_5GAssaySec_Corr$time_decision3, mass_5GAssaySec_Wrong$time_decision3) ##MS


##--##--##--##--##
### Plot Decision times for following and not following Q2.3 ####
##--##--##--##--##
Mass_SpeedAcc <- ggplot(mass_, aes(x=correct_combined , y=time_decision3, fill=correct_combined))+
  geom_boxplot()+
  facet_grid(~assay, labeller = as_labeller(c("5G"='GAS vs CON -\n Following GAS',
                                              "mass"='NAT vs CON -\n Following NAT',
                                              "mass_5G"='NAT vs GAS -\n Following GAS'))) +
  ylab("Seconds until ants crossed decision line")+
  xlab("Decision")+
  scale_x_discrete(breaks=c("n", "y"),
                   labels=c("Not following", "Following")) +
  scale_fill_manual(values=c("#f4a162","#42923f"), #values=c("purple","#89ea37"),
                    name ="Assay",
                    labels = c("Not following", "Following")) +
  # geom_signif(
  #   comparisons = list(c("y", "n")),
  #   test = "wilcox.test",
  #   map_signif_level = TRUE) + 
  theme_bw() + 
  theme(plot.title = element_text(size=25),
        # legend.justification=c(0.1,0.4), legend.position=c(0.6901,0.6501),
        axis.title.x = element_text(size=17),
        axis.text.x  = element_blank(), #element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
Mass_SpeedAcc


###---###---###---###---###---###---###
## Figure 3 - Pheromone following: NAT vs CON, GAS  vs CON, GAS vs NAT ####
###---###---###---###---###---###---###
## Compound figure 2 Mass ####
pdf("Fig3_Mass_20260112.pdf", width = 12, height = 5.84)  # half of 11.69 height
ggarrange(Mass_frequency, 
          Mass_DecisionTimes,
          Mass_SpeedAcc, 
          label.x = 0,
          labels = c("A)", "B)", "C)"),  # Add custom labels
          nrow=1, ncol=3, legend="bottom", align = "h") #ncol=5, 
dev.off()



##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--#
# Q3  AGGRESSION ASSAYS  ####
##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--##--#

###---###---###---###---###---###---###
## Load packages, setwd, and load data ####
###---###---###---###---###---###---###
library(readxl); library(ggpubr); library(dplyr)


# setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/Agg_Auswertung_Filme/")
# #Tet = read.table("C:/Users/c7701110/Desktop/PheromoneAssays/auswertung/Project21_Aggression_Stand_3-10-21.xlsx", header = T)
# #Tet <- read_excel("Anna_Nico_AggAuswertung_20230418.xlsx", sheet="Auswertung_changed")
# Tet <- read_excel("Tet1_20250718_mod_EK_pk_20251210.xlsx", sheet="Sheet1")
#Note: this file above "Tet1_20250718_mod_EK_pk_20251210.xlsx" is after Evelina Krol from UIBK has double-checked missing/uncertain videos and now, we can re-analyse the behaviours
setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/")
Tet <- readxl::read_xlsx("Dataset", sheet="Assay_Aggression")


#Already select only aggressive encounters for Q3.4-Q3.6
Tet$EncBeh
Tet_agg <- subset(Tet, EncBeh=="agg")


##NOTE Tet1 is the same as Tet, but only with combined "loc_paper"
loc_paper <- Tet %>%
  dplyr::mutate(loc_paper = paste(loc, paper_red, sep = "_"))

Tet1 <- loc_paper
Tet1 <- as_tibble(Tet1)


# #Combine columns for the pheromones
# loc_paper_agg <- Tet_agg %>%
#   dplyr::mutate(loc_paper = paste(loc, paper_red, sep = "_"))
# 
# Tet1_agg <- loc_paper_agg
# Tet1_agg <- as_tibble(Tet1_agg)
# Tet1_agg$loc_paper
# length(Tet1_agg$loc_paper)


##--##--##--##--##--##--##--##
## Descriptive stats ####
##--##--##--##--##--##--##--##

#How many workers have been tested?
length(Tet$paper)


# ##--##--##--##--##--##--##--##
# #### Plot aggression data for pops and pheromones ###
# ##--##--##--##--##--##--##--##
# table(Tet$AI_calc)
# 
# pdf("FigS_AI_Pheromones.pdf")
# ggplot(Tet1, aes(x= loc_paper, y= AI_calc, fill= loc_paper))+
#   geom_boxplot()+
#   #facet_grid(~loc)+
#   ylab(label = "Behaviour index")+
#   xlab(label = "Pheromones")+
#   # scale_x_discrete(breaks=c("blanco", "Extract", "Nest"),
#   #                   labels = c("Control", "5G extract", "24h nest odour")) +
#   scale_fill_manual(name="Pheromones", #breaks=c("blanco", "Extract", "Nest"),
#                     labels = c("Hahntennjoch CON", "Hahntennjoch GAS", " Hahntennjoch24H", 
#                                "Jaufenpass CON", "Jaufenpass GAS", "Jaufenpass 24H",
#                                "Kuehtai CON", "Kuehtai GAS", "Kuehtai 24H",
#                                "Penser Joch CON", "Penser Joch GAS", "Penser Joch 24H"),
#                     values = c(rep(c("white", "lightblue", "orange"), 4))) +
#   # scale_fill_manual(name="Populations",
#   #                   values=c("#6800bd" ,"#df2016", "#0097f5", "#f57a00")) +
#   coord_cartesian(ylim=c(-4, 5)) +
#   scale_y_continuous(breaks=seq(-4, 5, 1)) +
#   # geom_signif(
#   #   comparisons = list(c("Hahntennjoch", "Jaufenpass")), 
#   #   #y_position = 315,
#   #   map_signif_level = TRUE) +
#   theme_bw() +
#   theme(plot.title = element_text(size=25),
#         # legend.justification=c(0.1,0.4), legend.position=c(0.6901,0.6501),
#         axis.title.x = element_text(size=17),
#         #axis.text.x  = element_blank(), #element_text(size=13, color="black"),
#         axis.text.x  = element_text(size=13, color="black"),
#         axis.title.y = element_text(size=17),
#         axis.text.y  = element_text(size=13, color="black"),
#         #panel.border = element_rect(colour = "black", fill=NA, size=1),
#         panel.grid.minor.x = element_blank())
# dev.off()



##--##--##--##--##--##--##--##
### Q3.1 Behavioural differences across pheromones ####
##--##--##--##--##--##--##--##

##--##--##--##--##--##--##--##
#### Separate pheromone data and calculate means ####
##--##--##--##--##--##--##--##
#CON
control = Tet %>%
  filter(paper_red  == "blanco") %>%
  as_tibble()
mean(control$AI_calc, na.rm = T)  #1.055 

#GAS
Extract5G = Tet %>%
  filter(paper_red  == "Extract") %>%
  as_tibble()
mean(Extract5G$AI_calc, na.rm = T)  # 0.82  slightly agg

#24H
Nest = Tet %>%s
  filter(paper_red  == "Nest") %>%
  as_tibble()
mean(Nest$AI_calc, na.rm = T)  # 0.84


##--##--##
##### Calculate means for each pheromone ####
##--##--##
#CON
mean(Kuehtai_control$AI_calc, na.rm = T)  #-0.26
#GAS
mean(Kuehtai_5G$AI_calc, na.rm = T)  #-0.24
#24H
mean(Kuehtai_24h$AI_calc, na.rm = T)  #-0.29

##--##--##
##### Check whether aggression data is normally distributed ####
##--##--##
#CON
shapiro.test(control$AI_calc)  #sig
#GAS
shapiro.test(Extract5G$AI_calc)  #sig
#24H
shapiro.test(Nest$AI_calc)  #sig

##--##--##
##### Pairwise comparison ####
##--##--##
pairwise.wilcox.test(Tet$AI_calc, g=Tet$paper_red, metod="BH")
#No difference in aggression level between the three pheromone set ups


##--##--##--##--##--##--##--##
##### Plot aggression data for pheromones ####
##--##--##--##--##--##--##--##
AI_pheromones <- ggplot(Tet, aes(x= paper_red, y= AI_calc, fill= paper_red))+
  geom_boxplot()+
  #facet_grid(~loc)+
  ylab(label = "Behaviour index")+
  xlab(label = "Pheromones")+
  scale_x_discrete(breaks=c("blanco", "Extract", "Nest"),
                   labels = c(expression(italic("CON")),
                              expression(italic("GAS")),
                              expression(italic("24H")))) +
  scale_fill_manual(name="Pheromones", breaks=c("blanco", "Extract", "Nest"),
                    labels = c("CON", "GAS", "24H"),
                    values=c("white", "lightblue", "orange")) +
  coord_cartesian(ylim=c(-4, 5)) +
  scale_y_continuous(breaks=seq(-4, 5, 1)) +
  theme_bw() +
  theme(plot.title = element_text(size=25),
        # legend.justification=c(0.1,0.4), legend.position=c(0.6901,0.6501),
        legend.position="none",
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
AI_pheromones



##--##--##--##--##--##--##--##
### Q3.2 Are behaviour levels different across populations ####
##--##--##--##--##--##--##--##

##--##--##--##--##--##--##--##
#### Separate each population  ####
##--##--##--##--##--##--##--##
#Jaufenpass
Jaufen = Tet %>%
  filter(loc  == "Jaufenpass") %>%
  as_tibble()

#Kuehtai
Kuehtai = Tet %>%
  filter(loc  == "Kuehtai") %>%
  as_tibble()

#Hahntennjoch
Hahnten = Tet %>%
  filter(loc  == "Hahntennjoch") %>%
  as_tibble()

#Penser Joch
Penser = Tet %>%
  filter(loc  == "Penser Joch") %>%
  as_tibble()


##--##--##--##--##--##--##--##
#### Are aggression data between populations normally distributed ####
##--##--##--##--##--##--##--##
shapiro.test(Hahnten$AI_calc)  #sig
shapiro.test(Jaufen$AI_calc)  #sig
shapiro.test(Kuehtai$AI_calc)  #sig
shapiro.test(Penser$AI_calc)  #sig


##--##--##--##--##--##--##--##
#### Calculate means check if pheromones used differ WITHIN pops ####
##--##--##--##--##--##--##--##
#Hahntenmjoch
mean(Hahnten$AI_mean, na.rm = T)  #0.637093
#Jaufenpass
mean(Jaufen$AI_mean, na.rm = T)  #1.667 
#Kuehtai
mean(Kuehtai$AI_mean, na.rm = T)  #-0.26486
#Penser Joch
mean(Penser$AI_mean, na.rm = T)  #1.502


##--##--##--##--##--##--##--##
#### Calculate pairwise comparisons between pops ####
##--##--##--##--##--##--##--##
pairwise.wilcox.test(Tet$AI_calc, g=Tet$loc)
#sig difference between pops


##--##--##--##--##--##--##--##
#### Plot aggression data for pops ####
##--##--##--##--##--##--##--##
AI_pops <- ggplot(Tet, aes(x= loc, y= AI_calc, fill= loc))+
  geom_boxplot(alpha=0.8)+
  ylab(label = "Behaviour index")+
  xlab(label = "Pheromones")+
  scale_fill_manual(name="Populations",
                    values=c("#6a7a00cc" ,"#df2016", "#0097f5", "#8000bd91")) +
  coord_cartesian(ylim=c(-4, 6)) +
  scale_y_continuous(breaks=seq(-4, 5, 1)) +
  
  geom_signif(
    comparisons = list(c("Hahntennjoch", "Jaufenpass")),
    y_position = 4,
    map_signif_level = TRUE) +
  geom_signif(
    comparisons = list(c("Hahntennjoch", "Kuehtai")),
    y_position = 4.5,
    map_signif_level = TRUE) +
  geom_signif(
    comparisons = list(c("Hahntennjoch", "Penser Joch")),
    y_position = 5.1,
    map_signif_level = TRUE) +
  
  geom_signif(
    comparisons = list(c("Jaufenpass", "Kuehtai")),
    y_position = 5.7,
    map_signif_level = TRUE) +
 
  geom_signif(
    comparisons = list(c("Kuehtai", "Penser Joch")),
    y_position = 4,
    map_signif_level = TRUE) +
  
  theme_bw() +
  theme(plot.title = element_text(size=25),
        legend.position="none",
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
AI_pops



##--##--##--##--##--##--##--##
## Q3.3 Do behaviour levels differ between pheromones within populations ####
##--##--##--##--##--##--##--##

##--##--##--##--##--##--##--##
### Subset each population for each pheromone ####
##--##--##--##--##--##--##--##

##--##--##--##--##--##--##--##
#### Hahntennjoch ####
##--##--##--##--##--##--##--##
#CON
Hahnten_control = Hahnten %>%
  filter(paper_red  == "blanco") %>%
  as_tibble()

#GAS
Hahnten_5G = Hahnten %>%
  filter(paper_red  == "Extract") %>%
  as_tibble()

#24H
Hahnten_24h = Hahnten %>%
  filter(paper_red  == "Nest") %>%
  as_tibble()


##--##--##
##### Check whether aggression data is normally distributed ####
##--##--##
#CON
shapiro.test(Hahnten_control$AI_calc) #sig  
#GAS
shapiro.test(Hahnten_5G$AI_calc)  #sig
#24H
shapiro.test(Hahnten_24h$AI_calc) #sig

##--##--##
##### Calculate means for each pheromone ####
##--##--##
#CON
mean(Hahnten_control$AI_calc, na.rm = T)  #0.66
#GAS
mean(Hahnten_5G$AI_calc, na.rm = T)  #0.50
#24H
mean(Hahnten_24h$AI_calc, na.rm = T)  #0.76

##--##--##
##### Pairwise comparison ####
##--##--##
pairwise.wilcox.test(Hahnten$AI_calc, g=Hahnten$paper_red, method="BH")
#Not significant among Hahtenn


##--##--##--##--##--##--##--##
#### Jaufenpass ####
##--##--##--##--##--##--##--##
#Jaufen CON
Jaufen_control = Jaufen %>%
  filter(paper_red  == "blanco") %>%
  as_tibble()

#GAS
Jaufen_5G = Jaufen %>%
  filter(paper_red  == "Extract") %>%
  as_tibble()

#24H
Jaufen_24h = Jaufen %>%
  filter(paper_red  == "Nest") %>%
  as_tibble()


##--##--##
##### Check whether aggression data is normally distributed ####
##--##--##
#CON
shapiro.test(Jaufen_control$AI_calc) 
#GAS
shapiro.test(Jaufen_5G$AI_calc)  
#24H
shapiro.test(Jaufen_24h$AI_calc) #sig

##--##--##
##### Calculate means for each pheromone ####
##--##--##
#CON
mean(Jaufen_control$AI_calc, na.rm = T)  #1.94
#GAS
mean(Jaufen_5G$AI_calc, na.rm = T)  #1.54
#24H
mean(Jaufen_24h$AI_calc, na.rm = T)  #1.65

##--##--##
##### Pairwise comparison ####
##--##--##
pairwise.wilcox.test(Jaufen$AI_calc, g=Jaufen$paper_red, method="BH")
#Not significant among Jaufen


##--##--##--##--##--##--##--##
#### Kühtai ####
##--##--##--##--##--##--##--##
#CON
Kuehtai_control = Kuehtai %>%
  filter(paper_red  == "blanco") %>%
  as_tibble()
#GAS
Kuehtai_5G = Kuehtai %>%
  filter(paper_red  == "Extract") %>%
  as_tibble()
#24H
Kuehtai_24h = Kuehtai %>%
  filter(paper_red  == "Nest") %>%
  as_tibble()


##--##--##
##### Check whether aggression data is normally distributed ####
##--##--##
#CON
shapiro.test(Kuehtai_control$AI_calc) #sig  
#GAS
shapiro.test(Kuehtai_5G$AI_calc)   #sig
#24H
shapiro.test(Kuehtai_24h$AI_calc) #sig

##--##--##
##### Calculate means for each pheromone ####
##--##--##
#CON
mean(Kuehtai_control$AI_calc, na.rm = T)  #-0.26
#GAS
mean(Kuehtai_5G$AI_calc, na.rm = T)  #-0.24
#24H
mean(Kuehtai_24h$AI_calc, na.rm = T)  #-0.29

##--##--##
##### Pairwise comparison ####
##--##--##
pairwise.wilcox.test(Kuehtai$AI_calc, g=Kuehtai$paper_red, method="BH")
#Not significant among Kuehtai


##--##--##--##--##--##--##--##
#### Penser Joch ####
##--##--##--##--##--##--##--##
#CON
Penser_control = Penser %>%
  filter(paper_red  == "blanco") %>%
  as_tibble()
#GAS
Penser_5G = Penser %>%
  filter(paper_red  == "Extract") %>%
  as_tibble()
#24H
Penser_24h = Penser %>%
  filter(paper_red  == "Nest") %>%
  as_tibble()

##--##--##
##### Check whether aggression data is normally distributed ####
##--##--##
#CON
shapiro.test(Penser_control$AI_calc) #sig  
#GAS
shapiro.test(Penser_5G$AI_calc)  #sig
#24H
shapiro.test(Penser_24h$AI_calc) #sig

##--##--##
##### Calculate means for each pheromone ####
##--##--##
#CON
mean(Penser_control$AI_calc, na.rm = T)  #1.89
#GAS
mean(Penser_5G$AI_calc, na.rm = T)  #1.49
#24H
mean(Penser_24h$AI_calc, na.rm = T)  #1.32

##--##--##
##### Pairwise comparison ####
##--##--##
pairwise.wilcox.test(Penser$AI_calc, g=Penser$paper_red, method="BH")
#Not significant among Penser

#OVERALL RESULT: NOT SIGNIFCANT WITHIN POPS, so combine all values


##--##--##--##--##--##--##--##
#### Plot aggression data for pops ####
##--##--##--##--##--##--##--##

AI_Pheromones_Pops <- ggplot(Tet1, aes(x= paper_red, y= AI_calc, fill= paper_red))+
  geom_boxplot(alpha=0.8)+
  facet_grid(~loc)+
  ylab(label = "Behaviour index")+
  xlab(label = "Pheromones")+
  scale_x_discrete(breaks=c("blanco", "Extract", "Nest"),
                   labels = c(expression(italic("CON")),
                              expression(italic("GAS")),
                              expression(italic("24H")))) +
  # scale_fill_manual(name="Populations",
  #                   values=c("#6a7a00cc" ,"#df2016", "#0097f5", "#8000bd91")) +
  scale_x_discrete(breaks=c("blanco", "Extract", "Nest"),
                   labels = c(expression(italic("CON")),
                              expression(italic("GAS")),
                              expression(italic("24H")))) +
  scale_fill_manual(name="Pheromones", breaks=c("blanco", "Extract", "Nest"),
                    labels = c("CON", "GAS", "24H"),
                    values=c("white", "lightblue", "orange")) +
  coord_cartesian(ylim=c(-4, 6)) +
  scale_y_continuous(breaks=seq(-4, 5, 1)) +
  theme_bw() +
  theme(plot.title = element_text(size=25),
        # legend.justification=c(0.1,0.4), legend.position=c(0.6901,0.6501),
        #legend.position = "bottom", 
        legend.position="none",
        axis.title.x = element_text(size=17),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=17),
        axis.text.y  = element_text(size=13, color="black"),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        panel.grid.minor.x = element_blank())
AI_Pheromones_Pops


##--##--##--##--##--##--##--##
## Q3.4 Do pheromones affect whether workers are aggressive? ####
##--##--##--##--##--##--##--##

###---###---###---###---###---###---###
### Load packages, setwd, and load data ####
###---###---###---###---###---###---###
library(readxl); library(ggpubr); library(ggplot2); library(dplyr)

## NEW selection based on Evelina and my analysis 20260109####
# setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/Agg_Auswertung_Filme/")
# #Tet = read.table("C:/Users/c7701110/Desktop/PheromoneAssays/auswertung/Project21_Aggression_Stand_3-10-21.xlsx", header = T)
# #Tet <- read_excel("Anna_Nico_AggAuswertung_20230418.xlsx", sheet="Auswertung_changed")
# Tet1_modEvel <- read_excel("Tet1_20250718_mod_EK_pk_20251210.xlsx")

setwd("C:/Users/krapf/OneDrive/Desktop/PheromoneAssays/auswertung/")
Tet1_modEvel <- readxl::read_xlsx("Dataset", sheet="Assay_Aggression")

#Below, we select only aggressive encounters ...
Tet1_mod_agg <- subset(Tet1_modEvel, EncBeh=="agg")
table(Tet1_mod_agg$BehWorkers)
#156 each, 

#... and only individuals that started agg
Tet1_mod_agg_WorkersStartAgg <- subset(Tet1_modEvel, BehWorkers=="StartAgg")


###---###---###---###---###---###---###
#### Get number of (aggressive) workers for each pheromone ####
###---###---###---###---###---###---###
#Number of workers per pheromone
table(Tet1_modEvel$paper_red)

#Number of aggressive workers per pheromone
table(Tet1_mod_agg$paper_red)
#blanco 68; extract 130; nest: 118

###---###---###---###---###---###---###
#### Combine values and conduct a Proportion test ####
###---###---###---###---###---###---###
#blanco,  extract, nest
aggs <- c(68, 130, 114) #only agg data
totals    <- c(120, 240, 240) ## totals
prop.test(x = aggs, n = totals)


###---###---###---###---###---###---###
#### Plot data ####
###---###---###---###---###---###---###
#Now, store results in variable and plot below
Tet1_plot <- matrix(NA, nrow=3, ncol=3,
                    dimnames = list(c("blanco", "extract", "nest"),
                                    c("paper_red", "n", "prop")))
Tet1_plot[1:3,1] <- c("blanco", "extract", "nest")
Tet1_plot[1:3,2] <- c(68, 130, 114)
Tet1_plot[1:3,3] <- c(56.7, 54.2, 47.5) #proportions aka percentages based on the calcualtion
Tet1_plot <- as_tibble(Tet1_plot)
Tet1_plot$n <- as.numeric(Tet1_plot$n)
Tet1_plot$prop <- as.numeric(Tet1_plot$prop)
Tet1_plot


RelProp_Agg_Phero <- ggplot(Tet1_plot, aes(x = paper_red, y=prop,
                                           fill=paper_red, color="black")) +
  geom_bar(stat = "identity", position="dodge", color="black") +
  coord_cartesian(ylim=c(0,100)) +
  theme_bw() +
  geom_text(aes(label = n), vjust = -0.5, color="black") +
  labs(x = "Pheromones", y = "Relative proportions of aggressive \n workers across pheromones") +
  scale_fill_manual(name="Pheromones",
                    breaks=c("blanco", "extract", "nest"),
                    values=c("white", "lightblue", "orange")) +
  scale_color_manual(name="Pheromones",
                     breaks=c("blanco", "extract", "nest"),
                     values=c("white", "lightblue", "orange")) +
  scale_x_discrete(breaks=c("blanco", "extract", "nest"),
                   labels = c(expression(italic("CON")),
                              expression(italic("GAS")),
                              expression(italic("24H")))) +
  theme(plot.title = element_text(size=22),
        legend.position="none",
        axis.title.x = element_text(size=15),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=15),
        axis.text.y  = element_text(size=13, color="black"),
        panel.grid.minor.x = element_blank())
RelProp_Agg_Phero



##--##--##--##--##--##--##--##
## Q3.5 Did workers that were first worker introduced also start aggression? ####
##--##--##--##--##--##--##--##
library(dplyr)

## NEW selection based on Evelina and my analysis 20260109####
#First, we select only aggressive encoutners
Tet1_mod_agg <- subset(Tet1_modEvel, EncBeh=="agg")

##--##--##--##--##--##--##--##
### Extract data - number of workers that ####
##--##--##--##--##--##--##--##
#We check how many ...
#instances we have for "Reacted" and "Started aggression"
table(Tet1_mod_agg$BehFirstWorker)
#Reacted StartAgg 
#67       88

# #number of encounters per pheromone
# table(Tet1_mod_agg$paper_red)/2  #
# #blanco Extract    Nest 
# #    34      65      57
# 
# #number of workers per pheromone
# table(Tet1_mod_agg$paper_red)  
# #blanco Extract    Nest 
# #     68     130     11

# numberof workers per pheromone and reacted or started aggression
table(Tet1_mod_agg$BehFirstWorker, Tet1_mod_agg$paper_red)
#          blanco Extract Nest
# Reacted      12      29   26
# StartAgg     22      35   31
22+35+31 #88 workers


# ##--##--##--##--##--##--##--##
# ### Calculate relative percentages ###
# ##--##--##--##--##--##--##--##
# Tet1_mod_agg_summary <- Tet1_mod_agg %>%
#   count(BehFirstWorker, paper_red) %>%
#   group_by(BehFirstWorker) %>%
#   mutate(prop = n/sum(n)) %>%
#   ungroup()
# Tet1_mod_agg_summary


##--##--##--##--##--##--##--##
### Calculate proportion test ####
##--##--##--##--##--##--##--##
#order: blanco, extract, nest
aggs <- c(22, 35, 31) #StartedAgg - only agg data 
totals    <- c((22+12), (35+29), (31+26)) ## total of each group (ie., 66+65 = 131; ...)
prop.test(x = aggs, n = totals, correct=T) 
#From this proportion test, we use the percentages below

#Now, store results in variable and plot below
Tet1_plot <- matrix(NA, nrow=3, ncol=3,
                    dimnames = list(c("blanco", "extract", "nest"),
                                    c("paper_red", "n", "prop")))
Tet1_plot[1:3,1] <- c("blanco", "extract", "nest")
Tet1_plot[1:3,2] <- c(22, 35, 31)
Tet1_plot[1:3,3] <- c(65, 55, 54) #proportions aka percentages based on the prop.test above
Tet1_plot <- as_tibble(Tet1_plot)
Tet1_plot$n <- as.numeric(Tet1_plot$n)
Tet1_plot$prop <- as.numeric(Tet1_plot$prop)
Tet1_plot


##--##--##--##--##--##--##--##
### Plot data ####
##--##--##--##--##--##--##--##
RelProp_Agg_Phero_FirstWorker <- ggplot(Tet1_plot, aes(x = paper_red, y=prop,
                                           fill=paper_red)) +
  geom_bar(stat = "identity", position="dodge", color="black") +
   coord_cartesian(ylim=c(0,100)) +
  theme_bw() +
  geom_text(aes(label = n), vjust = -0.5) +
  labs(x = "Pheromones", y = "Relative proportions of first \n workers starting aggression") +
  scale_fill_manual(name="Pheromones",
                    breaks=c("blanco", "extract", "nest"),
                    values=c("white", "lightblue", "orange")) +
  scale_color_manual(name="Pheromones",
                     breaks=c("blanco", "extract", "nest"),
                     values=c("white", "lightblue", "orange")) +
  scale_x_discrete(breaks=c("blanco", "extract", "nest"),
                   labels = c(expression(italic("CON")),
                              expression(italic("GAS")),
                              expression(italic("24H")))) +
  theme(plot.title = element_text(size=22),
        legend.position="none",
        axis.title.x = element_text(size=15),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=15),
        axis.text.y  = element_text(size=13, color="black"),
        panel.grid.minor.x = element_blank())
RelProp_Agg_Phero_FirstWorker


##--##--##--##--##--##--##--##
### Q3.6 Is the time to start aggression influenced by the pheromones ####
##--##--##--##--##--##--##--##

## NEW selection based on Evelina and my analysis 20260109####
#First, we select only aggressive encoutners
Tet1_modEvel <- read_excel("Tet1_20250718_mod_EK_pk_20251210.xlsx")
Tet1_mod_agg <- subset(Tet1_modEvel, EncBeh=="agg")
length(Tet1_mod_agg$EncBeh) #312
length(Tet1_mod_agg$BehFirstWorker) #

# and only workers that started aggression
Tet1_mod_agg_Start <- subset(Tet1_mod_agg, BehFirstWorker=="StartAgg")
Tet1_mod_agg_Start$START_sec


##--##--##--##--##
#### Are time data to start aggression normally distributed? ####
##--##--##--##--##
#Shapiro-wilk test
#CON
shapiro.test(subset(Tet1_mod_agg_Start, paper_red=="blanco")$first_timepoint_index) #sig
#GAS
shapiro.test(subset(Tet1_mod_agg_Start, paper_red=="Extract")$first_timepoint_index) #sig
#24H
shapiro.test(subset(Tet1_mod_agg_Start, paper_red=="Nest")$first_timepoint_index) #sig

##--##--##--##--##
#### Calculate means ####
##--##--##--##--##
#CON
round(mean(subset(Tet1_mod_agg_Start, paper_red=="blanco")$first_timepoint_index, na.rm = T),
      digits = 2)  #11.91
#GAS
round(mean(subset(Tet1_mod_agg_Start, paper_red=="Extract")$first_timepoint_index, na.rm = T),
      digits = 2) #15.37
#24H
round(mean(subset(Tet1_mod_agg_Start, paper_red=="Nest")$first_timepoint_index, na.rm = T),
      digits = 2) #16.39


##--##--##--##--##
#### Pairwise tests to compare means ####
##--##--##--##--##
pairwise.wilcox.test(x = Tet1_mod_agg_Start$first_timepoint_index,
                     g = Tet1_mod_agg_Start$paper_red)


##--##--##--##--##--##--##--##
#### Plot time until start of aggression ####
##--##--##--##--##--##--##--##
StartAgg_Phero <- ggplot(Tet1_mod_agg_Start,
                         aes(x=paper_red, y=START_sec, fill=paper_red)) +
  geom_boxplot() +
  geom_jitter(width=0.3, alpha=0.2) +
  theme_bw() +
  labs(x = "Pheromones", y = "Seconds until start of aggression") +
  scale_fill_manual(name="Pheromones",
                    breaks=c("blanco", "Extract", "Nest"),
                    labels = c("Control", "GAS", "24h nest odour"),
                    values=c("white", "lightblue", "orange")) +
  scale_x_discrete(breaks=c("blanco", "Extract", "Nest"),
                   labels = c(expression(italic("CON")),
                              expression(italic("GAS")),
                              expression(italic("24H")))) +
  
  theme(plot.title = element_text(size=22),
        legend.position="none",
        axis.title.x = element_text(size=15),
        axis.text.x  = element_text(size=13, color="black"),
        axis.title.y = element_text(size=15),
        axis.text.y  = element_text(size=13, color="black"),
        panel.grid.minor.x = element_blank())
StartAgg_Phero


##--##--##--##--##--##--##--##
#### Fig 4 Aggression data ####
##--##--##--##--##--##--##--##
# Plot all Aggression data ####
library(ggpubr)
pdf("Fig4_Compound_Agg_20260109.pdf", width = 8.27, height = 11.69) #
ggarrange(AI_pheromones,
          AI_pops,
          AI_Pheromones_Pops,
          RelProp_Agg_Phero,
          RelProp_Agg_Phero_FirstWorker,
          StartAgg_Phero, #
          labels = c("A)", "B)", "C)", "D)", "E)", "F)"),
          ncol = 2, nrow = 3, align="v", legend = NULL)
dev.off()

#END OF SCRIPT AND ANALYSIS

