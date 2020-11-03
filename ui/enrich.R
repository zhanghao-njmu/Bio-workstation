tabItem(tabName = "enrich",
        useShinyjs(),
        tags$style(appCSS),
        fluidRow(
          gradientBox(title = "Enrichment analysis",gradientColor = "teal",width =12,
                      footer=fluidRow(
                        column(8,
                               "Gene IDs from different bio-sources can be take as input for enrichment analysis. This module can provide functional gene sets overrepresentation analysis employed with clusterprofiler[1] and AnnotationDbi R packages[2]. More functional gene sets or analysis methods will be included in the future.",
                               br(),br(),
                               "Annotation data used in GO, KEGG or orther optional enrichment analysis are extracted from organism specific packages which is maintained by Bioconductor and updated every 6 months, e.g. org.Hs.eg.db. These annotation are primarily based on mapping using Entrez Gene identifiers. So it is highly recommended to enter Entrez ID which supplied by NCBI or official Gene symbol (pay attention to character case) as the input. If not, ID conversion will be pre-processed at the back end.",
                               br(),br(),
                               "Note: IDs from the ID conversion tools can be used directly.",
                               hr(),
                               em("[1].clusterProfiler: an R package for comparing biological themes among gene clusters[J]. Omics: a journal of integrative biology, 2012, 16(5): 284-287."),
                               br(),
                               em("[2].AnnotationDbi: Annotation Database Interface. R package version 1.44.0.")
                        ),
                        column(
                          width = 4,
                          box(solidHeader = F,width = 12,
                              title = "Status summary",
                              footer =  fluidRow(
                                column(
                                  width = 6,
                                  descriptionBlock(
                                    number = "9",
                                    number_color = "green",
                                    number_icon = "fa fa-caret-up",
                                    text = "Number of supported gene sets", 
                                    right_border = TRUE,
                                    margin_bottom = FALSE
                                  )),
                                column(
                                  width = 6,
                                  descriptionBlock(
                                    number = "1", 
                                    number_color = "green", 
                                    number_icon = "fa fa-caret-up",
                                    text = "Number of supported analysis methods", 
                                    right_border = FALSE,
                                    margin_bottom = FALSE
                                  )
                                )
                              )
                          )
                        )
                      )
          ),
          ##### Data input & settings #####
          gradientBox(title = "Data input & settings",width = 4,gradientColor = "teal",
                      footer = fluidRow(
                        boxPlus(title = tagList(shiny::icon("th-list"), "Input"),width = 12,closable = F,
                                column(12,
                                       materialSwitch(inputId = "use_id_input_enrich", label = "Use input data from the ID conversion module", value=F,status = "primary",right=T)
                                ),
                                column(9,
                                       radioButtons("input_enrich", label = "Options to input your data",
                                                    choices = list("Enter text with multi-line IDs " = "text",
                                                                   "Upload a .txt file and specify the ID column" = "file"))
                                ),
                                column(3, style = "margin-top: 30px;",
                                       actionButton(inputId = "example_enrich",label = "Example",icon = icon("book-open"))
                                ),
                                conditionalPanel(
                                  condition = "input.input_enrich == 'text'",
                                  box(width = 12,
                                      textAreaInput("textArea_enrich", "Enter text :",height = "200px",placeholder = "e.g.                                                                                                    10136                                                                                                    9833                                                                                                    6208                                                                                                    71")
                                  )),
                                conditionalPanel(
                                  condition = "input.input_enrich == 'file'",
                                  box(width = 12,
                                      fluidRow(
                                        column(6,
                                               radioButtons(inputId = "fileheader_enrich",label = "Header:",choices = c("Yes", "No"),width = 6,selected = "Yes")
                                        ),
                                        column(6,
                                               radioButtons(inputId = "filesep_enrich",label="Separator:", choices = c("Tab", "Comma"),width = 6,selected = "Tab")
                                        ),
                                        column(12,
                                               fileInput("fileInput_enrich", "Upload your file :")
                                        )
                                      ),
                                      selectInput("field_enrich","Select ID column",choices = 1:100,selectize=TRUE)
                                  )
                                )
                          
                                ),
                        
                        boxPlus(title = tagList(shiny::icon("cogs"), "Settings"),width = 12,closable = F,
                                tags$style(HTML("
                                                .tabbable > .nav > li > a                  {color:black;background-color: transparent;border-color:transparent;border-top-color:black;border-left-color:black;border-right-color:black;}
                                                .tabbable > .nav > li[class=active]    > a {color:white;background-color: black;border-color:transparent;}
                                                }")),
                                tabsetPanel(
                                  tabPanel(title = "ID type",
                                           selectInput('species_enrich', 'Seclect species :', choices = c("Human","Mouse"), selectize=TRUE,selected="Human"),
                                           selectInput('idtype_enrich', 'Input ID type :', choices = fields_ID, selectize=TRUE,selected="Gene_Symbol")
                                  ),
                                  tabPanel(title = "Analysis settings",
                                           pickerInput(inputId = "msigdb_enrich",
                                                       label = "Select gene sets (e.g. BP, MF, CC for GeneOntology)", 
                                                       choices = c("BP","CC","MF","KEGG","Pfam","Reactome","Chromosomes","Protein complex","MeSH"), 
                                                       selected = c("BP","CC","MF","KEGG"),
                                                       options = list(
                                                         `actions-box` = TRUE, 
                                                         size = 10,
                                                         `selected-text-format` = "count > 4"
                                                       ), 
                                                       multiple = TRUE
                                           ),
                                           conditionalPanel(
                                             #condition ="input.msigdb_enrich !== null &&(input.msigdb_enrich.includes('BP')||input.msigdb_enrich.includes('CC')||input.msigdb_enrich.includes('MF'))",
                                             condition ="(input.msigdb_enrich.indexOf('BP') != -1 || input.msigdb_enrich.indexOf('CC') != -1||input.msigdb_enrich.indexOf('MF') != -1)",
                                            
                                             box(width = 12,title = "GO simplification setting:",
                                                
                                                 fluidRow(
                                                   column(5,style = "margin-top: 10px;",
                                                          materialSwitch(inputId = "simgo_enrich", label = "Simplify", value=T,status = "primary",right=T)
                                                   ),
                                                   column(7,
                                                          radioButtons(
                                                            inputId = "simgo_enrich_cut", label = "Threshold:", 
                                                            choices = c("p<0.05","p.adjust<0.05"), selected="p.adjust<0.05",inline = T)
                                                   ),
                                                   column(6,
                                                          selectInput('simgoby_enrich', 'Simplify GO by:', choices = c("pvalue","p.adjust"), selectize=TRUE,selected="p.adjust")
                                                   ),
                                                   column(6,
                                                          selectInput('simgomet_enrich', 'Simplification method:', choices = c("Resnik","Lin","Rel","Jiang", "Wang"), selectize=TRUE,selected="Rel")
                                                   )
                                                 )
                                             ) 
                                           ),
                                           conditionalPanel(
                                             #condition ="input.msigdb_enrich !== null &&(input.msigdb_enrich.includes('BP')||input.msigdb_enrich.includes('CC')||input.msigdb_enrich.includes('MF'))",
                                             condition ="input.msigdb_enrich.indexOf('MeSH') != -1",
                                             box(width = 12,title = "MeSH category and simplification setting:",
                                                 fluidRow(
                                                   column(12,
                                                          pickerInput(inputId = "MeSH_enrich", 
                                                                      label = "Select MeSH category", 
                                                                      choices = c("A (Anatomy)","B (Organisms)","C (Diseases)","D (Chemicals and Drugs)",
                                                                                  "E (Analytical Diagnostic and Therapeutic Techniques and Equipment)","F (Psychiatry and Psychology)",
                                                                                  "G (Phenomena and Processes)","H (Disciplines and Occupations)",
                                                                                  "I (Anthropology, Education, Sociology and Social Phenomena)",
                                                                                  "J (Technology and Food and Beverages)",
                                                                                  "K (Humanities)","L (Information Science)","M (Persons)","N (Health Care)",
                                                                                  "V (Publication Type)","Z (Geographical Locations)"), 
                                                                      selected = c("C (Diseases)","G (Phenomena and Processes)"),
                                                                      options = list(
                                                                        `actions-box` = TRUE, 
                                                                        size = 10,
                                                                        `selected-text-format` = "count > 4"
                                                                      ),
                                                                      multiple = TRUE
                                                          )
                                                   ),
                                                   column(5,style = "margin-top: 10px;",
                                                          materialSwitch(inputId = "simmesh_enrich", label = "Testing..", value=F,status = "primary",right=T)
                                                          ),
                                                   column(7,
                                                          radioButtons(
                                                            inputId = "simmesh_enrich_cut", label = "Threshold:", 
                                                            choices = c("p<0.05","p.adjust<0.05"), selected="p.adjust<0.05",inline = T)
                                                   ),
                                                   column(6,
                                                          selectInput('simmeshby_enrich', 'Simplify MeSH by:', choices = c("pvalue","p.adjust"), selectize=TRUE,selected="p.adjust")
                                                   ),
                                                   column(6,
                                                          selectInput('simmeshmet_enrich', 'Simplification method:', choices = c("Resnik","Lin","Rel","Jiang", "Wang"), selectize=TRUE,selected="Rel")
                                                   )
                                                 )
                                             )
                                           ),
                                           selectInput(inputId = 'padmethod_enrich', label = 'Select p.adjust method :', choices = c("BH","bonferroni","BY","fdr", "holm", "hochberg", "hommel","none"), selectize=TRUE,selected="BH"),
                                           sliderInput(inputId = "GSSize_enrich",label = "Set size-range of gene sets for testing",min = 3,max = 500,value = c(3,300)),
                                           prettyCheckbox(inputId = "readable_enrich",label = "Whether to convert ID to gene symbol in the output",value = T,icon = icon("check")),
                                           radioButtons("bgsets_enrich",label = "Select background gene list",choices = list("All annotated genes in selected gene sets" = NULL,
                                                                                                                             "Upload a custom ID list" = "file")),
                                           conditionalPanel(
                                             condition = "input.bgsets_enrich == 'file'",
                                             box(width = 12,
                                                 fluidRow(
                                                   column(6,
                                                          radioButtons(inputId = "fileheader_enrich2",label = "Header:",choices = c("Yes", "No"),width = 6,selected = "Yes")
                                                   ),
                                                   column(6,
                                                          radioButtons(inputId = "filesep_enrich2",label="Separator:", choices = c("Tab", "Comma"),width = 6,selected = "Tab")
                                                   ),
                                                   column(12,
                                                          fileInput("fileInput_enrich2", "Upload your file :")
                                                   )
                                                 ),
                                                 selectInput("field_enrich2","Select ID column",choices = 1:100,selectize=TRUE)
                                             ) 
                                           ),
                                           
                                           fluidRow(
                                             column(8),column(4,
                                             withBusyIndicatorUI(
                                               actionButton("submit_enrich", "Submit",class = "btn-primary",icon = icon("play"))
                                             )),
                                             textOutput("log_enrich"),
                                             useShinyjs()
                                           ),
                                           hr(),
                                           helpText("More gene sets or simplification selected will take more time."))
                                )
                             
                        )
        )
        ),
        
        ##### Data output #####
        gradientBox(title = "Data output",width = 8,gradientColor = "teal",
                    footer = fluidRow(
                      boxPlus(title = tagList(shiny::icon("table"), "Enrichment result"),width = 12,closable = F,
                              tags$style(HTML("
.tabbable > .nav > li > a                  {color:black;background-color: transparent;border-color:transparent;border-top-color:black;border-left-color:black;border-right-color:black;}
.tabbable > .nav > li[class=active]    > a {color:white;background-color: black;border-color:transparent;}
        }")),
                              uiOutput('tabs_enrich'),
                              verbatimTextOutput("test_value")
                      )
#                       boxPlus(title = tagList(shiny::icon("chart-bar"), "Plot"),width = 12,closable = F,
#                               tags$style(HTML("
# .tabbable > .nav > li > a                  {color:black;background-color: transparent;border-color:transparent;border-top-color:black;border-left-color:black;border-right-color:black;}
# .tabbable > .nav > li[class=active]    > a {color:white;background-color: black;border-color:transparent;}
#         }"))
#                      )
                    )
        )
          )
)

