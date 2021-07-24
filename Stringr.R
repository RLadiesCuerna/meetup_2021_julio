#Trabajando con pipes y stringr
#Organiza: R-Ladies Cuernavaca
#Ponentes: Mary Jane Rivero Morales y Veronica Jimenez Jacinto
#Fecha: Lunes, 26 de julio de 2021

#----Instalación de paquetes----
# install.packages("tidyverse")
library(tidyverse)

#---- Comillas simples o dobles ----
Cadena1 <- "Cadena de caracteres"
Cadena2 <-'Cuando llegué ella estaba con las maletas.
"Me voy" me dijo'

#----Primeros pasos con stringr----
#NOTA: Paquete stringr: las funciones empiezan por str_
#Creamos un vector llamado frutas
frutas <- c("manzana","pera","fresa","banano") 
#str_length(): # de caracteres de una cadena
str_length(frutas)
#str_to_upper(): caracteres en mayuscula
str_to_upper(frutas)
#str_to_title():primer caracter mayuscula y otros minuscula
str_to_title(frutas)
#str_to_lower(): caracteres en minuscula
str_to_lower(frutas)
#str_sub(): Para extraer partes de una cadena.
str_sub(frutas,1,3)
#str_replace
str_replace(frutas,"pera","mango")
#Ordenar alfabeticamente
str_sort(frutas, locale = "es")

#----Ejemplo base de datos----
#Lectura de datos
datos <- read.csv("netflix_titles.csv")
#Tienes observaciones faltantes
datos <- read.csv("netflix_titles.csv", na.strings = "")
#Contando los NA
table(is.na(datos))
#Eliminamos las filas que tengan NA
datos <- datos[stats::complete.cases(datos),]
#Numero de caracteres de la variable country
datos$caracteres<- str_length(datos$country)
#Escribir en mayuscula
datos$type <- str_to_upper(datos$type)
#Escribir como titulo 
datos$type <- str_to_title(datos$type)
#Combinar las funciones str_sub y str_to_upper
datos$Inicial <- str_to_upper(str_sub(datos$type, 1, 1))
#str_replace
datos$type <- str_replace(datos$type,"TV Show","Show")
#ordenar alfabeticamente
datos$date_added <- str_sort(datos$date_added, locale = "es")

#---- Segunda parte primeros pasos ----
#Uso de la funcion str_detect(): sirve Para determinar si un vector
#de caracteres coincide con un patron de busqueda
str_detect(frutas ,"a")
str_detect(frutas ,"r")

#---- Ejemplo base de datos ----
#Pipe ctrl+shif+m
#Filtrar las peliculas mexicanas
minidatos <- datos%>% 
  filter(str_detect(datos$country,"Mexico"))
View(minidatos)

#Peliculas que se grabaron unicamente en Mexico
#^ palabras comunes que empiezan por m
#$ palabras comunes que terminan en o 
minidatos <- datos%>% 
  filter(str_detect(datos$country,"^Mexico$"))
View(minidatos)

#Filtrado mas amplio
minidatos_paises <- datos%>% 
  filter(str_detect(datos$country,c("^Mexico$","^Brazil$","^United States$",
                                    "^India$", "^Italy$", "^Germany$","^Russia$","^Japon$",
                                    "^Canada$","^Turkey$","^Egypt$", "^France$","^South Korea$",
                                    "^United Kingdom$", "^Spain$")) &  type == "Movie")

#Observando la estructura de los datos
str(minidatos_paises)
#Convertir la variable de la base de datos a factor
minidatos_paises$country <- factor(minidatos_paises$country)
#Observar los niveles de la variable pais
levels(minidatos_paises$country)

#Contar observaciones por pais
minidatos_paises %>% count(country) 

#---- Graficando los datos----
ggplot(minidatos_paises, aes(country,fill=country))+
  geom_bar()+
  labs(title="Peliculas por pais", x= "Paises",y="Numero de peliculas")+
  theme_minimal()

#Plotly  
library(plotly)
ggplotly(ggplot(minidatos_paises, aes(country,fill=country))+
           geom_bar()+
           labs(title="Peliculas por pais", x= "Paises",y="Numero de peliculas")+
           theme_minimal())


#Uso de la funcion str_c(): combinemos cadenas
descripcion<-minidatos_paises$description
View(minidatos_paises)
intro<- "The movie is about"

hola<-str_c(
  intro," ", descripcion
)
hola

minidatos_paises$columnaNueva <- str_c(minidatos_paises$country,
                          minidatos_paises$release_year, sep=" ")
#Fuente: R para ciencia de datos de Hadley Wickham y Garrett Grolemund



