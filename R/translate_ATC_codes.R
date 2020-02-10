### dependencies
library(stringr)
library(jsonlite)

## A function to return text translations of a given vector of ATC codes
## based on the NCBO BioPortal

### Output:
##
# Returns a data.frame with the valid input ATC codes in the first column (code)
# and the textual names in the second column (name)

### Note:
##
# Validity of an ID is only judged based on its length after level depth based
# truncation. Thus, IDs can never be too long, only too short. IDs which are
# not part of the ATC database, will not return results from the bioportal
# API and are translated to NA.

### Input:
##
# ATC_code - character vector
# level_depth - integer (1-5) //  1 is the shortest (length 1 char)
#                             //  5 the longest (length 7 chars) code
# api_key - character // create an account at https://bioportal.bioontology.org/
#                        and it will come with an api key

### Example:
##
# ATC_vect <- c("A02BC02", "C03BA08", "A02BC02", "A02BC02", "A07DA03", "A07DA03",
#               "A02BC02", "A02BC02", "A02BC02", "A02BC02", "C10AA05", "C10AA05",
#               "C10AA05", "N05BA06", "N05BA06", "N05BA06", "N06AX11", "N06AX11")
# # you will need to create an account at https://bioportal.bioontology.org/
# # to receive an api_key
# translate_ATC_codes(ATC_vect, level_depth = 3, api_key = api_key)

### References:
## https://en.wikipedia.org/wiki/Anatomical_Therapeutic_Chemical_Classification_System
## https://www.ncbi.nlm.nih.gov/pubmed/21672956
## https://www.bioontology.org/wiki/BioPortal_Help#Programming_with_the_BioPortal_API

translate_ATC_codes <- function(ATC_codes, level_depth = 5, api_key) {
  # error handling
  if (! typeof(ATC_codes) == "character") {
    stop("Please enter a character vector.")
  }
  # specify depth
  if (level_depth == 5) {
    ATC_codes_mapped <- map_ATC_to_text(ATC_codes, len = 7, api_key)
  } else if (level_depth == 4) {
    ATC_codes_mapped <- map_ATC_to_text(ATC_codes, len = 5, api_key)
  } else if (level_depth == 3) {
    ATC_codes_mapped <- map_ATC_to_text(ATC_codes, len = 4, api_key)
  } else if (level_depth == 2) {
    ATC_codes_mapped <- map_ATC_to_text(ATC_codes, len = 3, api_key)
  } else if (level_depth == 1) {
    ATC_codes_mapped <- map_ATC_to_text(ATC_codes, len = 1, api_key)
  } else {
    stop("Select an integer from 1, 2, 3, 4 or 5")
  }
  no_match_in_db <- ATC_codes_mapped$code[which(is.na(ATC_codes_mapped$name))]
  no_match_in_db_string <- paste(no_match_in_db, collapse = ", ")
  if (str_length(no_match_in_db_string)) {
    warning(paste0("The IDs: '", no_match_in_db_string, "' returned no match."))
  }
  return(ATC_codes_mapped)
}

# helper to create the mapping table and translate the input
# len is the length of the ATC code level (7 is the maximum 1 the minimum)
# api_key is as explained in translate_ATC_codes()
map_ATC_to_text <- function(ATC_codes, len = 7, api_key) {
  api_link_part1 <- "http://data.bioontology.org/search?q="
  api_link_part2 <- "&ontologies=ATC&require_exact_match=true"
  # get relevant substring
  ATC_codes_trunc <- substr(ATC_codes, start = 1, stop = len)

  # warn before removal of invalid (too short) IDs
  len_in_vect <- length(ATC_codes_trunc)
  wrong_length_idx <- which(str_length(ATC_codes_trunc) != len)
  len_wrong_length <- length(wrong_length_idx)
  if (len_wrong_length) {
    warning(paste0(len_wrong_length, " of your ", len_in_vect,
                   " input codes are/is not ", len,
                   " characters long and will be",
                   " removed before the translation."))
  }

  # retain only codes with valid length
  ATC_codes_trunc_valid <- ATC_codes_trunc[which(str_length(ATC_codes_trunc) == len)]
  uniq_ATC_set_vect <- unique(ATC_codes_trunc_valid)
  uniq_ATC_set_df <- as.data.frame(uniq_ATC_set_vect)
  uniq_ATC_set_df$name <- NA
  names(uniq_ATC_set_df)[1] <- "code"
  # query API for each code
  for (i in 1:nrow(uniq_ATC_set_df)) {
    curr_code <- uniq_ATC_set_df$code[i]
    full_api_link <- paste0(api_link_part1, curr_code, "&apikey=", api_key, api_link_part2)
    json_df <- fromJSON(full_api_link)
    if(length(json_df$collection)) {
      uniq_ATC_set_df$name[i] <- json_df$collection$prefLabel
    }
  }
  # translate input
  ATC_codes_mapped <- as.data.frame(cbind(ATC_codes_trunc_valid, ATC_codes_trunc_valid))
  names(ATC_codes_mapped) <- c("code", "name")
  ATC_codes_mapped$name <- uniq_ATC_set_df$name[match(ATC_codes_mapped$code, uniq_ATC_set_df$code)]
  return(ATC_codes_mapped)
}
