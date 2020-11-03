##### database building #####
# setwd("/data/tmp/ID_converter/")
# library(DBI)
# mydb <- dbConnect(RSQLite::SQLite(), "mouse.db.sqlite")
# ### dbWriteTable(mydb, "id_table", df)
# fields <- dbListFields(mydb,name = "id_table")
# for(field in fields){
#   dbSendQuery(mydb, paste("CREATE INDEX IF NOT EXISTS",field,"ON id_table(",field,")",sep = " "))
# }
# dbDisconnect(mydb)


# ##### test #####
# id_table <- read.table("./proteinGroups.txt",header = T,sep = "\t",stringsAsFactors = F)
# id_table[id_table==""] <- NA
# ids_0 <- id_table$Majority.protein.IDs
# # # ##
# secondUniprot <- read.table("./sec_ac.txt",header = T,sep = "\t",stringsAsFactors = F)
# secondUniprot[[1]] <- gsub(pattern = "\\s+", replacement = " ", x = str_trim(secondUniprot[[1]]))
# secondUniprot <- data.frame(do.call('rbind', strsplit(as.character(secondUniprot[[1]]),' ',fixed=TRUE)),stringsAsFactors = F)
# ids_0 <- c("A2ASS6")
# key_type <- "UniprotID"
# ids <- gsub(pattern = ";.*",replacement = "",x = ids_0,perl = T)
# ids <- str_extract(pattern = "(?<=\\|).*(?=\\|)",string = ids)
# if (key_type=="UniprotID") {
#   ids <- gsub(pattern = "-.*",replacement = "",x = ids,perl = T)
#   ids_dt <- merge(x = data.frame(ids_0,ids,stringsAsFactors = F),by.x = 2,all.x = T, y = secondUniprot,by.y = "X1",all.y = F)
#   ids_dt$X2[which(is.na(ids_dt$X2))] <- ids_dt$ids[which(is.na(ids_dt$X2))]
#   ids_dt <- ids_dt[,c("ids_0","X2")]
#   colnames(ids_dt) <- c("rawID",key_type)
# }else{
#   ids_dt <- data.frame(ids_0,ids)
#   colnames(ids_dt) <- c("rawID",key_type)
# }
# 
# ids<- paste0("'",paste(unique(ids_dt[,key_type]),collapse = "','"),"'")
# out_types <- c(key_type,"Gene_Symbol","ENSEMBL_gene")
# sqlcmd <- paste("SELECT",paste0(out_types,collapse = ","),"FROM id_table WHERE",key_type,"IN (",ids,")",
#       sep = " ")
# system.time(
# DT<- dbGetQuery(conn = mydb, statement = sqlcmd)
# )
# DT<- merge(x = ids_dt,by.x=key_type,y=DT,by.y=key_type) %>% data.table(key="rawID")
# DT<- DT[, lapply(.SD, FUN = function(x) paste0(unique(x),collapse = ";")), by=key(DT)]
# DT[] <- lapply(DT, function(x) gsub("(;$)|(^;)|(NA;)|(;NA)", "", x))
# dbDisconnect(mydb)





options(shiny.maxRequestSize=200*1024^2)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(dashboardthemes)
library(shinycssloaders)
library(shinybusy)
library(shinyjs)
library(DT)
library(fontawesome)
library(DBI)
library(tidyr)
library(plyr); library(dplyr) 
library(stringr)
library(data.table)
source("helpers.R")

mydb <- dbConnect(RSQLite::SQLite(), "mouse.db.sqlite")
fields <- dbListFields(mydb,name = "id_table")
fields_ID <- setdiff(fields,c("Gene_type","Chrom","UniprotID_iso"))
dbDisconnect(mydb)

secondUniprot <- read.table("./sec_ac.txt",header = T,sep = "\t",stringsAsFactors = F)
secondUniprot[[1]] <- gsub(pattern = "\\s+", replacement = " ", x = str_trim(secondUniprot[[1]]))
secondUniprot <- data.frame(do.call('rbind', strsplit(as.character(secondUniprot[[1]]),' ',fixed=TRUE)),stringsAsFactors = F)

ID_conversion <- function(ids_0,key_type,out_types=c("Gene_Symbol","ENTREZID"),species) {
  # Connect to the database
  mydb <- dbConnect(RSQLite::SQLite(), paste0("./",species,".db.sqlite"))
  # Construct the fetching query
  ids <- gsub(pattern = ";.*",replacement = "",x = ids_0,perl = T) %>% trimws()
  if (key_type=="UniprotID") {
    ids <- if_else(str_detect(pattern = "(?<=\\|).*(?=\\|)",string = ids),
                   str_extract(pattern = "(?<=\\|).*(?=\\|)",string = ids),
                   ids)
    ids <- gsub(pattern = "-.*",replacement = "",x = ids,perl = T)
    ids_dt <- merge(x = data.frame(ids_0,ids,stringsAsFactors = F),by.x = 2,all.x = T, y = secondUniprot,by.y = "X1",all.y = F)
    ids_dt$X2[which(is.na(ids_dt$X2))] <- ids_dt$ids[which(is.na(ids_dt$X2))]
    ids_dt <- ids_dt[,c("ids_0","X2")]
    colnames(ids_dt) <- c("rawID",key_type)
  }else{
    ids_dt <- data.frame(ids_0,ids)
    colnames(ids_dt) <- c("rawID",key_type)
  }
  
  ids<- paste0("'",paste(unique(ids_dt[,key_type]),collapse = "','"),"'")
  out_types <- unique(c(key_type,out_types))
  sqlcmd <- paste("SELECT",paste0(out_types,collapse = ","),"FROM id_table WHERE",key_type,"IN (",ids,")",
                  sep = " ")
  # Submit the fetch query and disconnect
  DT<- dbGetQuery(conn = mydb, statement = sqlcmd) 
  DT<- merge(x = ids_dt,by.x=key_type,y=DT,by.y=key_type) %>% data.table(key="rawID")
  DT<- DT[, lapply(.SD, FUN = function(x) paste0(unique(x),collapse = ";")), by=key(DT)]
  DT[] <- lapply(DT, function(x) gsub("(;$)|(^;)|(NA;)|(;NA)", "", x))
  dbDisconnect(mydb)
  return(as.data.frame(DT))
}

ui <- dashboardPagePlus(
  enable_preloader = TRUE,loading_duration = 1,sidebar_fullCollapse=T,
  #skin = "black",
  #### Sidebar Header ####
  dashboardHeaderPlus(
    enable_rightsidebar = TRUE,
    rightSidebarIcon = "gears",
    title="Bio-workstation",
    # title = tagList(
    #   span(class = "logo-lg", "shiny"), 
    #   img(src = "https://image.flaticon.com/icons/svg/204/204074.svg")),
    #### Sidebar Header dropdownMenu ####
    dropdownMenu(type = "messages",
                 messageItem(
                   from = "Alpha version",
                   message = "This version can be unstable"
                 ),
                 messageItem(
                   from = "New User",
                   message = "How do I register?",
                   icon = icon("question"),
                   time = Sys.time()
                 ),
                 messageItem(
                   from = "Support",
                   message = "The new server is ready.",
                   icon = icon("life-ring"),
                   time = "2014-12-01"
                 )
    ),
    dropdownMenu(type = "notifications",
                 notificationItem(
                   text = "5 new users today",
                   icon("users")
                 ),
                 notificationItem(
                   text = "12 items delivered",
                   icon("truck"),
                   status = "success"
                 ),
                 notificationItem(
                   text = "Server load at 86%",
                   icon = icon("exclamation-triangle"),
                   status = "warning"
                 )
    ),
    dropdownMenu(type = "tasks", badgeStatus = "success",
                 taskItem(value = 90, color = "green",
                          "Documentation"
                 ),
                 taskItem(value = 17, color = "aqua",
                          "Project X"
                 ),
                 taskItem(value = 75, color = "yellow",
                          "Server deployment"
                 ),
                 taskItem(value = 80, color = "red",
                          "Overall project"
                 )
    )),
  #### Sidebar content ####
  dashboardSidebar(
    div(style="color:white","font face"="Arial", strong("Main navigation")),
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("location-arrow")),
      menuItem("Data pre-processing", tabName = "datpreprocess", icon = icon("dolly"),startExpanded=F,
               menuSubItem("ID conversion", tabName = "id_conversion", icon = icon("sync-alt")),
               menuSubItem("Annotation", tabName = "annotation", icon = icon("pen-square")),
               menuSubItem("Normalization", tabName = "normalization", icon = icon("align-center"))
      ),
      menuItem("Downstream analysis", tabName = "analysis", icon = icon("chart-line"),startExpanded=F,
               menuSubItem("Statistics", tabName = "statistics", icon = icon("calculator")),
               menuSubItem("Enrichment analysis", tabName = "enrich", icon = icon("react")),
               menuSubItem("PCA&t-SNE", tabName = "pca", icon = icon("project-diagram"))
      ),
      menuItem("Charts", tabName = "charts", icon = icon("chart-bar"),startExpanded=F,
               menuSubItem("Volcano Plot", tabName = "volcano", icon = icon("chart-area")),
               menuSubItem("Heatmap", tabName = "heatmap", icon = icon("th"))
      ),
      menuItem("API",tabName = "api", icon = icon("link"),startExpanded=F)
    )),
  #### Body content ####
  dashboardBody(
    #### dashboard themes and header font ####
    shinyDashboardThemes(
      theme = "blue_gradient"
    ),
    tags$head(tags$style(HTML('
                              .main-header .logo {
                              font-family: "Georgia", Times, "Times New Roman", serif;
                              font-weight: bold;
                              font-size: 18px;
                              }
                              '))),
    
    #### tabItems ####
    tabItems(
      #### introduction ####
      tabItem(tabName = "introduction",
              fluidRow(
                box(title = "Welcome to Bio-workstation! (Beta)",solidHeader = FALSE,background =NULL,status = "danger",width =12,
                    "Bio-workstation a web-based application for data analysis and visualization.",
                    br(),br(),
                    "Developer: Hao zhang",
                    br(),
                    "Email: haozhang@njmu.edu.cn",
                    hr(),
                    strong("This version is still under testing phase."),
                    hr(),
                    notificationItem(
                      text = "ID conversion",
                      icon("check-square"),
                      status = "success"
                    ),
                    br(),
                    notificationItem(
                      text = "Enrichment analysis",
                      icon("truck"),
                      status = "success"
                    )
                )
              )),
      #### ####
      # First tab content
      tabItem(tabName = "id_conversion",
              useShinyjs(),
              tags$style(appCSS),
              fluidRow(
                #### ID conversion introcudtion ####
                box(title = "ID conversion",solidHeader = T,background =NULL,status = "primary",width =12,collapsible=T,
                    column(width = 8,
                           "Multiple bio-sources are integrated into ID conversion tool for a comprehensive gene/transcript/protein ID conversion. This version mainly includes ENSEMBL, NCBI, Uniprot, Bioconductor and species-specific databases which prodvides much information on the gene level.",
                           hr(),
                           "Users can enter a list of IDs within the browser or upload a .txt file which should specify the ID column. Multi-mapped IDs will be collapsed with ';' ordered by input IDs."),
                    column(
                      width = 4,
                      box(solidHeader = F,width = 12,
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
                ),
                ##### Data input & settings #####
                box(title = "Data input & settings",width = 4,status = "primary",solidHeader = T,
                    radioButtons("input_id", label = "Options to input your data",
                                 choices = list("Enter text with multi-line IDs " = "text",
                                                "Upload a .txt file contain IDs and specify the ID column" = "file")),
                    conditionalPanel(
                      condition = "input.input_id == 'text'",
                      box(width = 12,status = "primary",
                          textAreaInput("textArea_id", "Enter text :",height = "200px",placeholder = "e.g.                                                                                 ENSG00000001036                                                                                 ENSG00000001084                                                                                 ENSG00000001497")
                      )),
                    conditionalPanel(
                      condition = "input.input_id == 'file'",
                      box(width = 12,status = "primary",
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
                          selectInput("field_key","Select ID column",choices = 1:100,selectize=TRUE)
                      )),
                    box(title = "Settings",width = 12,status = "primary",
                        fluidRow(
                          column(5,
                                 selectInput('species_id', 'Seclect species :', choices = c("Human","Mouse"), selectize=TRUE,selected="Human")
                          ),
                          column(7,
                                 selectInput('from_id', 'Input ID type :', choices = fields_ID, selectize=TRUE,selected="Gene_Symbol"))),
                        checkboxGroupButtons(
                          inputId = "to_id", label = "Output ID types :", 
                          choices = fields_ID, selected="Gene_Symbol",
                          justified = F, status = "primary",size="sm",
                          checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon"))
                        ),
                        
                        fluidRow(
                          column(8,
                                 checkboxInput(inputId = "select_all_id",label="Select/Deselect All", value = F)
                          ),
                          column(4,
                                 withBusyIndicatorUI(
                                   actionButton("submit", "Submit",class = "btn-primary")
                                 )
                          )
                        ),
                        hr(),
                        helpText("Conversion for thousands of IDs will take about 10s or longer.")
                    )
                ),
                ##### Data output #####
                box(title = "Data output",width = 8,status = "primary",solidHeader = T,
                    conditionalPanel(condition = "input.submit > 0",
                                     dataTableOutput(outputId = "mapping_dat") %>% withSpinner()
                    )
                ),
                box(title = "Input summary",width = 4,status = "primary",solidHeader = T,
                    htmlOutput("input_summary")
                ),
                box(title = "Output summary",width = 4,status = "primary",solidHeader = T,
                    htmlOutput("output_summary")
                ),
                box(title = "Download",width = 8,status = "danger",solidHeader = T,
                    conditionalPanel(condition = "input.submit > 0",
                                     fluidRow(
                                       column(4,
                                              selectInput("out_dataset", "Choose a dataset:", 
                                                          choices = c("Mapping table","Mapping table merged with input data", "Unmapped IDs"))),
                                       column(2,
                                              radioButtons("out_filetype", "File type:",
                                                           choices = c("tsv", "csv"))),
                                       column(3,
                                              downloadButton('downloadData', 'Download')),
                                       column(3,
                                              checkboxInput(inputId = "transfer",label="Transfer IDs to the enrichment-analysis module. (experimental)", value = F))
                                     )
                    )
                )
              )),
      # Second tab content
      tabItem(tabName = "enrich",
              fluidRow(
                box(title = "Enrichment analysis",solidHeader = T,background =NULL,status = "primary",width =12,collapsible=T,
                    column(8,
                           "Gene IDs from different bio-sources can be take as input for enrichment analysis. This module can provide functional gene ontology or KEGG overrepresentation analysis employed with clusterprofiler R package[1]. More molecular signatures databases (MSigDB) or analysis methods will be included in the future.",
                           br(),
                           "Note: IDs from the ID conversion tools can be used directly.",
                           hr(),
                           em("[1].clusterProfiler: an R package for comparing biological themes among gene clusters[J]. Omics: a journal of integrative biology, 2012, 16(5): 284-287.")
                           
                    ),
                    column(
                      width = 4,
                      box(solidHeader = F,width = 12,
                          title = "Status summary",
                          footer =  fluidRow(
                            column(
                              width = 6,
                              descriptionBlock(
                                number = "2",
                                number_color = "green",
                                number_icon = "fa fa-caret-up",
                                text = "Number of supported MSigDBs", 
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
                              )))))
                )
              )
      )
    )
    )
    )

server <- function(input, output,session) {
  
  
  
  dat <- reactiveValues()
  dat$input <- NULL
  dat$field_key <- 1
  
  observeEvent(input$input_id,{
    reset('fileInput_id')
  })
  
  observeEvent(input$textArea_id,{
    if (gsub(pattern = "\\s",replacement = "",x = input$textArea_id,perl = T)!="") {
      dat$input_1 <- read.table(text=input$textArea_id,header = F,fill = T,stringsAsFactors = F)
      dat$field_key <- 1
      # output$mapping_dat <-renderDataTable(expr = data.frame(dat$input[[dat$field_key]]))
    }
  },ignoreInit = TRUE)
  
  observeEvent(input$fileInput_id,{
    inFile <- input$fileInput_id
    header <- switch(input$fileheader_id,"Yes"=TRUE,"No"=FALSE)
    sep <- switch(input$filesep_id,"Tab"="\t","Comma"=";")
    dat$input_2 <- read.table(inFile$datapath, header = header,sep=sep,stringsAsFactors = F,fill = T,quote = "")
    updateSelectInput(session, "field_key", choices = colnames(dat$input_2))
  }, ignoreInit = TRUE)
  
  observeEvent(input$field_key,{
    dat$field_key <- input$field_key
  })
  
  observeEvent(input$select_all_id, {
    if (input$select_all_id){
      updateCheckboxGroupButtons(session, "to_id", selected = fields_ID)
    } else {
      updateCheckboxGroupButtons(session, "to_id", selected = character(0))
    }
  }, ignoreInit = TRUE)
  
  observeEvent(input$submit,{
    withBusyIndicatorServer("submit",{
      
      species_id <- switch(input$species_id,"Human"="human","Mouse"="mouse")
      if (input$input_id=="text") {
        dat$input <- dat$input_1
      }else{
        dat$input <- dat$input_2
      }
      if (!is.null(dat$input)) {
        
        output$mapping_dat <-renderDataTable(expr = NULL)
        dat$input$ID_mapping <- ">>>>>>"
        dat$output<- ID_conversion(ids_0 = dat$input[[dat$field_key]],
                                   key_type = input$from_id,
                                   out_types = input$to_id,
                                   species = species_id)
        dat$input_summary <- paste("Species:  ",species_id,"<br/>","Number of input unique/total IDs:  ",length(unique(dat$input[[dat$field_key]])),"/",length(dat$input[[dat$field_key]]),"<br/>","Input ID type:  ",input$from_id)
        dat$output_summary <- paste("Number of mapped/unmapped IDs (unique)  : ",nrow(dat$output),"/",length(unique(dat$input[[dat$field_key]]))-nrow(dat$output),"<br/>","Output ID types:  ",paste0(input$to_id,collapse = "; "))
        output$mapping_dat <-renderDataTable(expr = dat$output, options = list(
          pageLength = 10,
          autoWidth = F,
          scrollX='400px',
          lengthChange = FALSE,
          initComplete = JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'font-size': '90%'});",
            "$(this.api().table().body()).css({'font-size': '90%'});",
            "}"),
          columnDefs = list(list(
            targets = "_all",
            width = '100px',
            render = JS(
              "function(data, type, row, meta) {",
              "return type === 'display' && data.length > 20 ?",
              "'<span title=\"' + data + '\">' + data.substr(0, 20) + '...</span>' : data;",
              "}")))
        ), callback = JS('table.page(3).draw(false);')
        )
      }else{
        output$mapping_dat <-renderDataTable(expr = data.frame())
      }
    })
  })
  
  output$input_summary <- renderUI({HTML(dat$input_summary)})
  output$output_summary <- renderUI({HTML(dat$output_summary)})
  
  datadownload <- reactive({
    switch(input$out_dataset,
           "Mapping table"=dat$output,
           "Mapping table merged with input data"= merge(x = dat$input,by.x=dat$field_key,y = dat$output,by.y="rawID",all=T),
           "Unmapped IDs"=data.frame(unmappedID=setdiff(x=unique(dat$input[[dat$field_key]]),y=dat$output[["rawID"]]))
    )
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$out_dataset, input$out_filetype, sep = ".")
    },
    content = function(file) {
      sep <- switch(input$out_filetype, "csv" = ",", "tsv" = "\t")
      write.table(datadownload(), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
}

shinyApp(ui, server)





