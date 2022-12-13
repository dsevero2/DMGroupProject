library(tidyverse)
library(polite)
library(rvest)
library(purrr)
library(readxl)

session <- bow(
  url = 'https://water.org/',  # base URL
  user_agent = "Megan Haught (BC)",  # identify ourselves
  force = TRUE
)

URL_BASE1 <- 'https://water.org/our-impact/where-we-work/'

COUNTRY_NAME <- "kenya"

URL_TO_SCRAPE1 <- paste0(URL_BASE1, COUNTRY_NAME, "/") 
print(URL_TO_SCRAPE1)
html_doc1 <- read_html(paste0(URL_BASE1, COUNTRY_NAME, "/"))


scrape_it_polite <- function(COUNTRY_NAME1){    
  URL_BASE2 <- 'https://water.org/our-impact/where-we-work/'
  html_doc2 <- read_html(paste0(URL_BASE2, COUNTRY_NAME1, "/"))
  # Same stuff as in the previous function.
  dropbucket1 <- data.frame(
    country = COUNTRY_NAME1,
    people_served= html_text(html_nodes(html_doc2, ".impact-stat__number")),
    stringsAsFactors = FALSE)
  return(dropbucket1)
}

dropbucket10 <- scrape_it_polite(COUNTRY_NAME1 = "kenya")

proj_list= as.list(water_org_countries$country)
proj_list

df_list <- list()
for (country in proj_list) {
  print(paste0('Scraping Country: ', country))
  # Call the scraping function
  df_list[[country]] <- scrape_it_polite(country)
}
all_dfs <- bind_rows(df_list)

final_df <- all_dfs %>%
  group_by(country) %>%
  filter(row_number()==1)
