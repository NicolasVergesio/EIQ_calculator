# EIQ_calculator

## About
The **Environmental Impact Quotient (EIQ)** is a formula used to calculate the environmental impact of pesticides. This calculator provides information and allows users to compare the EIQ of different pesticides.

The app is divided into two main pages:
1. **Dashboard** - Displays information about a selected pesticide.
2. **Calculator** - Computes the final EIQ of a pesticide or compares two pesticides.

## Features
- Select pesticides and view their environmental impact scores.
- Compare two pesticides side by side.
- Interactive dashboard with key performance indicators (KPIs).
- User-friendly interface using Shiny and Shinydashboard.

## Installation
To run this application, install the required R packages:

```r
install.packages(c("shiny", "shinydashboard", "shinydashboardPlus", "DT"))
```

Then, run the Shiny app in R:

```r
shiny::runApp("path_to_EIQ_calculator")
```

## Data Source
The pesticide data is sourced from:
[Environmental Impact Quotient (EIQ) Calculator - Cornell University](https://cals.cornell.edu/new-york-state-integrated-pest-management/risk-assessment/eiq/eiq-calculator)

## License
This project is licensed under the **MIT License**.

## Author
Developed by NicolasVergesio.
---
Feel free to contribute to this project by submitting issues or pull requests!

