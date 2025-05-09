library(shiny)
library(shinydashboard)
library(shinydashboardPlus)


data <- data.frame(
  Active = c("1-naphthylacetamide", "1-naphthylacetic acid", "1,3-dichloropropene"),
  CAS = c("86-86-2", "86-87-3", "542-75-6"),
  Pesticide_type = c("Plant Growth Regulator", "Plant Growth Regulator", "Nematicide"),
  FINAL_EIQ = c(47.33, 53.33, 44.00),
  Farm_worker = c(80, 80, 90),
  Consumer = c(34, 49, 9),
  Ecological = c(28, 31, 33),
  Reliability_score = c("Medium", "Medium", "Medium")
)


#Diferentes medidas posibles
units <- c("grams (g)", "kilograms (kg)", "liters (l)", "milliliters (ml)", 
           "pounds (lb)", "dry ounces (oz)", "fluid ounces (fl oz)", "gallons (gal)")


# Crear una matriz de conversiones entre varias unidades
equivalencias <- matrix(c(
  #g
  1, 0.001, 0.001, 1, 0.0022, 0.03527396, 0.0351951 , 0.000264172,
  #kg
  1000, 1, 1, 1000, 2.20462 , 35.27396 , 35.1951 , 0.264172,
  #l
  1000, 1, 1, 1000, 2.20462, 35.27396, 35.1951, 0.264172 ,
  #ml
  1, 0.001, 0.001, 1, 0.0022, 0.03527396, 0.0351951 , 0.000264172,
  #lb
  453.592 , 0.453592 , 0.453592, 453.592 , 1, 16 , 16 , 0.00220462,
  #dry oz
  28.3495 , 0.0283495 , 0.0283495 , 28.3495, 0.0625 ,1  , 1.04167 , 0.0000156 ,
  #fl oz
  29.5735, 0.0295735 , 0.0295735, 29.5735 , 0.0351951, 0.0625, 1, 0.0000078125 , 
  #gal
  3785.41, 3.78541 , 3.78541 , 3785.41, 8.34 , 128 , 128 , 1
), nrow = 8, byrow = TRUE)

# Asignar nombres a las filas y columnas de la matriz
rownames(equivalencias) <- units
colnames(equivalencias) <- units
# Ver la matriz
equivalencias



#Diferentes areas posibles
area_units <- c("ft2", "m2", "acre", "hectare")

area_equivalencia <- matrix(c(
  #ft2
  1, 0.0929, 0.00002296, 0.00000929,
  #m2
  10.7639, 1,	0.0002471,	0.0001,
  #acre
  43560,	4046.86,	1,	0.4047,
  #hectare
  107639,	10000,	2.471,	1
), nrow = 4, byrow = TRUE)

rownames(area_equivalencia) <- area_units
colnames(area_equivalencia) <- area_units


ui <- dashboardPage(
  
  #Texto de cabecera
  dashboardHeader(title = textOutput("headerTitle"), titleWidth = 250),  # El título se muestra dinámicamente
  
  #Barra lateral para moverse entre pestañas
  dashboardSidebar(collapsed = FALSE, width = 250, # El sidebar comenzará comprimido
                   sidebarMenu(
                     menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                     menuItem("Calculadora", tabName = "calculadora", icon = icon("calculator")))),  
  
  #Cuerpo del dashboard
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName = "dashboard",
    fluidRow(
      column(4,
             box(title = "Filtros", status = "primary", solidHeader = TRUE, background = "green", width = NULL, height = NULL, collapsible = FALSE, collapsed = FALSE,
                 selectInput("pesticide_type", "Tipo de Pesticida:", choices = unique(data$Pesticide_type)),
                 selectInput("chemical", "Componente Químico:", choices = unique(data$Active))),
             br(), br(), br(),br(),
             uiOutput("my_image")),
             #fluidRow(uiOutput("my_image"))),
             #box(uiOutput("my_image"), width = NULL, height = 12, solidHeader = FALSE, headerBorder = FALSE)),
      
      column(8,
             box(title = "KPI", status = "primary", solidHeader = TRUE, background = "gray", width = NULL, height = "100px", collapsible = FALSE, collapsed = FALSE,
                 valueBoxOutput("value_box_eiq", width = 3),
                 valueBoxOutput("value_box_ecologycal", width = 3),
                 valueBoxOutput("value_box_farmworker", width = 3),
                 valueBoxOutput("value_box_consumers", width = 3)),
             br(), br(), 
             box(title = "Pesticide Table", status = "info", solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = FALSE, collapsed = FALSE,
             DT::dataTableOutput("tabla_pesticidas"))))
  ),
  
  tabItem(tabName = "calculadora",
          fluidRow(
            column(6,
                   box(title = "Pesticida 1", width = 12,solidHeader = TRUE, status = "primary", collapsible = FALSE,
                       selectInput("pest_1", "Elegir pesticida", selected = NULL, multiple = FALSE, choices = c("---",unique(data$Active))),
                       numericInput("pest_percent_1", "Ingrediente activo %", value =  NA, min = 0, max = 100),
                       numericInput("´product_rate_1", "Taza de aplicación (pesticida / área)", value =  NA),
                       selectInput("product_meas_1", "Unidad de aplicación del pesticida", selected = "", choices = c("", units)),
                       selectInput("area_1", "Unidad del área de aplicación", selected = "", choices = c("", area_units)))),
            column(6,
                   box(title = "Pesticida 2", width = 12,solidHeader = TRUE, status = "primary", collapsible = FALSE,
                       selectInput("pest_2", "Elegir pesticida", selected = NULL, multiple = FALSE, choices = c("---",unique(data$Active))),
                       numericInput("pest_percent_2", "Ingrediente activo %", value =  NA, min = 0, max = 100),
                       numericInput("´product_rate_2", "Taza de aplicación (pesticida / área)", value =  NA),
                       selectInput("product_meas_2", "Unidad de aplicación del pesticida", selected = "", choices = c("", units)),
                       selectInput("area_2", "Unidad del área de aplicación", selected = "", choices = c("", area_units)))),
            br(), br(), br(),
          fluidRow(
            column(6, 
                   actionButton("calcu", "Calculate", class = "btn-warning"), align = "right"),
            column(6, 
                   actionButton("del", "Delete", class = "btn-white"), align = "left")
    
          ),
          br(), 
          fluidRow(
            column(12,
                   textOutput("text"), align = "center")
          ),
          )))),
                   
  
  
  # Aquí es donde usas el control de la barra lateral (collapsed / expandido)
  dashboardControlbar(
    
    h1("EIQ", align = "center"),
    br(),
    uiOutput("info_eiq")))






server <- function(input, output, session) {
  
  # Mostrar el título dinámicamente dependiendo del estado del sidebar
  output$headerTitle <- renderText({
    # Si el sidebar está comprimido, mostramos un texto corto ("Saludo")
    if (input$sidebarCollapsed) {
      return("EIQ")
    } else {
      return("Environmental impact quotient")
    }
  })
  
  
  output$info_eiq <- renderUI({
    
    
    HTML("<p><strong>El EIQ (Environmental Impact Quotient)</strong> es un índice desarrollado por la Universidad de Cornell para evaluar el impacto ambiental de los plaguicidas. Se basa en factores como la toxicidad humana, la persistencia ambiental y el impacto en organismos no objetivo.</p>
        
        <p>Puedes leer más en el paper original aquí: 
        <a href='https://ecommons.cornell.edu/items/2feca8d7-3889-4a41-aae9-a2ce0f16a6e2' target='_blank'>A Method to Measure the Environmental Impact of Pesticidesr</a>.</p>")
    
    
    
  })
  
  
  output$my_image = renderUI({
    tags$img(src = "planta.png", width = '400px', height = "300px")
  })
  
  
  
  ###First tab
  
  #Filtrar y actualizar los pesticidas disponibles de acuerdo a la categoría seleccionada.
  
  observe({
    
    selected_type <- input$pesticide_type
    available_chemical <- data[data$Pesticide_type == selected_type, 1]
    
    updateSelectInput(session, "chemical", choices = available_chemical)
    
  })
  
  
  output$tabla_pesticidas <- DT::renderDataTable({
    
    selected_type <- input$pesticide_type
    
    filtered_data <- data[data$Pesticide_type == selected_type, ]
    
    DT::datatable(filtered_data, options = list(scrollX=TRUE, scrollCollapse=TRUE))
    
  })
  
  
  #
  observe({
    
    selected_chemical <- input$chemical
    
    available_data <- data[data$Active == selected_chemical, ]
    
    
    #calcular el valor del EIQ para el compuesto quimico
    output$value_box_eiq <- renderValueBox({
      valueBox(available_data$FINAL_EIQ, subtitle = "FINAL EIQ", icon = icon("leaf"), color = "green")
    })
    
    
    #calcular el valor del EIQ para el ambiente
    output$value_box_ecologycal <- renderValueBox({
      valueBox(available_data$Ecological, subtitle = "Ecological EIQ", icon = icon("tractor"), color = "olive")
    })
    
    #calcular el valor del EIQ para los trbajadores
    output$value_box_farmworker <- renderValueBox({
      valueBox(available_data$Farm_worker, subtitle = "Ecological EIQ", icon = icon("user"), color = "teal")
    })
    
    
    #calcular el valor del EIQ para los consumidores
    output$value_box_consumers <- renderValueBox({
      valueBox(available_data$Consumer, subtitle = "Ecological EIQ", icon = icon("tree"), color = "aqua")
    })
    
    
    
  })
  
  
  ###Second Tab
  # 
  # pest_choiced_1 <- eventReactive({
  #   
  #   selected_pesticide <- input$pest_1
  #   data[data$Active == selected_pesticide, 1]
  #   output$value_box_selected_pest <- renderValueBox({
  #     valueBox(selected_pesticide, subtitle = "hola")
  #   
  # })
  # 
  # })
  # 
  
  output$text <- renderText("hello!")
  
  
}

shinyApp(ui, server)

