# Install required packages
packages <- c("shiny", "shinydashboard", "shinydashboardPlus", "DT")

# Install missing packages
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  install.packages(new_packages)
  message("All required packages have been installed successfully!")
} else {
    message("All necessary packages are already installed.")
  }  


