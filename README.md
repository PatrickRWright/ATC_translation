# Translation of ATC codes to text in R

An R statistics function to return text translations of a given character vector of ATC codes based on the 
[NCBO BioPortal](https://bioportal.bioontology.org/).

## Installation

You can download/clone this repository and `source()` the code in `R/translate_ATC_codes.R` in your local R session.
An example where the repositoy has been cloned into "user's" home directory is shown below.

**Clone in bash**:  
```bash
git clone https://github.com/PatrickRWright/ATC_translation
```

**Source in R**:  
```r
source("/home/user/ATC_translation/R/translate_ATC_codes.R")
```

## Input - Usage example
```r
# vector of ATC codes
ATC_vect <- c("A02BC02", "C03BA08", "A02BC02", "A02BC02", "A07DA03", "A07DA03",
              "A02BC02", "A02BC02", "A02BC02", "A02BC02", "C10AA05", "C10AA05",
              "C10AA05", "N05BA06", "N05BA06", "N05BA06", "N06AX11", "N06AX11")
# you will need to create an account at https://bioportal.bioontology.org/ to receive an api_key 
# the key below is not real and just supposed to give you an impression of the format
api_key <- "a123b456-cd78-91e2-fgh3-4ij56kl7mno8"
# return translation at third level resolution
ATC_translated_df <- translate_ATC_codes(ATC_vect, level_depth = 3, api_key = api_key)
```

## Output

The function returns a `data.frame` with the valid input ATC codes
in the first column (`code`) and the textual names in the second column (`name`).

**Note**: 
Validity of an ID is only judged based on its length after level depth based
truncation. Thus, IDs can never be too long, only too short. IDs which are
not part of the ATC database, will not return results from the bioportal
API and are translated to NA.

```r
> ATC_translated_df
#   code                                                                name
#1  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#2  C03B                              LOW-CEILING DIURETICS, EXCL. THIAZIDES
#3  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#4  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#5  A07D                                                     ANTIPROPULSIVES
#6  A07D                                                     ANTIPROPULSIVES
#7  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#8  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#9  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#10 A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
#11 C10A                                       LIPID MODIFYING AGENTS, PLAIN
#12 C10A                                       LIPID MODIFYING AGENTS, PLAIN
#13 C10A                                       LIPID MODIFYING AGENTS, PLAIN
#14 N05B                                                         ANXIOLYTICS
#15 N05B                                                         ANXIOLYTICS
#16 N05B                                                         ANXIOLYTICS
#17 N06A                                                     ANTIDEPRESSANTS
#18 N06A                                                     ANTIDEPRESSANTS
```

## Usage scenario

Given a population of study participants it may be interesting to look at a descriptive breakdown of
medication the population was taking at a given time (e.g. baseline). Thus, if ATC coded data for the participant 
population is available `translate_ATC_codes()` can be used e.g. in conjuction with table to get a
breakdown of which types of medication were perscribed. Since ATC is hierarchically structured this
can be performed at several levels. An example using the data from above is shown below.

```r
# perform translations
ATC_translated_df_lvl_5 <- translate_ATC_codes(ATC_vect, level_depth = 5, api_key = api_key)
ATC_translated_df_lvl_4 <- translate_ATC_codes(ATC_vect, level_depth = 4, api_key = api_key)
ATC_translated_df_lvl_3 <- translate_ATC_codes(ATC_vect, level_depth = 3, api_key = api_key)
ATC_translated_df_lvl_2 <- translate_ATC_codes(ATC_vect, level_depth = 2, api_key = api_key)
ATC_translated_df_lvl_1 <- translate_ATC_codes(ATC_vect, level_depth = 1, api_key = api_key)

# show breakdowns
# level 5
table(ATC_translated_df_lvl_5$name)
#atorvastatin   loperamide    lorazepam   metolazone  mirtazapine pantoprazole 
#           3            2            3            1            2            7 

# level 4
table(ATC_translated_df_lvl_4$name)
#                                          Antipropulsives 
#                                                        2 
#                    Benzodiazepine derivative anxiolytics 
#                                                        3 
#HMG CoA reductase inhibitors, plain lipid modifying drugs 
#                                                        3 
#                             Other antidepressants in ATC 
#                                                        2 
#         Proton pump inhibitors for peptic ulcer and GORD 
#                                                        7 
#               sulfonamides, low-ceiling diuretics, plain 
#                                                        1

# level 3
table(ATC_translated_df_lvl_3$name)
#                                                    ANTIDEPRESSANTS 
#                                                                  2 
#                                                    ANTIPROPULSIVES 
#                                                                  2 
#                                                        ANXIOLYTICS 
#                                                                  3 
#DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD) 
#                                                                  7 
#                                      LIPID MODIFYING AGENTS, PLAIN 
#                                                                  3 
#                             LOW-CEILING DIURETICS, EXCL. THIAZIDES 
#                                                                  1 

# level 2
table(ATC_translated_df_lvl_2$name)
#ANTIDIARRHEALS, INTESTINAL ANTIINFLAMMATORY/ANTIINFECTIVE AGENTS 
#                                                               2 
#                                                       DIURETICS 
#                                                               1 
#                                DRUGS FOR ACID RELATED DISORDERS 
#                                                               7 
#                                          LIPID MODIFYING AGENTS 
#                                                               3 
#                                                PSYCHOANALEPTICS 
#                                                               2 
#                                                   PSYCHOLEPTICS 
#                                                               3

# level 1
table(ATC_translated_df_lvl_1$name)
#ALIMENTARY TRACT AND METABOLISM DRUGS           CARDIOVASCULAR SYSTEM DRUGS 
#                                    9                                     4 
#                 NERVOUS SYSTEM DRUGS 
                                     5 
```

## Citation
If you use this function in your work please cite:  
TDB

## References
[Anatomical Therapeutic Chemical (ATC) Classification System](https://en.wikipedia.org/wiki/Anatomical_Therapeutic_Chemical_Classification_System)  
[BioPortal publication](https://www.ncbi.nlm.nih.gov/pubmed/21672956)  
[BioPortal API help](https://www.bioontology.org/wiki/BioPortal_Help#Programming_with_the_BioPortal_API)  
