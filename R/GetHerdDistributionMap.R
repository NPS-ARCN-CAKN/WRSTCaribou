#' GetHerdDistributionMap()
#'
#' Returns a map of animal sightings during a survey.
#' @return Plot
#' @examples
#' # Get a plot of the '2024-06-26 Mentasta Caribou Population Survey'
#'
#' # Execute the query into a data frame
#' GetHerdDistributionMap('2024-06-26 Mentasta Caribou Population Survey')
#' @export
GetHerdDistributionMap = function(SurveyName){

  # Load libraries
  library(odbc)
  library(sf)
  library(tidyverse)

  # Get a database connection
  Connection = GetDatabaseConnection()

  # Sql to retrieve the caribou groups coordinates from the database
  Sql = paste("SELECT SurveyName, Year, Herd, SurveyType, SearchArea, GroupNumber, SightingDate, Lat, Lon
  , [In], Seen, Marked,Park
FROM CaribouGroups
WHERE SurveyName='",SurveyName,"' And Lat > 0",sep="")

  # Execute the query into a data frame
  data = dbGetQuery(Connection,Sql)

  # Get the Park
  Park = data[1,'Park']

  # Convert the data into a spatial data frame
  spdata <- sf::st_as_sf(data %>% filter(Park==Park), coords = c('Lon','Lat'))

  # Set the coordinate system to GCS Lat\Lon WGS1984
  st_crs(spdata) <- st_crs(4326)

  # Park boundaries (geojson) are at https://irma.nps.gov/DataStore/Reference/Profile/2303652
  # Create a temporary file on user's hard drive
  tmp_geojson <- tempfile(fileext = ".geojson")

  # Download the spatial data file to the temporary file location created above
  download.file("https://irma.nps.gov/DataStore/DownloadFile/702822",tmp_geojson)

  # Read the temporary spatial data file into an sf object
  AKParks = read_sf(tmp_geojson)

  # Get a bounding box of just the park for which the survey was done
  bbox = st_bbox(AKParks %>% filter(PARK==tolower(Park)))

  # Plot the caribou groups over a map of the park
  Plot = ggplot() +

    # Park boundary
    geom_sf(data = AKParks,fill = "ghostwhite", color = "black") +

    # Caribou kernel density
    geom_density_2d(data = data, aes(x = Lon, y = Lat), colour = "red", alpha = 0.9) +
    xlim(min(data$Lon) - 1, max(data$Lon) + 1) +
    ylim(min(data$Lat) - 1, max(data$Lat) + 1) +

    # Caribou observations
    geom_sf(data = spdata, aes(color=factor(Marked)), size= 1, show.legend = T) +
    scale_color_manual(values = c("black","darkgray"))  +
    guides(color=guide_legend(title="Marked (1=True,0=False)")) +

    # Limit the view port to just the park. bbox created above the ggplot call
    coord_sf(
      xlim = c(bbox["xmin"], bbox["xmax"]),
      ylim = c(bbox["ymin"], bbox["ymax"])
    ) +

    # Label axes
    xlab('Longitude') + ylab('Latitude') +

    # Title
    # ggtitle('Caribou distribution') +

    # Clean look
    theme_classic() +

    # Background colors
    theme( panel.background = element_rect(fill = "lightsteelblue1", color = "black")) +

    # Vertical x axis labels
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

  return(Plot)

}
