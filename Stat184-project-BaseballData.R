#read HTML (https://www.espn.com/mlb/war/leaders)
#HTML elements CSS
#html_table
library(rvest)
library(dplyr)
library(ggplot2)
library(png)
library(grid)
library(ggrepel)
library(ggforce)
#Open Data through HTML
Baseball_data <- read_html("https://www.espn.com/mlb/war/leaders")
#Open table of data 
table_data <- Baseball_data %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)
#Get to table
table1 <- table_data[[1]]

#-------------------------------------------------------------------------------

#Clean the data
CleanBaseballData <- table1 %>%
  slice(-1, -2)

head(CleanBaseballData)
names(CleanBaseballData) 
colnames(CleanBaseballData) <- c("Rank", "Player", "War", "ORTG", "DRTG", "WAA", "TRPG", "ORPG", "RAA", "WAAWP")
CleanBaseballData$Player <- c("A. Judge",
                              "B. Witt Jr", 
                              "S. Ohtani", 
                              "G. Henderson", 
                              "J. Duran", 
                              "J. Soto", 
                              "M. Chapman",
                              "F. Lindor", 
                              "J. Ramirez", 
                              "K. Marte", 
                              "T. Skubal",
                              "H. Greene", 
                              "C. Sale", 
                              "V. Guerrero Jr", 
                              "Z. Wheeler",
                              "P. Skenes", 
                              "E. Fedde", 
                              "B. Rooker", 
                              "R. Greene",
                              "Y. Alvarez", 
                              "S. Lugo", 
                              "E. De La Cruz", 
                              "Z. Neto",
                              "R. Lopez", 
                              "D. Varsho", 
                              "C. Seager", 
                              "C. Ragans",
                              "M. Winn", 
                              "W. Contreras", 
                              "B. Harper", 
                              "M. Betts", 
                              "K. Tucker", 
                              "F. Freeman", 
                              "C. Raleigh",
                              "B. Turang", 
                              "F. Valdez", 
                              "E. Clase", 
                              "R. Blanco",
                              "J. Merrill", 
                              "M. Ozuna", 
                              "J. Rodriguez", 
                              "T. Hernandez",
                              "D. Cease", 
                              "G. Crochet", 
                              "A. Bregman", 
                              "M. Semien",
                              "M. King", 
                              "J. Pena", 
                              "B. Doyle", 
                              "A. Gimenez"
)
str(CleanBaseballData)

#Add player pictures
CleanBaseballData$img_path <- c(
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/33192.png", #Judge
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/42403.png", #Witt Jr
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/39832.png", #Ohtani
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/42507.png", #Henderson
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41610.png", #Duran
  "https://content.mlb.com/images/headshots/current/60x60/665742@3x.png", #Soto
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/33857.png", #Chapman
  "https://content.mlb.com/images/headshots/current/60x60/596019@3x.png", #Lindor
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/32801.png&w=350&h=254", #Ramirez
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/32512.png", #Marte
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/42409.png", #Skubal
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/39635.png", #H. Greene
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/30948.png", #Sale
  "https://a.espncdn.com/i/headshots/mlb/players/full/35002.png", #Vlad Jr
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/31267.png", #Wheeler
  "https://a.espncdn.com/i/headshots/mlb/players/full/4719507.png", #Skenes
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/33793.png", #Fedde
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/40926.png", #Rooker
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/42179.png", #R. Greene
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/36018.png", #Alvarez
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/34873.png", #Lugo
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/4917694.png", #De La Cruz
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/4666100.png", #Neto
  "https://a.espncdn.com/i/headshots/mlb/players/full/33860.png", #Lopez
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/40963.png", #Varsho
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/32691.png", #Seager
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41054.png&w=350&h=254", #Ragans
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/4683365.png", #Winn
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/39895.png", #Contreras
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/30951.png", #Harper
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/33039.png", #Betts
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/34967.png", #Tucker
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/30193.png", #Freeman
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41292.png&w=350&h=254", #Raleigh
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41179.png", #Turang
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/36581.png", #Valdez
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41743.png", #Clase
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41829.png", #Banco
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/4872691.png", #Merrill
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/31668.png", #Ozuna
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41044.png", #Rodriguez
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/33377.png", #Hernandez
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/34943.png", #Cease
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/4297835.png", #Crochet
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/34886.png&w=350&h=254", #Bregman
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/32146.png", #Semien
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/40429.png", #King
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/41273.png", #Pena
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/42462.png", #Doyle
  "https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/37729.png" #Gimenez
  )
class(CleanBaseballData$DRTG)
CleanBaseballData$DRTG <- as.numeric(CleanBaseballData$DRTG)
CleanBaseballData$ORTG <- as.numeric(CleanBaseballData$ORTG)


#-------------------------------------------------------------------------------

#Plotting
readPNGfromURL <- function(url) {
  temp <- tempfile()
  download.file(url, temp, mode = "wb")
  img <- readPNG(temp)
  unlink(temp)
  return(img)
}

ggplot(data = CleanBaseballData, 
       mapping = aes(ORTG, DRTG)) + 
  geom_point() + 
  geom_text_repel(aes(label = Player), 
            box.padding = 0.35, 
            max.overlaps = 50) + 
  labs(title = "Relationship between ORTG and DRTG", 
       x = "Defensive Rating", 
       y = "Offensive Rating")

##Create the Plot
p <- ggplot(data = CleanBaseballData, 
            mapping = aes(ORTG, DRTG)) + 
  geom_point() + 
  geom_text(aes(label = Player), vjust = 1.5, hjust = 0.5) + 
  labs(title = "Relationship between ORTG and DRTG", 
       x = "Defensive Rating", 
       y = "Offensive Rating")

#Add the images to the players 
for (i in 1:nrow(CleanBaseballData)) {
  img <- readPNGfromURL(CleanBaseballData$img_path[i])
  
  p <- p + annotation_raster(
    img, 
    xmin = CleanBaseballData$DRTG[i] - 0.5, xmax = CleanBaseballData$DRTG[i] + 0.5, 
    ymin = CleanBaseballData$ORTG[i] - 0.5, ymax = CleanBaseballData$ORTG[i] + 0.5
  )
}

print(p)
