# Daniel Fryer's Curriculum Vitae

Academic CV built using R, pulling data automatically from ORCID and Google Scholar. See the full CV in pdf format [here](cv/cv.pdf).

Before running [cv.Rmd](cv/cv.Rmd) to generate the CV, you will need to run lines 1-14 of [setup.R](scripts/setup.R) to install packages and manually authenticate with ORCID.

## Sources

* Education, employment, service and awards are pulled from [ORCID](https://orcid.org/0000-0001-6032-0522).
* Publications are pulled from [Google Scholar](https://scholar.google.com/citations?user=DBWm9DYAAAAJ&hl=en).

## Structure

- `cv/cv.Rmd`: CV structure implemented as an [`{rmarkdown}`](https://rmarkdown.rstudio.com) document.
- `data/*.csv`: Any data that are not pulled from other sources.
- `scripts/setup.R`: The setup script used to install packages and define helper functions.

## Tools

- [`{vitae}`](https://docs.ropensci.org/vitae/) :package: to provide a CV template.
- [`{scholar}`](https://github.com/jkeirstead/scholar) :package: to pull papers from Google Scholar.
- [`{tinytex}`](https://github.com/yihui/tinytex) :package: to manage LaTex installation and additional packages.
- [`{rorcid}`](https://github.com/ropensci/rorcid/) :package: to pull data from ORCID.
