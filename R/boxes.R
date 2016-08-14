#' Create a value box for the main body of a dashboard.
#'
#' A value box displays a value (usually a number) in large text, with a smaller
#' subtitle beneath, and a large icon on the right side. Value boxes are meant
#' to be placed in the main body of a dashboard.
#'
#' @inheritParams box
#' @param value The value to display in the box. Usually a number or short text.
#' @param subtitle Subtitle text.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box. Valid colors are listed in
#'   \link{validColors}.
#' @param href An optional URL to link to.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @export
valueBox <- function(value, subtitle, icon = NULL, color = "aqua", width = 4,
  href = NULL)
{
  validateColor(color)
  if (!is.null(icon)) tagAssert(icon, type = "i")

  boxContent <- div(class = paste0("small-box bg-", color),
    div(class = "inner",
      h3(value),
      p(subtitle)
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )

  if (!is.null(href))
    boxContent <- a(href = href, boxContent)

  div(class = if (!is.null(width)) paste0("col-sm-", width),
    boxContent
  )
}


#' Create an info box for the main body of a dashboard.
#'
#' An info box displays a large icon on the left side, and a title, value
#' (usually a number), and an optional smaller subtitle on the right side. Info
#' boxes are meant to be placed in the main body of a dashboard.
#'
#' @inheritParams box
#' @param title Title text.
#' @param value The value to display in the box. Usually a number or short text.
#' @param subtitle Subtitle text (optional).
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box. Valid colors are listed in
#'   \link{validColors}.
#' @param fill If \code{FALSE} (the default), use a white background for the
#'   content, and the \code{color} argument for the background of the icon. If
#'   \code{TRUE}, use the \code{color} argument for the background of the
#'   content; the icon will use the same color with a slightly darkened
#'   background.
#' @param href An optional URL to link to.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @export
infoBox <- function(title, value = NULL, subtitle = NULL,
  icon = shiny::icon("bar-chart"), color = "aqua", width = 4, href = NULL,
  fill = FALSE, prog = NULL, prog.width = "70%") {

  validateColor(color)
  tagAssert(icon, type = "i")

  colorClass <- paste0("bg-", color)

  boxContent <- div(
    class = "info-box",
    class = if (fill) colorClass,
    span(
      class = "info-box-icon",
      class = if (!fill) colorClass,
      icon
    ),
    div(class = "info-box-content",
      span(class = "info-box-text", title),
      if (!is.null(value)) span(class = "info-box-number", value),
      if (!is.null(subtitle)) p(subtitle),
      HTML('<!-- The progress section is optional -->'),
      if (fill && !is.null(prog)) div(class = "progress", div(class = "progress-bar", style = paste0("width: ", prog.width))),
      if (fill && !is.null(prog)) span(class = "progress-description", prog)
    )
  )

  if (!is.null(href))
    boxContent <- a(href = href, boxContent)

  div(class = if (!is.null(width)) paste0("col-sm-", width),
    boxContent
  )
}


#' Create a box for the main body of a dashboard
#'
#' Boxes can be used to hold content in the main body of a dashboard.
#'
#' @param title Optional title.
#' @param footer Optional footer text.
#' @param status The status of the item This determines the item's background
#'   color. Valid statuses are listed in \link{validStatuses}.
#' @param solidHeader Should the header be shown with a solid color background?
#' @param background If NULL (the default), the background of the box will be
#'   white. Otherwise, a color string. Valid colors are listed in
#'   \link{validColors}.
#' @param width The width of the box, using the Bootstrap grid system. This is
#'   used for row-based layouts. The overall width of a region is 12, so the
#'   default valueBox width of 4 occupies 1/3 of that width. For column-based
#'   layouts, use \code{NULL} for the width; the width is set by the column that
#'   contains the box.
#' @param height The height of a box, in pixels or other CSS unit. By default
#'   the height scales automatically with the content.
#' @param collapsible If TRUE, display a button in the upper right that allows
#'   the user to collapse the box.
#' @param collapsed If TRUE, start collapsed. This must be used with
#'   \code{collapsible=TRUE}.
#' @param ... Contents of the box.
#'
#' @family boxes
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' # A dashboard body with a row of infoBoxes and valueBoxes, and two rows of boxes
#' body <- dashboardBody(
#'
#'   # infoBoxes
#'   fluidRow(
#'     infoBox(
#'       "Orders", uiOutput("orderNum2"), "Subtitle", icon = icon("credit-card")
#'     ),
#'     infoBox(
#'       "Approval Rating", "60%", icon = icon("line-chart"), color = "green",
#'       fill = TRUE
#'     ),
#'     infoBox(
#'       "Progress", uiOutput("progress2"), icon = icon("users"), color = "purple"
#'     )
#'   ),
#'
#'   # valueBoxes
#'   fluidRow(
#'     valueBox(
#'       uiOutput("orderNum"), "New Orders", icon = icon("credit-card"),
#'       href = "http://google.com"
#'     ),
#'     valueBox(
#'       tagList("60", tags$sup(style="font-size: 20px", "%")),
#'        "Approval Rating", icon = icon("line-chart"), color = "green"
#'     ),
#'     valueBox(
#'       htmlOutput("progress"), "Progress", icon = icon("users"), color = "purple"
#'     )
#'   ),
#'
#'   # Boxes
#'   fluidRow(
#'     box(status = "primary",
#'       sliderInput("orders", "Orders", min = 1, max = 2000, value = 650),
#'       selectInput("progress", "Progress",
#'         choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80,
#'                     "100%" = 100)
#'       )
#'     ),
#'     box(title = "Histogram box title",
#'       status = "warning", solidHeader = TRUE, collapsible = TRUE,
#'       plotOutput("plot", height = 250)
#'     )
#'   ),
#'
#'   # Boxes with solid color, using `background`
#'   fluidRow(
#'     # Box with textOutput
#'     box(
#'       title = "Status summary",
#'       background = "green",
#'       width = 4,
#'       textOutput("status")
#'     ),
#'
#'     # Box with HTML output, when finer control over appearance is needed
#'     box(
#'       title = "Status summary 2",
#'       width = 4,
#'       background = "red",
#'       uiOutput("status2")
#'     ),
#'
#'     box(
#'       width = 4,
#'       background = "light-blue",
#'       p("This is content. The background color is set to light-blue")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$orderNum <- renderText({
#'     prettyNum(input$orders, big.mark=",")
#'   })
#'
#'   output$orderNum2 <- renderText({
#'     prettyNum(input$orders, big.mark=",")
#'   })
#'
#'   output$progress <- renderUI({
#'     tagList(input$progress, tags$sup(style="font-size: 20px", "%"))
#'   })
#'
#'   output$progress2 <- renderUI({
#'     paste0(input$progress, "%")
#'   })
#'
#'   output$status <- renderText({
#'     paste0("There are ", input$orders,
#'       " orders, and so the current progress is ", input$progress, "%.")
#'   })
#'
#'   output$status2 <- renderUI({
#'     iconName <- switch(input$progress,
#'       "100" = "ok",
#'       "0" = "remove",
#'       "road"
#'     )
#'     p("Current status is: ", icon(iconName, lib = "glyphicon"))
#'   })
#'
#'
#'   output$plot <- renderPlot({
#'     hist(rnorm(input$orders))
#'   })
#' }
#'
#' shinyApp(
#'   ui = dashboardPage(
#'     dashboardHeader(),
#'     dashboardSidebar(),
#'     body
#'   ),
#'   server = server
#' )
#' }
#' @export
box <- function(..., title = NULL, footer = NULL, status = NULL,
                solidHeader = FALSE, background = NULL, width = 6,
                height = NULL, collapsible = FALSE, collapsed = FALSE) {

  boxClass <- "box"
  if (solidHeader || !is.null(background)) {
    boxClass <- paste(boxClass, "box-solid")
  }
  if (!is.null(status)) {
    validateStatus(status)
    boxClass <- paste0(boxClass, " box-", status)
  }
  if (collapsible && collapsed) {
    boxClass <- paste(boxClass, "collapsed-box")
  }
  if (!is.null(background)) {
    validateColor(background)
    boxClass <- paste0(boxClass, " bg-", background)
  }

  style <- NULL
  if (!is.null(height)) {
    style <- paste0("height: ", validateCssUnit(height))
  }

  titleTag <- NULL
  if (!is.null(title)) {
    titleTag <- h3(class = "box-title", title)
  }

  collapseTag <- NULL
  if (collapsible) {
    buttonStatus <- status %OR% "default"

    collapseIcon <- if (collapsed) "plus" else "minus"

    collapseTag <- div(class = "box-tools pull-right",
      tags$button(class = paste0("btn btn-box-tool"),
        `data-widget` = "collapse",
        shiny::icon(collapseIcon)
      )
    )
  }

  headerTag <- NULL
  if (!is.null(titleTag) || !is.null(collapseTag)) {
    headerTag <- div(class = "box-header",
      titleTag,
      collapseTag
    )
  }

  div(class = if (!is.null(width)) paste0("col-sm-", width),
    div(class = boxClass,
      style = if (!is.null(style)) style,
      headerTag,
      div(class = "box-body", ...),
      if (!is.null(footer)) div(class = "box-footer", footer)
    )
  )
}


#' Create a tabbed box
#'
#' @inheritParams shiny::tabsetPanel
#' @inheritParams box
#' @param title Title for the tabBox.
#' @param side Which side of the box the tabs should be on (\code{"left"} or
#'   \code{"right"}). When \code{side="right"}, the order of tabs will be
#'   reversed.
#'
#' @family boxes
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' body <- dashboardBody(
#'   fluidRow(
#'     tabBox(
#'       title = "First tabBox",
#'       # The id lets us use input$tabset1 on the server to find the current tab
#'       id = "tabset1", height = "250px",
#'       tabPanel("Tab1", "First tab content"),
#'       tabPanel("Tab2", "Tab content 2")
#'     ),
#'     tabBox(
#'       side = "right", height = "250px",
#'       selected = "Tab3",
#'       tabPanel("Tab1", "Tab content 1"),
#'       tabPanel("Tab2", "Tab content 2"),
#'       tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
#'     )
#'   ),
#'   fluidRow(
#'     tabBox(
#'       # Title can include an icon
#'       title = tagList(shiny::icon("gear"), "tabBox status"),
#'       tabPanel("Tab1",
#'         "Currently selected tab from first box:",
#'         verbatimTextOutput("tabset1Selected")
#'       ),
#'       tabPanel("Tab2", "Tab content 2")
#'     )
#'   )
#' )
#'
#' shinyApp(
#'   ui = dashboardPage(dashboardHeader(title = "tabBoxes"), dashboardSidebar(), body),
#'   server = function(input, output) {
#'     # The currently selected tab from the first box
#'     output$tabset1Selected <- renderText({
#'       input$tabset1
#'     })
#'   }
#' )
#' }
#' @export
tabBox <- function(..., id = NULL, selected = NULL, title = NULL,
                   width = 6, height = NULL, side = c("left", "right"))
{
  side <- match.arg(side)

  # The content is basically a tabsetPanel with some custom modifications
  content <- shiny::tabsetPanel(..., id = id, selected = selected)
  content$attribs$class <- "nav-tabs-custom"

  # Set height
  if (!is.null(height)) {
    content <- tagAppendAttributes(content,
      style = paste0("height: ", validateCssUnit(height))
    )
  }

  # Move tabs to right side if needed
  if (side == "right") {
    content$children[[1]] <- tagAppendAttributes(content$children[[1]],
      class = "pull-right"
    )
  }

  # Add title
  if (!is.null(title)) {
    if (side == "left")
      titleClass <- "pull-right"
    else
      titleClass <- "pull-left"

    content$children[[1]] <- htmltools::tagAppendChild(content$children[[1]],
      tags$li(class = paste("header", titleClass), title)
    )
  }

  div(class = paste0("col-sm-", width), content)
}


#' Create a calendar box for the main body of a dashboard.
#'
#' A calendar box displays calendar as main box content, an optional list of
#' calendar menu, and optional smaller subtitles on the box footer often as
#' task tracker. Calendar boxes are meant to be placed in the main body of a
#' dashboard.
#'
#' @inheritParams box
#' @param title Title text.
#' @param value The value to display in the box. Usually a number or short text.
#' @param subtitle Subtitle text (optional).
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box. Valid colors are listed in
#'   \link{validColors}.
#' @param fill If \code{FALSE} (the default), use a white background for the
#'   content, and the \code{color} argument for the background of the icon. If
#'   \code{TRUE}, use the \code{color} argument for the background of the
#'   content; the icon will use the same color with a slightly darkened
#'   background.
#' @param href An optional URL to link to.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @export
calendarBox <- function(title, calendarMenu = NULL,
  icon = shiny::icon("calendar"), color = "aqua", width = 6, href = NULL,
  fill = FALSE, tasks = NULL, tasksProg = NULL) {

  HTML(paste0(
    '
    <!-- Calendar -->
    <div class="box box-solid bg-green-gradient">
      <div class="box-header">
        <i class="fa fa-calendar"></i>

        <h3 class="box-title">Calendar</h3>
        <!-- tools box -->
          <div class="pull-right box-tools">
          <!-- button with a dropdown -->
          <div class="btn-group">
            <button type="button" class="btn btn-success btn-sm dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-bars"></i></button>
            <ul class="dropdown-menu pull-right" role="menu">
              <li><a href="#">Add new event</a></li>
              <li><a href="#">Clear events</a></li>
              <li class="divider"></li>
              <li><a href="#">View calendar</a></li>
            </ul>
          </div>
          <button type="button" class="btn btn-success btn-sm" data-widget="collapse"><i class="fa fa-minus"></i>
          </button>
          <button type="button" class="btn btn-success btn-sm" data-widget="remove"><i class="fa fa-times"></i>
          </button>
        </div>
        <!-- /. tools -->
      </div>
      <!-- /.box-header -->
      <div class="box-body no-padding">
        <!--The calendar -->
        <div id="calendar" style="width: 100%"></div>
      </div>
      <!-- /.box-body -->
      <div class="box-footer text-black">
        <div class="row">
          <div class="col-sm-6">
            <!-- Progress bars -->
            <div class="clearfix">
              <span class="pull-left">Task #1</span>
              <small class="pull-right">90%</small>
            </div>
            <div class="progress xs">
              <div class="progress-bar progress-bar-green" style="width: 90%;"></div>
            </div>

            <div class="clearfix">
              <span class="pull-left">Task #2</span>
              <small class="pull-right">70%</small>
            </div>
            <div class="progress xs">
              <div class="progress-bar progress-bar-green" style="width: 70%;"></div>
            </div>
          </div>
          <!-- /.col -->
          <div class="col-sm-6">
            <div class="clearfix">
              <span class="pull-left">Task #3</span>
              <small class="pull-right">60%</small>
            </div>
            <div class="progress xs">
              <div class="progress-bar progress-bar-green" style="width: 60%;"></div>
            </div>

            <div class="clearfix">
              <span class="pull-left">Task #4</span>
              <small class="pull-right">40%</small>
            </div>
            <div class="progress xs">
              <div class="progress-bar progress-bar-green" style="width: 40%;"></div>
            </div>
          </div>
          <!-- /.col -->
        </div>
        <!-- /.row -->
      </div>
    </div>
    <!-- /.box -->
    '))

  # validateColor(color)
  # tagAssert(icon, type = "i")
  #
  # colorClass <- paste0("box-solid bg-", color, "-gradient")
  #
  # # calendar box
  # tags$div(
  #   class = "box", class = if (fill) colorClass,
  #   tags$div(
  #     class = "box-header",
  #     icon,
  #     h3(class = "box-title", title),
  #     HTML('<!-- tools box -->'),
  #     tags$div(
  #       class = "pull-right box-tools",
  #       HTML('<!-- button with a dropdown -->'),
  #       tags$div(
  #         class = "btn-group",
  #         tags$button(
  #           type = "button", class="btn btn-success btn-sm dropdown-toggle", `data-toggle`="dropdown",
  #           tags$i(
  #             class = shiny::icon("bars")
  #           )
  #         ),
  #         tags$ul(
  #           class="dropdown-menu pull-right", role="menu", lapply(menuList, tags$li)
  #         )
  #       ),
  #       tags$button(
  #         type="button", class="btn btn-success btn-sm", `data-widget`="collapse",
  #         shiny::icon("minus")
  #       ),
  #       tags$button(
  #         type="button", class="btn btn-success btn-sm", `data-widget`="remove",
  #         shiny::icon("times")
  #       )
  #     )
  #   ),
  #   tags$div(
  #     class="box-body no-padding",
  #     HTML('<!--The calendar -->'),
  #     tags$div(
  #       id="calendar", style="width: 100%"
  #     )
  #   )
  # )

}

# TODO: check why calendar won't show up, and implement calendarMenu() ...


#' Create a chat box for the main body of a dashboard.
#'
#' A \code{chatBox} displays \code{chatMessage}s as main box content, an optinal
#'   \code{contactList} on header, and an optional \code{newMessage} reminder on
#'   header. The \code{contactList} are created by \code{\link{chatContactList}}
#'   which in turn contains multiple \code{\link{chatContact}}s.
#'
#' @inheritParams box
#' @param ... For chat message, this should consist of \code{\link{chatMessage}}s.
#' @param .list An optional list containing messages to put in the chatBox same as
#'   the \code{...} arguments, but in list format. This can be useful when working
#'   with programmatically generated chatMessage.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @rdname chatBox
#' @export
chatBox <- function(..., textInputId, btnInputId, placeholder = "Type Message ...",
  title = "chatBox", status = "warning", solidHeader = FALSE, background = NULL, width = 6, height = NULL,
  admin = "Guang Yang", adminImg = paste0("ygdashboard", "-", as.character(utils::packageVersion("ygdashboard")), "/img/yg.jpg"),
  client = "Ex Machina", clientImg = paste0("ygdashboard", "-", as.character(utils::packageVersion("ygdashboard")), "/img/exmachina.jpg"),
  contactList = NULL, newMessage = NULL) {

  boxClass <- paste0("box direct-chat")

  if (solidHeader || !is.null(background)) {
    boxClass <- paste(boxClass, "box-solid")
  }
  if (!is.null(status)) {
    validateStatus(status)
    boxClass <- paste0(boxClass, " box-", status, " direct-chat-", status)
  }
  if (!is.null(background)) {
    validateColor(background)
    boxClass <- paste0(boxClass, " bg-", background)
  }

  # HTML(paste0(
  #   '
  #   <!-- DIRECT CHAT -->
  #   <div class="box box-warning direct-chat direct-chat-warning">
  #     <div class="box-header with-border">
  #       <h3 class="box-title">Direct Chat</h3>
  #
  #       <div class="box-tools pull-right">
  #         <span data-toggle="tooltip" title="3 New Messages" class="badge bg-yellow">3</span>
  #         <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
  #         </button>
  #         <button type="button" class="btn btn-box-tool" data-toggle="tooltip" title="Contacts" data-widget="chat-pane-toggle">
  #           <i class="fa fa-comments"></i></button>
  #         <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i>
  #         </button>
  #       </div>
  #     </div>
  #     <!-- /.box-header -->
  #     <div class="box-body">
  #       <!-- Conversations are loaded here -->
  #       <div class="direct-chat-messages">
  #         <!-- Message. Default to the left -->
  #         <div class="direct-chat-msg">
  #           <div class="direct-chat-info clearfix">
  #             <span class="direct-chat-name pull-left">Alexander Pierce</span>
  #             <span class="direct-chat-timestamp pull-right">23 Jan 2:00 pm</span>
  #           </div>
  #           <!-- /.direct-chat-info -->
  #           <img class="direct-chat-img" src="dist/img/user1-128x128.jpg" alt="message user image"><!-- /.direct-chat-img -->
  #           <div class="direct-chat-text">
  #             Is this template really for free? That"s unbelievable!
  #           </div>
  #           <!-- /.direct-chat-text -->
  #         </div>
  #         <!-- /.direct-chat-msg -->
  #
  #         <!-- Message to the right -->
  #         <div class="direct-chat-msg right">
  #           <div class="direct-chat-info clearfix">
  #             <span class="direct-chat-name pull-right">Sarah Bullock</span>
  #             <span class="direct-chat-timestamp pull-left">23 Jan 2:05 pm</span>
  #           </div>
  #           <!-- /.direct-chat-info -->
  #           <img class="direct-chat-img" src="dist/img/user3-128x128.jpg" alt="message user image"><!-- /.direct-chat-img -->
  #           <div class="direct-chat-text">
  #             You better believe it!
  #           </div>
  #           <!-- /.direct-chat-text -->
  #         </div>
  #         <!-- /.direct-chat-msg -->
  #
  #         <!-- Message. Default to the left -->
  #         <div class="direct-chat-msg">
  #           <div class="direct-chat-info clearfix">
  #             <span class="direct-chat-name pull-left">Alexander Pierce</span>
  #             <span class="direct-chat-timestamp pull-right">23 Jan 5:37 pm</span>
  #           </div>
  #           <!-- /.direct-chat-info -->
  #           <img class="direct-chat-img" src="dist/img/user1-128x128.jpg" alt="message user image"><!-- /.direct-chat-img -->
  #           <div class="direct-chat-text">
  #             Working with AdminLTE on a great new app! Wanna join?
  #           </div>
  #           <!-- /.direct-chat-text -->
  #         </div>
  #         <!-- /.direct-chat-msg -->
  #
  #         <!-- Message to the right -->
  #         <div class="direct-chat-msg right">
  #           <div class="direct-chat-info clearfix">
  #             <span class="direct-chat-name pull-right">Sarah Bullock</span>
  #             <span class="direct-chat-timestamp pull-left">23 Jan 6:10 pm</span>
  #           </div>
  #           <!-- /.direct-chat-info -->
  #           <img class="direct-chat-img" src="dist/img/user3-128x128.jpg" alt="message user image"><!-- /.direct-chat-img -->
  #           <div class="direct-chat-text">
  #             I would love to.
  #           </div>
  #           <!-- /.direct-chat-text -->
  #         </div>
  #         <!-- /.direct-chat-msg -->
  #
  #       </div>
  #       <!--/.direct-chat-messages-->
  #
  #       <!-- Contacts are loaded here -->
  #       <div class="direct-chat-contacts">
  #         <ul class="contacts-list">
  #           <li>
  #             <a href="#">
  #               <img class="contacts-list-img" src="dist/img/user1-128x128.jpg" alt="User Image">
  #
  #               <div class="contacts-list-info">
  #                     <span class="contacts-list-name">
  #                       Count Dracula
  #                       <small class="contacts-list-date pull-right">2/28/2015</small>
  #                     </span>
  #                 <span class="contacts-list-msg">How have you been? I was...</span>
  #               </div>
  #               <!-- /.contacts-list-info -->
  #             </a>
  #           </li>
  #           <!-- End Contact Item -->
  #           <li>
  #             <a href="#">
  #               <img class="contacts-list-img" src="dist/img/user7-128x128.jpg" alt="User Image">
  #
  #               <div class="contacts-list-info">
  #                     <span class="contacts-list-name">
  #                       Sarah Doe
  #                       <small class="contacts-list-date pull-right">2/23/2015</small>
  #                     </span>
  #                 <span class="contacts-list-msg">I will be waiting for...</span>
  #               </div>
  #               <!-- /.contacts-list-info -->
  #             </a>
  #           </li>
  #           <!-- End Contact Item -->
  #           <li>
  #             <a href="#">
  #               <img class="contacts-list-img" src="dist/img/user3-128x128.jpg" alt="User Image">
  #
  #               <div class="contacts-list-info">
  #                     <span class="contacts-list-name">
  #                       Nadia Jolie
  #                       <small class="contacts-list-date pull-right">2/20/2015</small>
  #                     </span>
  #                 <span class="contacts-list-msg">I"ll call you back at...</span>
  #               </div>
  #               <!-- /.contacts-list-info -->
  #             </a>
  #           </li>
  #           <!-- End Contact Item -->
  #           <li>
  #             <a href="#">
  #               <img class="contacts-list-img" src="dist/img/user5-128x128.jpg" alt="User Image">
  #
  #               <div class="contacts-list-info">
  #                     <span class="contacts-list-name">
  #                       Nora S. Vans
  #                       <small class="contacts-list-date pull-right">2/10/2015</small>
  #                     </span>
  #                 <span class="contacts-list-msg">Where is your new...</span>
  #               </div>
  #               <!-- /.contacts-list-info -->
  #             </a>
  #           </li>
  #           <!-- End Contact Item -->
  #           <li>
  #             <a href="#">
  #               <img class="contacts-list-img" src="dist/img/user6-128x128.jpg" alt="User Image">
  #
  #               <div class="contacts-list-info">
  #                     <span class="contacts-list-name">
  #                       John K.
  #                       <small class="contacts-list-date pull-right">1/27/2015</small>
  #                     </span>
  #                 <span class="contacts-list-msg">Can I take a look at...</span>
  #               </div>
  #               <!-- /.contacts-list-info -->
  #             </a>
  #           </li>
  #           <!-- End Contact Item -->
  #           <li>
  #             <a href="#">
  #               <img class="contacts-list-img" src="dist/img/user8-128x128.jpg" alt="User Image">
  #
  #               <div class="contacts-list-info">
  #                     <span class="contacts-list-name">
  #                       Kenneth M.
  #                       <small class="contacts-list-date pull-right">1/4/2015</small>
  #                     </span>
  #                 <span class="contacts-list-msg">Never mind I found...</span>
  #               </div>
  #               <!-- /.contacts-list-info -->
  #             </a>
  #           </li>
  #           <!-- End Contact Item -->
  #         </ul>
  #         <!-- /.contatcts-list -->
  #       </div>
  #       <!-- /.direct-chat-pane -->
  #     </div>
  #     <!-- /.box-body -->
  #     <div class="box-footer">
  #       <form action="#" method="post">
  #         <div class="input-group">
  #           <input type="text" name="message" placeholder="Type Message ..." class="form-control">
  #               <span class="input-group-btn">
  #                 <button type="button" class="btn btn-warning btn-flat">Send</button>
  #               </span>
  #         </div>
  #       </form>
  #     </div>
  #     <!-- /.box-footer-->
  #   </div>
  #   <!--/.direct-chat -->
  #   '))

  tags$div(
    class=boxClass,
    # <!-- /.box-header -->
    tags$div(
      class="box-header with-border",
      h3(class="box-title", title),
      tags$div(
        class="box-tools pull-right",
        if (!is.null(newMessage)) tags$span(`data-toggle`="tooltip", title=paste0(newMessage, "New Messages"), class="badge bg-yellow", newMessage),
        tags$button(
          type="button", class="btn btn-box-tool", `data-widget`="collapse", shiny::icon("minus")
        ),
        tags$button(
          type="button", class="btn btn-box-tool", `data-toggle`="tooltip", title="Contacts", `data-widget`="chat-pane-toggle", shiny::icon("comments")
        ),
        tags$button(
          type="button", class="btn btn-box-tool", `data-widget`="remove", shiny::icon("times")
        )
      )
    ),
    # <!-- /.box-body -->
    tags$div(
      class="box-body",
      # <!--/.direct-chat-messages-->
      tags$div(
        class="direct-chat-messages",
        ...
      ),
      # <!--/.direct-chat-contacts-->
      tags$div(
        class="direct-chat-contacts",
        contactList
      )
    ),
    # <!-- /.box-footer -->
    # create input as a shiny textInput ...
    tags$div(
      class="box-footer",
      tags$form(
        action="#", method="post"
      ),
      tags$div(
        class = "input-group form-group shiny-input-container", style="width:100%",
        # style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
        tags$input(
          id = textInputId, type="text", class="form-control", placeholder = placeholder),
        tags$span(
          class="input-group-btn",
          tags$button(
            id = btnInputId, class=paste0("btn btn-", status, " btn-flat action-button"), "Send"
          )
        )
      )
    )
  )

}

#' @rdname chatBox
#' @export
chatMessage <- function(name, image, text,
  position = c("left", "right"), timestamp = "Just Now") {

  position <- match.arg(position)

  tags$div(
    class=paste0("direct-chat-msg ", position),
    # <!-- message. position to the left/right -->
    tags$div(
      class="direct-chat-info clearfix",
      tags$span(
        class="direct-chat-name pull-left", name
      ),
      tags$span(
        class="direct-chat-timestamp pull-right", timestamp
      )
    ),
    tags$img(
      class="direct-chat-img", src=image, alt="message user image"
    ),
    tags$div(
      class="direct-chat-text",
      text
    )
  )

}


#' Create a dynamic chat message output for ygdashboard (client side)
#'
#' This can be used as a placeholder for dynamically-generated \code{\link{chatMessage}}.
#'
#' @param outputId Output variable name.
#'
#' @seealso \code{\link{renderChatMessage}} for the corresponding server side function
#'   and examples.
#' @family box outputs
#' @export
chatMessageOutput <- function(outputId) {
  moduleOutput(outputId, tag = tags$div)
}

#' Create dynamic chat message output (server side)
#'
#' @inheritParams shiny::renderUI
#'
#' @seealso \code{\link{chatMessageOutput}} for the corresponding client side function
#'   and examples.
#' @family box outputs
#' @export
renderChatMessage <- shiny::renderUI

#' Create a chat contact list for the chat box header.
#'
#' @param ... For chat contacts, this should consist of \code{\link{chatContact}}s.
#'
#' @rdname chatBox
#' @export
chatContactList <- function(..., .list = NULL) {

  items <- c(list(...), .list)

  tags$ul(
    class="contact-list",
    items
  )

}

#' @rdname chatBox
#' @export
chatContact <- function(name, image = NULL, date = "Just Now", text = NULL) {

  tags$li(
    tags$a(
      href="#",
      tags$img(
        class="contacts-list-img", src=image, alt="User Image"
      ),
      tags$div(
        class="contacts-list-info",
        tags$span(
          class="contacts-list-name", name,
          tags$small(class="contacts-list-date pull-right", date)
        ),
        tags$span(
          class="contacts-list-msg", text
        )
      )
    )
  )

}


#' Create a timeline box for the main body of a dashboard.
#'
#' A \code{timelineBox} displays \code{timelineLabel} and \code{timelineItem} as
#' main box content, often structures as an \code{timelineLabel} follows several
#' \code{timelineItem}s.
#'
#' @inheritParams box
#' @param ... For timeline items, this may consist of \code{\link{timelineLabel}}s
#'   and \code{\link{timelineItem}}s.
#' @param .list An optional list containing items to put in the timeline same as
#'   the \code{...} arguments, but in list format. This can be useful when working
#'   with programmatically generated items.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @rdname timelineBox
#' @export
timelineBox <- function(..., .list = NULL) {

  items <- c(list(...), .list)

  tags$div(
    style = 'overflow-x: scroll',
    style = 'overflow-y: scroll',
    tags$ul(
      class = "timeline",
      items
    )
  )

}

#' @rdname timelineBox
#' @export
timelineLabel <- function(text, color) {

  # timeline Label
  label <- tags$li(
    class = "timeline",
    tags$span(
      class = paste0("bg-", color),
      text
    )
  )

}

#' @rdname timelineBox
#' @export
timelineItem <- function(icon = shiny::icon("bars bg-blue"),
  header = NULL, body = NULL, footer = NULL,
  itemIcon = shiny::icon("clock-o"), itemText = "Just Now") {

  tags$li(
    icon,
    tags$div(
      class = "timeline-item",
      tags$span(
        class = "time", align = "right", itemIcon, itemText
      ),
      h3(
        class = "timeline-header", header
      ),
      tags$div(
        class = "timeline-body", body
      ),
      tags$div(
        class = "timeline-footer", footer
      )
    )
  )

}


#' Create a carousel box for the main body of a dashboard.
#'
#' A \code{carouseleBox} displays \code{carouselSets} and \code{carouselItem} as
#' main box content, often structures as an \code{carouselSets} follows several
#' \code{carouselItem}s.
#'
#' @inheritParams box
#' @param ... For carousel items, this may consist of \code{\link{carouselSets}}s,
#'   which in turn includes one or more \code{\link{carouselItem}}s.
#' @param .list An optional list containing items to put in the carousel same as
#'   the \code{...} arguments, but in list format. This can be useful when working
#'   with programmatically generated items.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @rdname carouselBox
#' @export
carouselBox <- box

#' @rdname carouselBox
#' @export
carouselSets <- function(..., id = NULL, class = NULL, itemStartWith = 1L, .list = NULL) {

  if (is.null(id)) id <- paste0("carousel-generic", "-", sample(1000L, 1L))

  items <- c(list(...), .list)

  n <- max(1L, length(items))

  if (itemStartWith > n) itemStartWith <- 1L

  if ( n == 1L ) {

    items[["attribs"]][["class"]] <- paste0(items[["attribs"]][["class"]], " active")

  } else {

    items[[itemStartWith]][["attribs"]][["class"]] <- paste0(items[[itemStartWith]][["attribs"]][["class"]], " active")

  }

  tags$div(

    id = id,

    class = "carousel slide",

    class = if (!is.null(class)) class,

    `data-ride`="carousel",

    eval(parse(text = paste0(
      'tags$ol(',
        'class = "nav carousel-indicators shiny-carousel-input shiny-bound-input",',
        paste0(
        'tags$li(',
          '`data-target`=paste0("#", id), `data-slide-to`="', c(1L:n) - 1L, '", ',
          'class="', ifelse(c(1L:n) == itemStartWith, "active", ""), '"',
        ')',
        collapse = ", "
        ),
      ")"
    ))),

    tags$div(

      class = "carousel-inner",

      items

    ),

    tags$a(

      class = "left carousel-control",

      href = paste0("#", id),

      `data-slide` = "prev",

      tags$span(

        class = "fa fa-angle-left"

      )

    ),

    tags$a(

      class = "right carousel-control",

      href = paste0("#", id),

      `data-slide` = "next",

      tags$span(

        class = "fa fa-angle-right"

      )

    )

  )

}

#' @rdname carouselBox
#' @export
carouselItem <- function(..., caption = NULL, .list = NULL) {

  items <- c(list(...), .list)

  tags$div(

    class = "item",

    items,

    if (!is.null(caption)) tags$div(class = "carousel-caption", caption)

  )

}
