tabItem(tabName = "id_conversion",
        useShinyjs(),
        tags$style(appCSS),
        fluidRow(
          gradientBox(title = "ID conversion",gradientColor = "teal",width =12,
                      footer=fluidRow(
                        column(width = 8,
                               "Multiple bio-sources are integrated into ID conversion tool for a comprehensive gene/transcript/protein ID conversion. This version mainly includes ENSEMBL, NCBI, Uniprot, Bioconductor and species-specific databases which prodvides detailed information on the gene level.",
                               br(),br(),
                               "Notes: Users can enter a list of IDs within the browser or upload a .txt file which should specify the ID column. Multi-mapped IDs will be collapsed with ';' ordered by input IDs."),
                        column(
                          width = 4,
                          boxPlus(solidHeader = F,width = 12,closable = F,
                                  title = "Status summary",
                                  footer =  fluidRow(
                                    column(
                                      width = 6,
                                      descriptionBlock(
                                        number = "2",
                                        number_color = "green",
                                        number_icon = "fa fa-caret-up",
                                        text = "Number of supported species", 
                                        right_border = TRUE,
                                        margin_bottom = FALSE
                                      )),
                                    column(
                                      width = 6,
                                      descriptionBlock(
                                        number = "10", 
                                        number_color = "green", 
                                        number_icon = "fa fa-caret-up",
                                        text = "Number of supported ID-types", 
                                        right_border = FALSE,
                                        margin_bottom = FALSE
                                      )))))
                      )),
          ##### Data input & settings #####
          gradientBox(title = "Data input & settings",width = 4,gradientColor = "teal",
                      footer = fluidRow(
                        boxPlus(title = tagList(shiny::icon("th-list"), "Input"),width = 12,closable = F,
                                column(9,
                                       radioButtons("input_id", label = "Options to input your data",
                                                    choices = list("Enter text with multi-line IDs " = "text",
                                                                   "Upload a .txt file and specify the ID column" = "file"))
                                ),
                                conditionalPanel(
                                  condition = "input.input_id == 'text'",
                                  column(3, style = "margin-top: 30px;",
                                         actionButton(inputId = "example_id",label = "Example",icon = icon("book-open"))
                                  ),
                                  box(width = 12,
                                      textAreaInput("textArea_id", "Enter text :",height = "200px",placeholder = "e.g.                                                                                                    ENSMUSG00000000001                                                                                                    ENSMUSG00000000028                                                                                                    ENSMUSG00000000037                                                                                                    ENSMUSG00000000049                                                                                                    ENSMUSG00000000058                                                                                                    ENSMUSG00000059552                                                                                                    ENSMUSG00000024406")
                                  )),
                                conditionalPanel(
                                  condition = "input.input_id == 'file'",
                                  box(width = 12,
                                      fluidRow(
                                        column(6,
                                               radioButtons(inputId = "fileheader_id",label = "Header:",choices = c("Yes", "No"),width = 6,selected = "Yes")
                                        ),
                                        column(6,
                                               radioButtons(inputId = "filesep_id",label="Separator:", choices = c("Tab", "Comma"),width = 6,selected = "Tab")
                                        ),
                                        column(12,
                                               fileInput("fileInput_id", "Upload your file :")
                                        )
                                      ),
                                      selectInput("field_id","Select ID column",choices = 1:100,selectize=TRUE)
                                  ) 
                                )),
                        
                        boxPlus(title = tagList(shiny::icon("cogs"), "Settings"),width = 12,closable = F,
                                fluidRow(
                                  column(5,
                                         selectInput('species_id', 'Seclect species :', choices = c("Human","Mouse"), selectize=TRUE,selected="Human")
                                  ),
                                  column(7,
                                         selectInput('from_id', 'Input ID type :', choices = fields_ID, selectize=TRUE,selected="Gene_Symbol"))),
                                checkboxGroupButtons(
                                  inputId = "to_id", label = "Output ID types :", 
                                  choices = fields_ID, selected="Gene_Symbol",
                                  justified = F, size="sm",
                                  checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon"))
                                ),
                                
                                fluidRow(
                                  column(8,
                                         prettyCheckbox(inputId = "select_all_id",label="Select/Deselect All",icon = icon("check"),value = F)
                                  ),
                                  column(4,
                                         withBusyIndicatorUI(
                                           actionButton("submit", "Submit",class = "btn-primary",icon = icon("play"))
                                         )
                                  )
                                ),
                                hr(),
                                helpText("Conversion for thousands of IDs will take about 10s or longer.")
                        ))
          ),
          ##### Data output #####
          gradientBox(title = "Data output",width = 8,gradientColor = "teal",
                      footer = fluidRow(
                        boxPlus(title = tagList(shiny::icon("table"), "Mapping table"),width=12,solidHeader = F,closable = F,
                                dataTableOutput(outputId = "mapping_dat")
                        ),
                        boxPlus(title = tagList(shiny::icon("receipt"), "Summary"),width = 5,solidHeader = F,closable = F,
                                htmlOutput("output_summary")
                        ),
                        boxPlus(title =  tagList(shiny::icon("cloud-download-alt"), "Download"),width = 7,solidHeader = F,closable = F,
                                  conditionalPanel(condition = "input.submit > 0",
                                                     column(6,
                                                            selectInput("out_dataset", "Choose a dataset:", 
                                                                        choices = c("Mapping table","Mapping table merged with input data", "Unmapped IDs"))),
                                                     column(3,
                                                            radioButtons("out_filetype", "File type:",
                                                                         choices = c("tsv", "csv"))),
                                                     column(3,
                                                            downloadButton('downloadData', 'Download'))
                                  )
                                )
                      ))
          
        ))