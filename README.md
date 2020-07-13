# Code and data for 'The composition and weathering of the continents over geologic time' 

This repository contains the code and data required to reproduce the results in the paper *'The composition and weathering of the continents over geologic time'.* 

## Code 

The document `data_analysis.html` is an [R-markdown document](https://rmarkdown.rstudio.com/) which performs all data analysis described in the paper. This file can be viewed in any browser. 
The same document is also given in the raw `.Rmd` form, which can be opened in [R-studio](https://www.rstudio.com/). This was written in `R` v3.4.4

The script `invert_coeffs_grad.py` is a `python` script which calculates the weathering and provenance coefficients for a given set of major-element compositions, incorporating a cation exchange correction. This was written in `python` v3.6.9.

## Data 

### Main data files 

The Sedimentary Geochemistry and Paleoenvironments Project sedimentary major-element data is given in `SGP_final.csv`. Data from [Lipp et al. 2020](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2019GC008758) is given in `sedimentary_rocks_PCA_paper.csv`. 

References for SGP data are given in `SGP_references.csv`. See [`github.com/alexLipp/weathering-and-provenance`](github.com/alexLipp/weathering-and-provenance) for references for data from Lipp et al. 2020.

### Output Data

The cleaned data, calculated ω and ψ coefficients, as well as the fitted compositions are given in: `SGP_data_cleaned_comps.csv`,`SGP_data_cleaned_coeffs.csv` & `SGP_data_cleaned_fit.csv`. Composite samples and their coefficients/fitted compositions are given in:  `mixture_comps.csv`,`mixture_coeffs.csv` & `mixture_fit.csv`

### Additional data

Additional data `.csv` files for igneous rocks are used to calculate the pristine omega value for recreating protolith compositions as well as identifying a suitable cutoff value of CaO wt% to exclude carbonate contamination. See [Lipp et al. 2020](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2019GC008758) and [`github.com/alexLipp/weathering-and-provenance`](github.com/alexLipp/weathering-and-provenance) for details. 
