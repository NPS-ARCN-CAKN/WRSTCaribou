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
#' @import odbc
#' @import DBI

GetDatabaseConnection <- function(SqlServer,Database) {

  # Load the ODBC library
  library(odbc)
  library(DBI)

  # Try to open a database connection to the AK_ShallowLakes database
  Connection <- tryCatch({

    # Get a database connection
    #dbConnect(odbc(),Driver = "Sql Server",Server = "inpyugamsvm01\\nuna",Database = "WRST_Caribou")

    # Define the connection string
    ConnectionString = paste("Driver={SQL Server};Server=",SqlServer,";Database=",Database,";Trusted_Connection=Yes;",sep="")
    Connection = dbConnect(odbc::odbc(), .connection_string = ConnectionString)
    return(Connection)

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
