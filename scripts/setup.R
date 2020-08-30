mirror = "https://cran.ms.unimelb.edu.au/"
if(!require(vitae)) install.packages("vitae", repos=mirror)
if(!require(tinytex)) install.packages("tinytex", repos=mirror)
if(!require(rorcid)) install.packages("rorcid", repos=mirror)
if(!require(glue)) install.packages("glue", repos=mirror)
if(!require(scholar)) install.packages("scholar", repos=mirror)
if(!require(dplyr)) install.packages("dplyr", repos=mirror)
if(!require(stringr)) install.packages("stringr", repos=mirror)

Sys.setenv(ORCID_TOKEN = gsub("Bearer ", "", rorcid::orcid_auth()))

cols <- c("-summary.department-name",
          "-summary.role-title",
          "-summary.start-date.year.value",
          "-summary.end-date.year.value",
          "-summary.organization.name",
          "-summary.organization.address.city",
          "-summary.organization.address.region",
          "-summary.organization.address.country")

cols_out <- c("dept", "role", "start", "end", "org", 
              "city", "region", "country")

summaries <- function(x) {x[[1]][["affiliation-group"]][["summaries"]]}

extractor <- function(orcid, cols, fun, cols_out, end_date = T) {
  sumr <- summaries(fun(names(orcid)[1]))
  if (!end_date) {
    cols <- cols[!(grepl("end-date", cols))]
    cols_out <- cols_out[!(grepl("end", cols_out))]
  }
  extr <- function(x){x[colnames(x) %in% cols]}
  out <- plyr::ldply(sumr, extr)[cols]
  colnames(out) <- cols_out
  if (end_date) out$end[is.na(out$end)] <- "Current"
  return(out)
}

education <- function(orcid) {
  cols <- paste0("education", cols)
  return(extractor(orcid, cols, rorcid::orcid_educations, cols_out))
}

service <- function(orcid) {
  cols <- paste0("service", cols)
  return(extractor(orcid, cols, rorcid::orcid_services, cols_out))
}

employment <- function(orcid) {
  cols <- paste0("employment", cols)
  return(extractor(orcid, cols, rorcid::orcid_employments, cols_out))
}

bio <- function(orcid) {
  rorcid::orcid_bio(names(orcid)[1])[[1]]$content
}

awards <- function(orcid) {
  cols <- paste0("distinction", cols)
  return(extractor(orcid, cols, rorcid::orcid_distinctions, cols_out,
                   end_date = F))
}



# Retrieved from ORCID: Employment, Publications, 
#   Academic Service, Bio, Education, Awards
orcid <- rorcid::as.orcid(x = "0000-0001-6032-0522")

my_bio <- bio(orcid)
my_education <- education(orcid)
my_employment <- employment(orcid)
my_service <- service(orcid)
my_awards <- awards(orcid)

my_works <- rorcid::works(orcid)
preprint <- my_works$type == "preprint"
my_works_preprint <- my_works[preprint,]
my_works_published <- my_works[!preprint,]


## Publications from scholar are cleaner
pubs <- scholar::get_publications("DBWm9DYAAAAJ") %>% # choose Google id here
  dplyr::mutate(author = author %>% 
                  as.character %>% 
                  stringr::str_trim(),
                journal = journal %>% 
                  replace(journal %in% "arXiv preprint arXiv:", "arXiv"), 
                first_author = dplyr::case_when(
                  stringr::str_starts(author, "D Fryer") ~ TRUE, # choose name
                  TRUE ~ FALSE),
                preprint = case_when(
                  journal %in% c("arXiv preprint arXiv:", "arXiv") ~ TRUE, 
                  TRUE ~ FALSE)) %>% 
  dplyr::arrange(desc(year))


