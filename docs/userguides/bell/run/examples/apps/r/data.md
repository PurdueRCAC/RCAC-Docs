---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Loading Data into R

R is an environment for manipulating data. In order to manipulate data, it must be brought into the R environment. R has a function to read any file that data is stored in. Some of the most common file types like comma-separated variable(CSV) files have functions that come in the basic R packages. Other less common file types require additional packages to be installed. To read data from a CSV file into the R environment, enter the following command in the R prompt:

```
> read.csv(file = "path/to/data.csv", header = TRUE)
```

When R reads the file it creates an object that can then become the target of other functions. By default the read.csv() function will give the object the name of the .csv file. To assign a different name to the object created by read.csv enter the following in the R prompt:

```
> my_variable <- read.csv(file = "path/to/data.csv", header = FALSE)
```

To display the properties (structure) of loaded data, enter the following:

```
> str(my_variable)
```

For more functions and tutorials:

* [The R Manuals](http://cran.r-project.org/manuals.html)
* [Other R Examples](http://www.mayin.org/ajayshah/KB/R/index.html)
* [Software Carpentry - Programming with R](https://swcarpentry.github.io/r-novice-inflammation/)
* [Data Carpentry Lessons](http://www.datacarpentry.org/lessons/)