# Analyses of secondary care data (Hospital Episode Statistics)

This is a repository for commonly used secondary care data analyses using Hospital Episode Statistics (HES).

It has been created by the West Sussex Public Health and Social Research Unit as a way to store and share code snippets within the team (and with anyone who can make use of the code for other person-level datasets).

You will need to install R and a text editor (we use R Studio) to run the R scripts and a DAE connection with NHS Digital to query HES. R and R Studio are both available as open source products with non-commercial licences. We cannot help set up access to HES, as we are external to NHS Digital but are happy to help where possible with coding/analyses queries.

### Why R?

We have found that using annotated scripts (what can be stored separately to data or credentials) is the most straight forward way to share work. In West Sussex, we have a team of researchers and analysts who are experienced in using R and it is an increasingly adopted analysis language in Public Health and wider disciplines of health information analytics.

R does have a steep learning curve, and it is hoped that with a little support and well annotated scripts, we hope can be useful. We know that others will prefer to use other languages such as Python, or not use coding at all.

### What is in here?

Some of these scripts will enable you to get information about a cohort of registered patients (e.g. patients registered to a single GP practice, Primary Care Networks, Integrated Care Board or other geographies) from public datasets, such as numbers registered, certain disease prevalence figures.

Others will retrieve information about a physical geographical area (such as Lower-layer Super Output area), showing information like neighbourhood deprivation, resident population estimates, population density and so on.

We also have scripts to create data files which describe care provider organisations (NHS Trust) and sites details so you can easily identify local providers of interest.

The repository also contains SQL code snippets for common queries that can be copied into environments where you have access to HES as well as R scripts for completing analyses and reporting (data visualisation and exporting results) as well as a helper function for applying NHS Digitals disclosure control rules around small numbers.

The repository does not contain any HES data about patients, although there may be dummy datasets used in some places to test out analyses approaches.

### Why is this GitHub repo public?

We use a lot of publicly available data, and what we produce is often for the benefit of many audiences inside and outside of our organisation. We believe that sharing annotating workflows helps to audit the work we produce (enabling reproduction and checking quality) and support a wider body of work to progress.

We will not store any datasets or reports/outputs not in the public domain here and you will need your own credentials to access the HES to reproduce many of the outputs detailed here.

Even if you cannot access HES yourself, you may be able to find a code snippet that works for your own analyses.
