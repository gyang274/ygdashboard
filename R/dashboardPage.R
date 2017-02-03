#' yg dashboard page
#'
#' This creates a dashboard page for use in a Shiny app.
#'
#' @param header A header created by \code{dashboardHeader}.
#' @param sidebar A sidebar created by \code{dashboardSidebar}.
#' @param body A body created by \code{dashboardBody}.
#' @param footer A footer created by \code{dashboardFooter}.
#' @param controlbar A controlbar created by \code{dashboardControlbar}.
#' @param title A title to display in the browser's title bar. If no value is
#'   provided, it will try to extract the title from the \code{dashboardHeader}.
#' @param skin A color theme. One of \code{"blue"}, \code{"black"},
#'   \code{"purple"}, \code{"green"}, \code{"red"}, or \code{"yellow"}.
#'
#' @seealso \code{\link{dashboardHeader}}, \code{\link{dashboardSidebar}},
#'   \code{\link{dashboardBody}}.
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' # Basic dashboard page template
#' library(shiny)
#' shinyApp(
#'   ui = dashboardPage(
#'     header = dashboardHeader(),
#'     sidebar = dashboardSidebar(),
#'     body = dashboardBody(),
#'     footer = dashboardFooter(),
#'     controlbar = dashboardControlbar(),
#'     title = "Dashboard example"
#'   ),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardPage <- function(header, sidebar, body, footer, controlbar, title = NULL,
                          skin = c("blue", "blue-light","black","black-light", "purple","purple-light", "green","green-light",
                                   "red","red-light", "yellow","yellow-light")) {

  tagAssert(header, type = "header", class = "main-header")
  tagAssert(sidebar, type = "aside", class = "main-sidebar")
  tagAssert(body, type = "div", class = "content-wrapper")
  # tagAssert(footer, type = "footer", class = "main-footer")
  # tagAssert(controlbar, type = "aside", class = "control-sidebar")
  skin <- match.arg(skin)

  extractTitle <- function(header) {
    x <- header$children[[1]]
    if (x$name == "span" &&
        !is.null(x$attribs$class) &&
        x$attribs$class == "logo" &&
        length(x$children) != 0)
    {
      x$children[[1]]
    } else {
      ""
    }
  }

  title <- title %OR% extractTitle(header)

  content <- div(class = "wrapper",
                 header, sidebar, body, footer, controlbar)

  addDeps(

    tags$body(
      class = paste0("hold-transition skin-", skin, " sidebar-mini"),
      style = "min-height: 611px;",
      shiny::bootstrapPage(content, title = title)#,
      # add adminLTE scripts at the end of body
      # HTML('<!-- jQuery 2.2.0 -->
      #       <script src="AdminLTE-2.0.6/plugins/jQuery/jQuery-2.2.0.min.js"></script>
      #       <!-- jQuery UI 1.11.4 -->
      #       <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
      #       <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
      #       <script>
      #       $.widget.bridge("uibutton", $.ui.button);
      #       </script>
      #       <!-- Bootstrap 3.3.6 -->
      #       <script src="AdminLTE-2.0.6/bootstrap/js/bootstrap.min.js"></script>
      #       <!-- Morris.js charts -->
      #       <script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
      #       <script src="AdminLTE-2.0.6/plugins/morris/morris.min.js"></script>
      #       <!-- Sparkline -->
      #       <script src="AdminLTE-2.0.6/plugins/sparkline/jquery.sparkline.min.js"></script>
      #       <!-- jvectormap -->
      #       <script src="AdminLTE-2.0.6/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
      #       <script src="AdminLTE-2.0.6/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
      #       <!-- jQuery Knob Chart -->
      #       <script src="AdminLTE-2.0.6/plugins/knob/jquery.knob.js"></script>
      #       <!-- daterangepicker -->
      #       <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
      #       <script src="AdminLTE-2.0.6/plugins/daterangepicker/daterangepicker.js"></script>
      #       <!-- datepicker -->
      #       <script src="AdminLTE-2.0.6/plugins/datepicker/bootstrap-datepicker.js"></script>
      #       <!-- Bootstrap WYSIHTML5 -->
      #       <script src="AdminLTE-2.0.6/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
      #       <!-- Slimscroll -->
      #       <script src="AdminLTE-2.0.6/plugins/slimScroll/jquery.slimscroll.min.js"></script>
      #       <!-- FastClick -->
      #       <script src="AdminLTE-2.0.6/plugins/fastclick/fastclick.js"></script>
      #       <!-- AdminLTE App -->
      #       <script src="AdminLTE-2.0.6/dist/js/app.min.js"></script>
      #       <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
      #       <!-- <script src="dist/js/pages/dashboard.js"></script> -->
      #       <!-- AdminLTE for demo purposes -->
      #       <!-- <script src="dist/js/demo.js"></script> -->
      #      ')
    )
  )
}
