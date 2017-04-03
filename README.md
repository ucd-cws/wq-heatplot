---
title: "wq.heatplot readme"
output: github_document
---


## About

R package for creating Heatplots for the Arcproject's water quality data.



## Install

You can include R code in the document as follows:

```{r}
library(devtools)
install_github("ucd-cws/wq-heatplot")
```

## Load Data

Export all the water quality data from a given slough using the [arcproject-wq-processing toolbox](https://github.com/ucd-cws/arcproject-wq-processing) `Export Heatplot data CSV`

```{r}
data <- read.csv("tests/example_data.csv", stringsAsFactors = FALSE)
```


