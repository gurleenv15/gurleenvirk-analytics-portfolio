# Purpose:
# Load datasets and required libraries for the Illinois Workplace Wellness RCT analysis

## ----setup, include=FALSE----------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## Loading datasets
library(tidyverse)
library(haven)
claims <- read_csv("claims.csv")
online_surveys <- read_csv("online_surveys.csv")
