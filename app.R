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
                       selectInput("pest_1", "Elegir pesticida", selected = NULL, multiple = FALSE, choices = unique(data$Pesticide_type)))),
            column(6,
                   box(title = "Pesticida 2", width = 12,solidHeader = TRUE, status = "primary", collapsible = FALSE))),
          fluidRow(
            box(width = 12)
          ),
          fluidRow(
            box(width = 12)
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
  
  
  
  
  
  
}

shinyApp(ui, server)

