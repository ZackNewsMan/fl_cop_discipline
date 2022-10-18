library(tidyverse)
problems(complaint_offenses)
warning(complaint_discipline)
problems(complaint_discipline)

complaint_offenses %>% 
  select(complaint_nbr, offense_code, case_related, offense_comments) %>% 
  filter(offense_code == "1350"|offense_code == "1325") %>% 
  View()


# Trying it in this SQL format: 
  #sqldf('SELECT *
  # FROM df 
  # WHERE name = "Tom" OR name = "Lynn"')

install.packages(sqldf)
library(sqldf)

sqldf('SELECT complaint_nbr, offense_code, offense_seq_nbrm, case_related, offense_comments
      FROM complaint_offenses 
      WHERE offense_code = "1350" OR offense_code = "1325"')

#No SQLdf in tidyverse

# df<- select(filter(dat,name=='tom'| name=='Lynn'), c('days','name))

# THIS WORKED: I asked R to show me cases where cops faced complaints of excessive force. I used codes 1350 and 1325 per guidance from Titus
# You can use ‘&’ operator as AND and ‘|’ operator as OR to connect multiple filter conditions.
# Source: https://blog.exploratory.io/filter-data-with-dplyr-76cf5f1a258e

complaint_offenses %>% 
  select(complaint_nbr, offense_code, case_related, offense_comments) %>% 
  filter(offense_code == "1350"|offense_code == "1325") %>% 
  View()

# There are 1,766 rows. So we can say there has been 1,766 complaints of excessive force. Unsure of time period data covers.

# Going to pull out that filtered data into another section so that joining with the discipline section will be easier.

excessive <- complaint_offenses %>% 
  select(complaint_nbr, offense_code, case_related, offense_comments) %>% 
  filter(offense_code == "1350"|offense_code == "1325")

# Ok, now let's join. 

excessive_discipline <- excessive %>% 
  inner_join(complaint_discipline)

# I did an inner join, which means only data in both appears
# Did in SQL too and the merge matches. 436 rows in both. This is the query:
   # SELECT *
   # FROM complaint_discipline, excessive
   # WHERE complaint_discipline.complaint_nbr = excessive.complaint_nbr

imposed_discipline_count <- excessive_discipline %>% 
  group_by(discipline_imposed) %>% 
  summarize(count = n())

# Not sure what that means, but the discipline in these cases were most often "Rev" and "Sus/Pr". Going to export:

imposed_discipline_count %>% write_csv("imposed_discipline_count.csv", na = "")

# Going to export all of the excessive force data and then the joined data as a CSV

library(tidyverse)
excessive_discipline %>% write_csv("excessive_discipline.csv", na = "")
excessive %>% write_csv("excessive.csv", na = "")

