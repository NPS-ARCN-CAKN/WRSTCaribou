#' GetDatabaseConnection()
#'
#' This function returns an odbc database connection to the AK_ShallowLakes database. This function is mostly used internally by other functions in the NPSShallowLakes package, but you can use it as part of your own database queries.
#' @return An odbc database connection object.
#' @examples
#' # Get a connection to the WRST_Caribou database
#' Connection = GetDatabaseConnection()
#' # Execute the query into a data frame
#' data = odbc::dbGetQuery(Connection,'SELECT Top 3 * FROM Surveys')
#' head(data)
#' @export
GetDatabaseConnection <- function() {

  # Load the ODBC library
  library(odbc)

  # Try to open a database connection to the AK_ShallowLakes database
  Connection <- tryCatch({

    # Get a database connection
    dbConnect(odbc(),Driver = "Sql Server",Server = "inpyugamsvm01\\nuna",Database = "WRST_Caribou")

  }, warning = function(w) {

    # Warning
    message("Warning: ", conditionMessage(w))
    return(NA)

  }, error = function(e) {

    # Error
    message("Error: ", conditionMessage(e))
    return(NA)

  }, finally = {

    # Finally
    # message("Cleanup, if needed")

  })

  return(Connection)
}
