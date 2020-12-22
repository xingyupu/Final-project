# install cesR package
devtools::install_github("hodgettsp/cesR")
# load cesR package and labelled package
library(cesR)
library(labelled)
# call 2019 CES online survey
get_ces("ces2019_web")
# convert values to factor type
ces2019_web <- to_factor(ces2019_web)
```





library(haven)
library(tidyverse)
reduced_data_survey <- 
  ces2019_web %>% 
  select(cps19_yob,
         cps19_gender,
         cps19_province,
         cps19_education,
         cps19_votechoice
  )
reduced_data_survey <- na.omit(reduced_data_survey)
reduced_data_survey$cps19_yob <- as.numeric(reduced_data_survey$cps19_yob)
reduced_data_survey$age <- 2019 - reduced_data_survey$cps19_yob - 1919
reduced_data_survey <- 
  reduced_data_survey%>%
  rename(gender = cps19_gender,
         province = cps19_province,
         education = cps19_education,
         support_Trudeau = cps19_votechoice)
reduced_data_survey <- 
  reduced_data_survey%>%
  mutate(Vote_Trudeau =
           ifelse(support_Trudeau == 'Liberal Party', 1, 0))
reduced_data_survey <- 
  reduced_data_survey%>%
  mutate(Vote_others =
           ifelse(support_Trudeau == 'Liberal Party', 0, 1))

reduced_data_survey <- 
  reduced_data_survey%>%
  mutate(age_group =
           ifelse(age <= 25, 'less than 25', 'great than 25'))

reduced_data_survey <- 
  reduced_data_survey%>%
  mutate(edu_level = case_when(
    education == "Don't know/ Prefer not to answer" ~ 0,
    education == "No schooling" ~ 0,
    education == "Some elementary school" ~ 1,
    education == "Completed elementary school" ~ 2,
    education == "Some secondary/ high school" ~ 3,
    education == "Completed secondary/ high school" ~ 4,
    education == "Some technical, community college, CEGEP, College Classique" ~ 5,
    education == "Completed technical, community college, CEGEP, College Classique" ~ 6,
    education == "Some university" ~ 7,
    education == "Bachelor's degree" ~ 8,
    education == "Master's degree" ~ 9,
    education == "Professional degree or doctorate" ~ 10,
  ))

survey_data <-
  reduced_data_survey%>%
  select(gender,
         province,
         edu_level,
         Vote_Trudeau,
         Vote_others,
         age_group)
write_csv(survey_data, "survey_data.csv")

```

```{r, echo=FALSE, message=FALSE}
survey_data <- read.csv('survey_data.csv')
census_data <- read.csv("census_data.csv")
```