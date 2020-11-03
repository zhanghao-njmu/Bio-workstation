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
        ))