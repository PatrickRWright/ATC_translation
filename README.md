# Translation of ATC codes to text in R

An R statistics function to return text translations of a given character vector of ATC codes based on the 
[NCBO BioPortal](https://bioportal.bioontology.org/).

## Installation

You can download/clone this repository and `source()` the code in `R/translate_ATC_codes.R` in your local R session.
An example where the repositoy has been cloned into user's home directory is shown below.

```r
source("/home/user/ATC_translation/R/translate_ATC_codes.R")
```

## Usage example
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

```r
> ATC_translated_df
   code                                                                name
1  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
2  C03B                              LOW-CEILING DIURETICS, EXCL. THIAZIDES
3  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
4  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
5  A07D                                                     ANTIPROPULSIVES
6  A07D                                                     ANTIPROPULSIVES
7  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
8  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
9  A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
10 A02B DRUGS FOR PEPTIC ULCER AND GASTRO-OESOPHAGEAL REFLUX DISEASE (GORD)
11 C10A                                       LIPID MODIFYING AGENTS, PLAIN
12 C10A                                       LIPID MODIFYING AGENTS, PLAIN
13 C10A                                       LIPID MODIFYING AGENTS, PLAIN
14 N05B                                                         ANXIOLYTICS
15 N05B                                                         ANXIOLYTICS
16 N05B                                                         ANXIOLYTICS
17 N06A                                                     ANTIDEPRESSANTS
18 N06A                                                     ANTIDEPRESSANTS
```
