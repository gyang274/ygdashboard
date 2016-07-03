# Add an html dependency, without overwriting existing ones
appendDependencies <- function(x, value) {
  if (inherits(value, "html_dependency"))
    value <- list(value)

  old <- attr(x, "html_dependencies", TRUE)

  htmlDependencies(x) <- c(old, value)
  x
}

# Add dashboard dependencies to a tag object
addDeps <- function(x) {
  if (getOption("shiny.minified", TRUE)) {
    adminLTE_js <- c("app.min.js"#,
                    # add js for showing menu icons when sidebar collapse
                    # "plugins/jQuery/jQuery-2.2.0.min.js",
                    # "bootstrap/js/bootstrap.min.js",
                    # "https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js",
                    # "plugins/morris/morris.min.js",
                    # "plugins/sparkline/jquery.sparkline.min.js",
                    # "plugins/jvectormap/jquery-jvectormap-1.2.2.min.js",
                    # "plugins/jvectormap/jquery-jvectormap-world-mill-en.js",
                    # "plugins/knob/jquery.knob.js", "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js",
                    # "plugins/daterangepicker/daterangepicker.js", "plugins/datepicker/bootstrap-datepicker.js",
                    # "plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js",
                    # "plugins/slimScroll/jquery.slimscroll.min.js",
                    # "plugins/fastclick/fastclick.js",
                    # "dist/js/app.min.js"
                    )
    adminLTE_css <- c("AdminLTE.min.css", "_all-skins.min.css")
  } else {
    adminLTE_js <- c("app.js"#,
                    # add js for showing menu icons when sidebar collapse
                    # "plugins/jQuery/jQuery-2.2.0.min.js",
                    # "bootstrap/js/bootstrap.min.js",
                    # "https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js",
                    # "plugins/morris/morris.min.js",
                    # "plugins/sparkline/jquery.sparkline.min.js",
                    # "plugins/jvectormap/jquery-jvectormap-1.2.2.min.js",
                    # "plugins/jvectormap/jquery-jvectormap-world-mill-en.js",
                    # "plugins/knob/jquery.knob.js", "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js",
                    # "plugins/daterangepicker/daterangepicker.js", "plugins/datepicker/bootstrap-datepicker.js",
                    # "plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js",
                    # "plugins/slimScroll/jquery.slimscroll.min.js",
                    # "plugins/fastclick/fastclick.js",
                    # "dist/js/app.min.js"
                    )
    adminLTE_css <- c("AdminLTE.css", "_all-skins.css")
  }

  dashboardDeps <- list(
    htmlDependency("AdminLTE", "2.0.6",
      c(file = system.file("AdminLTE", package = "ygdashboard")),
      script = adminLTE_js,
      stylesheet = adminLTE_css
    ),
    htmlDependency("shinydashboard",
      as.character(utils::packageVersion("ygdashboard")),
      c(file = system.file(package = "ygdashboard")),
      script = "shinydashboard.js",
      stylesheet = "shinydashboard.css"
    ),
    # create a html dependency pointing to file in inst/ygdashboard
    # -> add default fig such as user's profile figure in dashboard
    htmlDependency("ygdashboard",
      as.character(utils::packageVersion("ygdashboard")),
      c(file = system.file("ygdashboard", package = "ygdashboard"))
    )
  )

  appendDependencies(x, dashboardDeps)
}
