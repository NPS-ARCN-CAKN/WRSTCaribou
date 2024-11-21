#' GetDatabaseConnection()
#'
#' This function returns database connection
#' @return An odbc database connection object.
#' @examples
#' # Get a connection to the WRST_Caribou database
#' Connection = WRSTCaribou::GetDatabaseConnection(SqlServer,Database)
#' @export
#' @import odbc
#' @import DBI

GetDatabaseConnection <- function() {

  # Database parameters
  SqlServer = "inpyugamsvm01\\nuna"
  Database = "WRST_Caribou"

  # Load the ODBC library
  library(odbc)
  library(DBI)

  # Try to open a database connection to the database
  tryCatch({

    # Define the connection string
    ConnectionString = paste("Driver={SQL Server};Server=",SqlServer,";Database=",Database,";Trusted_Connection=Yes;",sep="")

    # Get a database connection
    Connection = dbConnect(odbc::odbc(), .connection_string = ConnectionString)

    # Return the database connection
    return(Connection)

  }, warning = function(w) {

    # Warning
    message("Warning: ", conditionMessage(w))
    return(NA)

  }, error = function(e) {

    # Error
    message("Error: ", conditionMessage(e))
    return(NA)

  })

}
