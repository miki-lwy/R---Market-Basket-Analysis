# R---Market-Basket-Analysis

# Purpose
This project aims at showing how to leverage Market Basket Analysis for product recommendation - something that the customers might want to buy as well. Not only does it improve the sales, but also the customer experience and the ultimate life time value. As for the offlne store, we could reduce their efforts to buy the products by putting the items which are usually bought together close to each other.

Secondly, if we use the dataset embedded in arules packages. The dataset is already transformed into class, with products categorized into diiferent levels. Here, non-pre-processed raw data is used as I want to show you how to perform market basket analysis from a scratch.

# Installation
```
Install R and R Studio
```

# Required packages
```
install.packages("pacman")
pacman::p_load(arules, arulesViz)
install.packages("readxl")
install.packages("tidyverse")
install.packages("dplyr")
```

# Dataset
https://www.kaggle.com/aerodinamicc/ecommerce-website-funnel-analysis
