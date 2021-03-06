library(shiny)

shinyUI(navbarPage("Defunciones",
                   tabPanel("Etapa 1",
###
  #fluidPage(#theme = "bootstrap02.css",
  #titlePanel("Etapa 1"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.Etap01 === "Datos"',
        fileInput('file1', 'Archivo de códigos (en dbf)',
                  accept=c('.dbf')),
        numericInput("obs", "Primeros casos del archive:", 20),
        tags$hr(),
        fileInput('file2', 'Archivo de datos (texto o csv)',
                  accept=c('text/csv',
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        
        checkboxInput('header', 'Encabezado', TRUE),
        radioButtons('sep', 'Separado por:',
                     c(Coma=',',
                       Puntoycoma=';',
                       Tabulador='\t'),
                     ','),
        radioButtons('quote', 'Quote',
                     c(None='',
                       'Double Quote'='"',
                       'Single Quote'="'"),
                     '"'),
        tags$hr(),
        p('Para ver un ejemplo de cómo están organizados los',
          'archivos .dbf y .cvs, puede descargar estos ejemplos',
          a(href = 'BaseEtapa01.dbf', 'BaseEtapa01.dbf'), 'o',
          a(href = 'DatCap.csv', 'DatCap.csv'),
          'y hacer pruebas con ellos.'
        ),
        p('Nota: El archivo de códigos debe ser guardado en',
          'el formado', code("dBASE IV (DBF)"), 'y con solo las columnas', 
          'de ID y código si son más de 300,000 registros.')
      ),
      
      conditionalPanel(
        'input.Etap01 === "Resumen"',
        helpText('Elegir las variables a utilizar'),
        uiOutput("NomID"),
        uiOutput("NomCod"),
        actionButton("updat1", "Obtener Población"),
        tags$hr(),
        radioButtons("En", "De donde tomar n:",
                     c("Archivo" = "arc",
                       "Ecuación" = "ecu",
                       "Manual" = "man")),
        conditionalPanel(condition = 'input.En === "ecu"',
                         actionButton("updat3", "Renovar"),
                         tags$hr(),
                         selectInput("CapEcu","Capitulo que desea modificar:", 
                                     choices=c(1:20),selected="1"),
                         sliderInput(inputId = "bw_Error",
                                     label = "Valor para Error:",
                                     min = 0, max = 0.1, value = .04, step = 0.005)
                         #sliderInput(inputId = "bw_P",
                         #            label = "Valor para P:",
                         #            min = 0, max = 1, value = .5, step = 0.05)
        ),
        conditionalPanel(condition = 'input.En === "man"',
                         actionButton("updat4", "Renovar"),
                         tags$hr(),
                         selectInput("CapMod","Capitulo que desea modificar:", 
                                     choices=c(1:20)),
                         numericInput("nmanual", "Introducir valores para n:", 
                                      100)                
        ),
        downloadButton('DescarResum', 'Guardar'),
        tags$hr()
      ),
      
      conditionalPanel(
        'input.Etap01 === "Muestra"',
        actionButton("updat2", "Obtener Muestra"),
        tags$hr(),
        helpText('Elige las variables a exhibir'),
        checkboxGroupInput('show_vars', 'Elegir:',
                           c("Id" = "Id",
                             "ID Original" = "IDo",
                             "ID Originalm" = "IDm",
                             "Código de defunción" = "CausaD",
                             "CapAut" = "CapAut",
                             "Capit" = "Capit",
                             "FactorExp" = "FactorExp",
                             "En Muestra" = "EnMuestra"),
                           selected = c("Id","IDo","IDm","CausaD","CapAut","Capit","FactorExp","EnMuestra")),
        tags$hr(),
        checkboxInput("mues","Solo los elementos de la muestra",value = F),
        downloadButton('DescarMuestra', 'Guardar')
      )
      ),
    
    mainPanel(
      tabsetPanel(
        id = 'Etap01',
        tabPanel("Datos",
                 h4("Tabla de códigos"),
                 dataTableOutput('tabla1'),
                 tags$hr(),
                 h4("Tabla de Datos"),
                 tableOutput('tabla2')
                ),
        
        tabPanel("Resumen",
                 conditionalPanel(condition = 'input.En === "arc"',
                                  fluidRow(
                                    column(4,h4("Tabla de Resumen Archivo"),
                                           tableOutput('tabla5')),
                                    column(7,offset = 1,h5("Cantidad de registros para la muestra:"),
                                           verbatimTextOutput("num5"))
                                  )
                 ),
                 conditionalPanel(condition = 'input.En === "ecu"',
                                  fluidRow(
                                    column(5,h4("Tabla de Resumen Ecuaciones"),
                                           tableOutput('tabla51')),
                                    column(5,offset = 1,h5("Cantidad de registros para la muestra:"),
                                           verbatimTextOutput("num51"))
                                  )
                 ),
                 conditionalPanel(condition = 'input.En === "man"',
                                  fluidRow(
                                    column(5,h4("Tabla de Resumen Manual"),
                                           tableOutput('tabla52')),
                                    column(5,offset = 1,h5("Cantidad de registros para la muestra:"),
                                           verbatimTextOutput("num52"))
                                  )
                 )
                 ),
        
        tabPanel("Muestra",
                 h4("Tabla con la muestra para la Etapa 1"),
                 dataTableOutput('tabla4')
                )
              )
          )
  )
#)
),
####_____________________________________________________________
#___________________________Etapa 2 y 3______________________________
####________________________________________________________________
tabPanel("Etapa 2 y 3",
         #fluidPage(
         sidebarLayout(
           sidebarPanel(
             conditionalPanel(
               'input.Etap02 === "Datos"',
               fileInput('Etapa2file1', 'Archivo de códigos (en dbf)',
                         accept=c('.dbf')),
               helpText('Elegir las variables a utilizar'),
               uiOutput("Etap2CausaA"),
               uiOutput("Etap2Causa1"),
               uiOutput("Etap2Causa2"),
               tags$hr()
               
             ),
####
             conditionalPanel(
               'input.Etap02 === "Revisión"',
###
                helpText('Presionar evaluar para iniciar el proceso de obtención de casos a revisión'),
               actionButton("E2updat1", "Evaluar"),
               tags$hr(),
               h6("Registros para revisión:"),
               verbatimTextOutput("E2RegRev"),
               tags$hr(),
               checkboxInput("E2RevGua","Solo los Registros para revisión",value = T),
               downloadButton('E2DescarRev', 'Guardar'),
               tags$hr()
             ),
####
             conditionalPanel(
               'input.Etap02 === "Tablas"',
####
               helpText('Elegir la tabla que decea ver'),
               tags$hr(),
               radioButtons("Tab", "Tipo de tabla:",
                            c("Totales por caso" = "Caso",
                              "Errores a 3 Dígitos" = "Er3D",
                              "Errores a 4 Dígitos" = "Er4D",
                              "Caso 4 Mismo Capítulo" = "C4MC",
                              "Caso 4 Diferente Capítulo" = "C4DF"
                              )),
               conditionalPanel(condition = 'input.Tab === "Caso"',
                                helpText('Si desea guardar la tabla de totales por caso:'),
                                downloadButton('E2DescarCaso', 'Guardar'),
                                tags$hr()
               ),
               conditionalPanel(condition = 'input.Tab === "Er3D"',
                                helpText('Si desea guardar la tabla de Errores a 3 Dígitos:'),
                                downloadButton('E2DescarEr3D', 'Guardar'),
                                tags$hr()             
               ),
               conditionalPanel(condition = 'input.Tab === "Er4D"',
                                helpText('Si desea guardar la tabla de Errores a 4 Dígitos:'),
                                downloadButton('E2DescarEr4D', 'Guardar'),
                                tags$hr()               
               ),
               conditionalPanel(condition = 'input.Tab === "C4MC"',
                                numericInput("E2nMis", "Mínimo de Errores:", 1),
                                helpText('Si desea guardar frecuencias para mismo capítulo:'),
                                downloadButton('E2DescarC4MC', 'Guardar'),
                                tags$hr()               
               ),
               conditionalPanel(condition = 'input.Tab === "C4DF"',
                                numericInput("E2nDif", "Mínimo de Errores:", 1),
                                helpText('Si desea guardar frecuencias para diferente capítulo:'),
                                downloadButton('E2DescarC4DF', 'Guardar'),
                                tags$hr()
               ),
               tags$hr()
             ),
####
             conditionalPanel(
               'input.Etap02 === "Población"',
####
               helpText('Se requiere el tamaño total de la población, usar archivo de la Etapa 1 sección Resumen'),
               fileInput('Etapa2file2', 'Archivo de datos (texto o csv)',
                         accept=c('text/csv',
                                  'text/comma-separated-values,text/plain', 
                                  '.csv')),
               
               checkboxInput('header', 'Encabezado', TRUE),
               radioButtons('sep', 'Separado por:',
                            c(Coma=',',
                              Puntoycoma=';',
                              Tabulador='\t'),
                            ','),
               radioButtons('quote', 'Quote',
                            c(None='',
                              'Double Quote'='"',
                              'Single Quote'="'"),
                            '"'),
               uiOutput("Etap2Pobla"),
               tags$hr()
             ),
#####
conditionalPanel(
  'input.Etap02 === "Limites"',
#####
helpText('Intervalos de confianza'),
actionButton("E2Inter", "Calcular"),
helpText('Elegir la tabla que decea ver'),
tags$hr(),
radioButtons("E2Lim", "Límites o gráficos que desea mostrar:",
             c("Intervalos de confianza a 3 dígitos" = "IC3D",
               "Intervalos de confianza a 4 dígitos" = "IC4D",
               "Gráfico a 3 Dígitos" = "Gr3D",
               "Gráfico a 4 Dígitos" = "Gr4D"
             )),
conditionalPanel(condition = 'input.E2Lim === "IC3D"',
                 helpText('Guardar intervalos de confianza a 3 dígitos:'),
                 sliderInput(inputId = "E2ErrorI3",
                             label = "Valor para Error (alfa):",
                             min = .01, max = .2, value = .05, step = 0.01),
                 downloadButton('DescarE2Inter3', 'Guardar'),
                 tags$hr()
),
conditionalPanel(condition = 'input.E2Lim === "IC4D"',
                 helpText('Guardar intervalos de confianza a 4 dígitos:'),
                 sliderInput(inputId = "E2ErrorI4",
                             label = "Valor para Error (alfa):",
                             min = .01, max = .2, value = .05, step = 0.01),
                 downloadButton('DescarE2Inter4', 'Guardar'),
                 tags$hr()             
),
conditionalPanel(condition = 'input.E2Lim === "Gr3D"',
                 helpText('Si desea guardar la Gráfico a 3 Dígitos:'),
                 uiOutput("Etap2Int3"),
                 tags$hr()               
),
conditionalPanel(condition = 'input.E2Lim === "Gr4D"',
                 helpText('Si desea guardar la Gráfico a 4 Dígitos:'),
                 uiOutput("Etap2Int4"),
                 tags$hr()               
),
tags$hr(),
downloadButton('downloadReportE2', 'Reporte')

)
             
           ),
###
           mainPanel(
             tabsetPanel(
               id = 'Etap02',
###
               tabPanel("Datos",    
                        h4("Tabla de Datos"),
                        dataTableOutput('Etapa2Tabla1')
               ),
               
               tabPanel("Revisión",
                        h4("Tabla de Revisión"),
                        dataTableOutput('Etapa2Tabla2')
               ),
               
               tabPanel("Tablas",
                        conditionalPanel(condition = 'input.Tab === "Caso"',
                                         h4("Tabla de Totales por Caso"),
                                         tableOutput('Etapa2Tabla31')
                                         #dataTableOutput('Etapa2Tabla34')
                        ),
                        conditionalPanel(condition = 'input.Tab === "Er3D"',
                                         h4("Tabla de Errores a 3 Dígitos"),
                                         tableOutput('Etapa2Tabla32')
                        ),
                        conditionalPanel(condition = 'input.Tab === "Er4D"',
                                         h4("Tabla de Errores a 4 Dígitos"),
                                         tableOutput('Etapa2Tabla33')
                        ),
                        conditionalPanel(condition = 'input.Tab === "C4MC"',
                                         h4("Frecuencias para mismo capítulo"),
                                         tableOutput('Etapa2TablaMis')
                        ),
                        conditionalPanel(condition = 'input.Tab === "C4DF"',
                                         h4("Frecuencias para diferente capítulo"),
                                         tableOutput('Etapa2TablaDif')
                        )
               ),
               
               tabPanel("Población",
                        h4("Tabla para Análisis"),
                        tableOutput('Etapa2TablaTot')
               ),

                tabPanel("Limites",
                         conditionalPanel(condition = 'input.E2Lim === "IC3D"',
                                          h4("Intervalos de confianza a 3 dígitos"),
                                          tableOutput('Etapa2Inter3')
                         ),
                         conditionalPanel(condition = 'input.E2Lim === "IC4D"',
                                          h4("Intervalos de confianza a 4 dígitos"),
                                          tableOutput('Etapa2Inter4')
                         ),
                         conditionalPanel(condition = 'input.E2Lim === "Gr3D"',
                                          h4("Gráfico a 3 Dígitos"),
                                          plotOutput('E2GI3')
                         ),
                         conditionalPanel(condition = 'input.E2Lim === "Gr4D"',
                                          h4("Gráfico a 4 Dígitos"),
                                          plotOutput('E2GI4')
                         )
                      
                )#tabPanel("Limites"
               
             )#tabsetPanel(id = 'Etap02'
           )#mainPanel(
         )#sidebarLayout(
),#tabPanel("Etapa 2 y 3",

####_____________________________________________________________
#___________________________Etapa 4 y 5______________________________
####________________________________________________________________
tabPanel("Etapa 4 y 5",
         #fluidPage(
         sidebarLayout(
           sidebarPanel(
             conditionalPanel(
               'input.Etap04 === "Datos"',
               fileInput('Etapa4file1', 'Archivo de códigos (en dbf)',
                         accept=c('.dbf')),
               helpText('Elegir las variables a utilizar'),
               uiOutput("Etap4CausaA"),
               uiOutput("Etap4Causa1"),
               uiOutput("Etap4Causa2"),
               uiOutput("Etap4CausaF"),
               helpText('Se requiere el tamaño total de la población, usar archivo de la Etapa 1 sección Resumen'),
               fileInput('Etapa4file2', 'Archivo de datos (texto o csv)',
                         accept=c('text/csv',
                                  'text/comma-separated-values,text/plain', 
                                  '.csv')),
               
               checkboxInput('header', 'Encabezado', TRUE),
               radioButtons('sep', 'Separado por:',
                            c(Coma=',',
                              Puntoycoma=';',
                              Tabulador='\t'),
                            ','),
               radioButtons('quote', 'Quote',
                            c(None='',
                              'Double Quote'='"',
                              'Single Quote'="'"),
                            '"'),
               uiOutput("Etap4Pobla"),
               tags$hr()
               
             ),
             ####
             conditionalPanel(
               'input.Etap04 === "Revisión"',
               ###
               helpText('Presionar evaluar para iniciar el proceso de obtención de casos a revisión'),
               actionButton("E4updat1", "Evaluar"),
               tags$hr(),
               h6("Registros para revisión:"),
               verbatimTextOutput("E4RegRev"),
               tags$hr(),
               checkboxInput("E4RevGua","Solo los Registros para revisión",value = T),
               downloadButton('E4DescarRev', 'Guardar'),
               tags$hr()
             ),
             ####
             conditionalPanel(
               'input.Etap04 === "Tablas"',
               ####
               helpText('Elegir la tabla que decea ver'),
               tags$hr(),
               radioButtons("E4Tab", "Tipo de tabla:",
                            c("Totales por caso" = "Caso",
                              "Errores a 3 Dígitos" = "Er3D",
                              "Errores a 4 Dígitos" = "Er4D",
                              "Caso 4 Mismo Capítulo" = "C4MC",
                              "Caso 4 Diferente Capítulo" = "C4DF"
                            )),
               conditionalPanel(condition = 'input.E4Tab === "Caso"',
                                helpText('Si desea guardar la tabla de totales por caso:'),
                                downloadButton('E4DescarCaso', 'Guardar'),
                                tags$hr()
               ),
               conditionalPanel(condition = 'input.E4Tab === "Er3D"',
                                helpText('Si desea guardar la tabla de Errores a 3 Dígitos:'),
                                downloadButton('E4DescarEr3D', 'Guardar'),
                                tags$hr()             
               ),
               conditionalPanel(condition = 'input.E4Tab === "Er4D"',
                                helpText('Si desea guardar la tabla de Errores a 4 Dígitos:'),
                                downloadButton('E4DescarEr4D', 'Guardar'),
                                tags$hr()               
               ),
               conditionalPanel(condition = 'input.E4Tab === "C4MC"',
                                numericInput("E4nMis", "Mínimo de Errores:", 1),
                                helpText('Si desea guardar frecuencias para mismo capítulo:'),
                                downloadButton('E4DescarC4MC', 'Guardar'),
                                tags$hr()               
               ),
               conditionalPanel(condition = 'input.E4Tab === "C4DF"',
                                numericInput("E4nDif", "Mínimo de Errores:", 1),
                                helpText('Si desea guardar frecuencias para diferente capítulo:'),
                                downloadButton('E4DescarC4DF', 'Guardar'),
                                tags$hr()
               ),
               tags$hr()
             ),
             ####
             
             #####
             conditionalPanel(
               'input.Etap04 === "Limites"',
               #####
               helpText('Intervalos de confianza'),
               actionButton("E4Inter", "Calcular"),
               helpText('Elegir la tabla que decea ver'),
               tags$hr(),
               radioButtons("E4Lim", "Límites o gráficos que desea mostrar:",
                            c("Intervalos de confianza a 3 dígitos" = "IC3D",
                              "Intervalos de confianza a 4 dígitos" = "IC4D",
                              "Gráfico a 3 Dígitos" = "Gr3D",
                              "Gráfico a 4 Dígitos" = "Gr4D",
                              "Tabla de ponderados a 3 dígitos" = "Ta3D"
                            )),
               conditionalPanel(condition = 'input.E4Lim === "IC3D"',
                                helpText('Guardar intervalos de confianza a 3 dígitos:'),
                                sliderInput(inputId = "E4ErrorI3",
                                            label = "Valor para Error (alfa):",
                                            min = .01, max = .2, value = .05, step = 0.01),
                                downloadButton('DescarE4Inter3', 'Guardar'),
                                tags$hr()
               ),
               conditionalPanel(condition = 'input.E4Lim === "IC4D"',
                                helpText('Guardar intervalos de confianza a 4 dígitos:'),
                                sliderInput(inputId = "E4ErrorI4",
                                            label = "Valor para Error (alfa):",
                                            min = .01, max = .2, value = .05, step = 0.01),
                                downloadButton('DescarE4Inter4', 'Guardar'),
                                tags$hr()             
               ),
               conditionalPanel(condition = 'input.E4Lim === "Gr3D"',
                                helpText('Si desea guardar la Gráfico a 3 Dígitos:'),
                                uiOutput("Etap4Int3"),
                                tags$hr()               
               ),
               conditionalPanel(condition = 'input.E4Lim === "Gr4D"',
                                helpText('Si desea guardar la Gráfico a 4 Dígitos:'),
                                uiOutput("Etap4Int4"),
                                tags$hr()               
               ),
               conditionalPanel(condition = 'input.E4Lim === "Ta3D"',
                                helpText('Si desea guardar la Tabla a 3 Dígitos:'),
                                #uiOutput("Etap4Int4"),
                                tags$hr()               
               ),
               tags$hr()
               
             )
             
           ),
           ###
           mainPanel(
             tabsetPanel(
               id = 'Etap04',
               ###
               tabPanel("Datos",    
                        h4("Tabla de Datos"),
                        dataTableOutput('Etapa4Tabla1')
               ),
               
               tabPanel("Revisión",
                        h4("Tabla de Revisión"),
                        dataTableOutput('Etapa4Tabla2')
               ),
               
               tabPanel("Tablas",
                        conditionalPanel(condition = 'input.E4Tab === "Caso"',
                                         h4("Tabla de Totales por Caso"),
                                         tableOutput('Etapa4Tabla31')
                                         #dataTableOutput('Etapa4Tabla34')
                        ),
                        conditionalPanel(condition = 'input.E4Tab === "Er3D"',
                                         h4("Tabla de Errores a 3 Dígitos"),
                                         tableOutput('Etapa4Tabla32')
                        ),
                        conditionalPanel(condition = 'input.E4Tab === "Er4D"',
                                         h4("Tabla de Errores a 4 Dígitos"),
                                         tableOutput('Etapa4Tabla33')
                        ),
                        conditionalPanel(condition = 'input.E4Tab === "C4MC"',
                                         h4("Frecuencias para mismo capítulo"),
                                         tableOutput('Etapa4TablaMis')
                        ),
                        conditionalPanel(condition = 'input.E4Tab === "C4DF"',
                                         h4("Frecuencias para diferente capítulo"),
                                         tableOutput('Etapa4TablaDif')
                        )
               ),
               
               
               
               tabPanel("Limites",
                        conditionalPanel(condition = 'input.E4Lim === "IC3D"',
                                         h4("Intervalos de confianza a 3 dígitos"),
                                         tableOutput('Etapa4Inter3')
                        ),
                        conditionalPanel(condition = 'input.E4Lim === "IC4D"',
                                         h4("Intervalos de confianza a 4 dígitos"),
                                         tableOutput('Etapa4Inter4')
                        ),
                        conditionalPanel(condition = 'input.E4Lim === "Gr3D"',
                                         h4("Gráfico a 3 Dígitos"),
                                         plotOutput('E4GI3')
                        ),
                        conditionalPanel(condition = 'input.E4Lim === "Gr4D"',
                                         h4("Gráfico a 4 Dígitos"),
                                         plotOutput('E4GI4')
                        ),
                        conditionalPanel(condition = 'input.E4Lim === "Ta3D"',
                                         h4("Tabla de ponderados a 3 dígitos"),
                                         plotOutput('Etapa4TabPon3')
                                         #dataTableOutput('Etapa4Prueba')
                                         
                        )
                        
               )#tabPanel("Limites"
               
             )#tabsetPanel(id = 'Etap04'
           )#mainPanel(
         )#sidebarLayout(
)#tabPanel("Etapa 4 y 5",

))
