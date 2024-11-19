#' GetCensusSurveySummary()
#'
#' Summarizes the animal counts and related information regarding the survey titled SurveyName.
#' @return Data frame.
#' @examples
#' # Summarize the survey titled '2024-06-26 Mentasta Caribou Population Survey'
#'
#' # Execute the query into a data frame
#' data = GetCensusSurveySummary('2024-06-26 Mentasta Caribou Population Survey')
#' head(data)
#' @export
GetCensusSurveySummary = function(SurveyName){

  Connection = GetDatabaseConnection()


  Sql = paste("SELECT [Survey name], Herd, [Survey type], [Type of survey], Timing, Cow, Calf, [Small bull], [Medium bull], [Large bull], Bull, BullsWereCategorized, Adult, Caribou, Unknown, [Calf, male], [Calf, female], [Calf, unclassified], Yearling,
 GroupSize_Mean, [Minimum group size], [Maximum group size], [Pct. calf], [Pct. cow], [Pct. small bull], [Pct. medium bull], [Pct. large bull], [Pct. small bull (of total bulls)], [Pct. medium bull (of total bulls)],
 [Pct. large bull (of total bulls)], [Pct. bull (composition survey)], [Pct. bull (population survey)], [Calves/100 cows], [Bulls/100 cows], [Total groups observed], Marked, Seen, [Marked and Seen], [Marked and Not Seen],
 [Pct. marked groups observed], [Groups in the survey area], [Groups out of the survey area], [Marked groups in survey area], [Marked groups observed in survey area], [Observed groups in survey area],
 [Pct. marked groups observed in survey area], [Total collared animals observed], [Number of frequencies that were available on survey date (Animal_Movement)], [Collars not heard or not searched], [Start date], [End date],
 [Survey days], [Search areas], Park, Year, CertificationLevel, DateValidated, ValidatedBy
FROM  Summary_Census
WHERE [Survey name] = '",SurveyName,"'",sep="")

  return(dbGetQuery(Connection,Sql))



}
