<!-- README.md is generated from README.Rmd. -->
ygdashboard
-----------

A modified shinydashboard to incorporate more functionality from adminLTE:

-   A modified dashboardPage.R, a modified dashboardBody.R and deps.R to allow showing menu icons when sidebar collapse.

    -   Add AdminLTE/bootstrap, AdminLTE/dist and AdminLTE/plugin to inst/AdminLTE/bootstrap, inst/AdminLTE/dist and inst/AdminLTE/plugin.

    -   Enhance `tags$body(class = paste0("skin-", skin), ...)` to `tags$body(class = paste0("hold-transition skin-", skin, " sidebar-mini"), ...)` in dashboardPage.R.

    -   ~~Add JS in `htmlDependency("AdminLTE", "2.0.6", ..., scripts = c(adminLTE_js, ...))` in `addDeps` in deps.R~~

    -   ~~Add JS at the end of `tags$body(...)` in dashboardPage.R - manual refer to JS with name, version and src derived from `addDeps()` in deps.R, not perfect (TODO - replace `ygdashboard-0.5.1.9000` by `system.file("AdminLTE", package = "ygdashboard")`).~~

    -   These together allow showing menu icons when sidebar collapse.

-   A modified infoBox: allow filled infoBox (Type2 infoBox) to have progress report.

-   A modified dashboardPage.R, a modified dashboardHeader.R and a new dashboardControlbar.R: show control panel on top right of header panel.

    -   Add component controlbar in argument list and in `content <- div(class = "wrapper", header, sidebar, body, controlbar)` in dashboardPage.R

    -   Add `HTML('<li><a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a></li>')` in `tags$header(class = "main-header", ..., div(class = "navbar-custom-menu", tags$ul(class = "nav navbar-nav", items, ...)))` in dashboardHeader.R to show controlbar button toggle on/off controlbar.

    -   Add dashboardControlbar.R to implement control-sidebar.

-   A modified dashboardPage.R, a modified dashboardHeader.R and a new dashboardUser.R: show user account info panel on top right of header panel.

    -   Add component user in argument list and in `tags$header(class = "main-header", ..., div(class = "navbar-custom-menu", tags$ul(class = "nav navbar-nav", items, ...)))` in dashboardHeader.R to show user account inf panel on top right of header panel.

    -   Add dashboardUser.R to implement user account infomation.

    -   Add `htmlDependency("ygdashboard", ...)` in `addDeps()` in deps.R pointing to inst/ygdashboard - so default user profile figure in inst/ygdashboard can be used when shiny rendering html.

-   A modified shinydashboard.js, a new moduleOutput.R and a modified `tagAssert()` in utils.R to allow dynamically generating ygdashboard modules such as `dashboardUser()`, `dashboardFooter()`.

    -   Add `var moduleOutputBinding =new Shiny.OutputBinding(); ...` to replace and find `class=ygdashboard-module-output` in `shinydashboard.js`. This is a mimic of `var menuOutputBinding = new Shiny.OutputBinding(); ...` and allows run time dynamically generate modules on server side to be binded into client side module place holders. The `class="ygdashboard-module-output"` is used in shinydashboard.js as an id for replacing the origin DOM element with the new DOM elements copying over the ID and class.

    -   Add class `ygdashboard-module-output` as skipped elements in `tagAssert()` in utils.R:

    <!-- -->

        if (allowUI &&
            (hasCssClass(tag, "shiny-html-output") ||
             hasCssClass(tag, "shinydashboard-menu-output") ||
             hasCssClass(tag, "ygdashboard-module-output"))) {
          return()
        }

    -   Add `moduleOutput()` in moduleOutput.R as a method of creating a dynamic module output place holder on client side, use in context with `shiny::renderUI({})`. This is a mimic of `menuOutput()`. And similar as in menuOutput, it is recommended to use the wrapper function such as `userOutput()` and `footerOutput()`, instead of calling `moduleOutput()` directly.
-   A modified dashboardUser.R and a modified shinydashboard.js: create user dynamically from server side and render user reponsively on client side by taking input from URL - should be login from database when deployed.

    -   Add a modified `dashboardUser()` in dashboardUser.R to create userInfo as shiny html context - tagList.

    -   Add `userOutput()` in dashboardUser.R as client-side place holder, use in context with server-side dynamically generated `renderUser({ dashboardUser() })`.

-   A modified `sidebarUserPanel()` in dashboardSidebar.R to add user account info panel on sidebar with Online, Away, and Offline stauts:

    -   Add argument `status` in `sidebarUserPanel()`.

    -   Add `sidebarUserPanelOutput()` in menuOutput.R as client-side place holder, use in context with server-side dynamically generated `renderMenu({ sidebarUserPanel() })`.

    -   Add `style="background-color:transparent;"` in `div(class = "user-panel", ..., div(class = "pull-left info", ...))` in `sidebarUserPanel()` - in case otherwise when work with leaflet package, background is overwritten by leafletfix.css:8.

-   A modified dashboardSidebar.R:

    -   Add `menuSegment()` in context of `sidebarMenu()` in dashboardSidebar.R by `<li class="header">MAIN NAVIGATION</li>`.

    -   Add `menuSegmentOutput()` in menuOutput.R as client-side place holder, use in context with server-side dynamically generated `renderMenu({ menuSegment() })`.

-   A modified dashboardPage.R and a new dashboardFooter.R: add `footer` in body `content-wrapper`.

    -   Add a new `dashboardFooter()` to create dashboardFooter in dashboardFooter.R.

    -   Add a new `footerOutput()` in dashboardFooter.R as client-side place holder, use in context with server-side dynamically generated `renderFooter({ dashboardFooter() })`.

    -   Add an argument `footer` in `dashboardPage()` in dashboardPage.R.

-   Add `chatBox()` in boxes.R: show chats and potential use for commnunicating with clients.

    -   Add `chatBox()` together with components `chatMessage()`, `chatContactList()` and `chatContact()` in boxes.R

    -   Add `chatMessageOutput()` and `renderChatMessage()` for generating chatMessage dynamically on server-side and rendering on client-side.

-   Add `calendarBox()` in boxes.R: show calendar and task progress.

    -   TODO: check the reason calendar won't show in shiny?
-   Add `timelineBox()`, `timelineLabel()` and `timelineItem()` in boxes.R: show timeline of development and etc.

    -   TODO: Add `timelineOutput()` and `renderTimeline()` for generating timelineBox dynamically on server-side and rendering on client-side?

TODO:
-----

-   dashboardControlbar.R: create functions that can create sub-components in control-sidebar, like functions defined in dashboardSidebar.R

-   create more valid `status` in `box()` - so more header color such as oragne, dark-blue, purple - or, add an argument color that takes valid color as input and overwrite status.
