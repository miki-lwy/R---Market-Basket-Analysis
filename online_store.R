#### Load packages ####
pacman::p_load(arules, arulesViz)
install.packages("readxl")
install.packages("pacman")
library(readxl)
library(tidyverse)
library(dplyr)

#### Data Import ####
data <- read_excel("Online Retail.xlsx")

# Data Structure
str(data)

# Descriptive Statistics of dataset
summary(data)

# Basket data
subset_data <- data %>% 
  select(InvoiceNo, Description)

# How many items are there in each transaction
df_basket = subset_data %>%
  group_by(InvoiceNo) %>%
  summarise(
    n_total = n(),
    n_items = n_distinct(Description)
  )



# How big are baskets
df_basket %>%
  summarise(
    avg_total_items = median(n_total),
    avg_dist_items = median(n_items)
  )

# Transform InvoiceID into a factor in order to use it as a grouping attribute
subset_data$InvoiceNo = factor(subset_data$InvoiceNo)

# split into groups
data_list = split(subset_data$Description, subset_data$InvoiceNo)

# Transform to transactional dataset by coercing into transactions class
data_trx = as(data_list, "transactions")

#inspect transaction
inspect(head(data_trx)) # items are now assembled into set with one row per transaction

#inspect(data_trx[1:3])

summary(data_trx)

image(data_trx) # pattern in trx & sparcity in data

sort(table(unlist(LIST(data_trx))))


# Support - popularity of an itemset

# Confidence - how often the rule is true
# conf( X->Y) = supp(X U Y) / supp(X)
# confidence shows the percentage in which Y is bought with X

# Lift - how strong is the association
# How likelihood of itemset Y being purchased when item X is purchased 
#while taking into account the popularity of Y
#lift(X -> Y) = supp(X U Y)/ supp(X) X supp(Y)
# defined as the observed support to that expected if X and Y were independent

# Lift > 1: Y is likely to be bought with X
# Lift < 1,  Y is unlikely to be bought if X is bought

supp.cw = apriori(data_trx,  # the transactional dataset
                  # Parameter list
                  parameter = list(
                    #minimum support
                    supp=0.2, 
                    # Minimum Confidence
                    conf = 0.4,
                    # Minimum length
                    minlen=2,
                    # Target
                    target="frequent itemsets"),
                  # Appearance argument
                  appearance = list(
                    items = c("STARS GIFT TAPE", "SPACEBOY LUNCH BOX"))
                  )


rules.b.rhs = apriori(data_trx,  # the transactional dataset
                  # Parameter list
                  parameter = list(
                    #minimum support
                    supp=0.05, 
                    # Minimum Confidence
                    conf = 0.6,
                    # Minimum length
                    minlen=2,
                    # Target
                    target="rules"),
                  # Appearance argument
                  appearance = list(
                    rhs = "DOORMAT NEW ENGLAND",
                            default = "lhs"))
inspect(rules.b.rhs)
supp.all = apriori(data_trx,  # the transactional dataset
                      # Parameter list
                      parameter = list(
                        #minimum support
                        supp=0.05, 
                        # Target
                        target="frequent itemsets"))
inspect(head(sort(supp.all, by = "support"), 3))


online_rules <- apriori(data_trx, parameter = list(support = 0.02, confidence = 0.8))
inspect(head(online_rules, n = 3, by = "lift"))

subrules <- head(online_rules, n = 10, by = "lift")
inspectDT(subrules) # INTERACTIVE TABLE

" plot(ruleObject, measure, shading, method)
ruleObject : the rule object to be plotted
measure: Measure for rule interestingness (Support, Confidence, lift
shading: Measure used to color points
method: Visualisation method to be used (e.g. scatterplot, matrix, two-key plot, matrix3D))
"

plot(subrules, engine = "plotly") # interactive plot
rules_html = plot(subrules, method = "graph", engine = "htmlwidget")

library(htmlwidgets)
saveWidget(rules_html, file = "subrules_online_store.html")
saveAsGraph(subrules, file = "rules.graphml") # XML-based file format

ruleExplorer(subrules) # shiny apps

itemFrequencyPlot(
  data_trx,
  topN = 4,
  main = "Absolute Item Frequency Plot",
  type = "absolute",
  col = rainbow(4), # color bar
  ylab = "",
  cex.names = 1.2, # font size 
  horiz = FALSE # flip the bar chart horizontally
  ) # relative
df_rules = as(subrules, "data.frame")
df_rules



