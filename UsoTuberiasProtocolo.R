###################################
# Uso de Pipes
####################
## Objetivos
#############


#- Hacer una revisión del modelo de herramientas para realizar análisis de datos. 
#- Introducir el concepto de pipe como un estilo de programación.
#################
## Indice


# * Introducción
#   - Modelo de Herramientas necesarias
#   - Paquetes de Tidyverse

# * Uso de pipes
#   - alternativas para el uso de pipes
#   - cuando no usar pipes
#   - otros operadores de magrittr 

######################  
### Modelo de Herramientas necesarias


#La ciencia de datos es una disciplina emocionante que  permite convertir los datos sin procesar en conocimiento. 

# "La exploración de los datos es el arte de mirar en tus datos, generar hipotesis, probar o desechar dichas hipotesis y volver a repetir..."

#Fuente: http://r4ds.had.co.nz/introduction.html 

############################
## El paquete Tydiverse

## Prerequisitos

#* Primero debemos tener instalado el tidyverse:

install.packages('tidyverse')
library(tidyverse)

### Data:  msleep_ggplot2.csv

# A partir de este punto, trabajaremos con esta tabla que contiene los tiempos de sueño y peso de un conjunto de 83 mamíferos, descritos con las siguientes 11 columnas

# * name:    Nombre común

# * genus:   rango taxonomico

# * vore:    tipo de alimentación. ¿carnivore, omnivore or herbivore?

# * order:    rango taxonomico

# * conservation:    el estatus de conservacion del mamífero

# * sleep_total:    timepo total de sueño, en horas

# * sleep_rem:    tiempo total de rem. En horas (rem=rapid eye movement)

# * sleep_cycle:    Longitud de los ciclos de sueño, en horas

# * awake:    tiempo total, despierto, en horas

# * brainwt:    Peso del cerebro en kilogramos

# * bodywt:    Peso del cuerpo en kilogramos

# Leemos la tabla en formato csv

msleep <- read.csv("Data/msleep_ggplot2.csv")
head(msleep)
# convierte el dataframe a tibble
tmsleep<-as_tibble(msleep)


## ¿Qué es dplyr?

#El paquete dplyr es un poderoso paquete de R que proporciona un conjunto de funciones (o verbos) útiles para manejar y resumir datos tabulare (sujetos), como dataframes, de una manera fácil.

#Existen 5 funciones claves para transformar datos con dplyr que permiten resolver la mayoría de los retos en el proceso de manipulación de datos:

# * Elegir las observaciones por sus valores (filter())


# * Reordenar los renglones (arrange())


# * Elegir las variables por sus nombres (select())


# * Crear nuevas variables con funciones sobre las variables existentes (mutate())

# * Colapsar muchos valores en un resumen de los mismos (summarise())

# Estas funciones pueden ser usadas en conjunción con group_by()  la cual cambia el ámbito de cada función para operar sobre el conjunto completo de datos u operando solo grupo por grupo. 


# dplyr, como el resto de los paquetes de tidyverse, puede ser vista como una gramática de manipulación de datos, donde cada función es un verbo y cada verbo trabaja de manera similar:

# 1. El primer argumento es el nombre del data.frame o tibbies

# 2. Los siguiente argumentos describen que se hace con el data.frame, o tibble o tabla usando los nombres de variables.

# 3. El resultado es un nuevo data.frame o tibbies

filter(tmsleep,vore == 'carni')

## Uso de pipes

# La fortaleza de tydiverse consiste en combinar funciones usando pipes ( %> % ). 

# Las tuberías %>%  vienen en el paquete <b>magrittr</b>, pero cuando cargas el paquete tidyverse se carga automáticamente %>%, sino fuera el caso, puedes hacer explícitamente:

library(tidyverse)
# ó
library(magrittr)


# Por ejemplo:

# 1. Tome la tabla msleep
# 2. Selecciona el nombre y el peso del cerebro y del cuerpo
# 3. Aplique un head para ver el resultado.

msleep %>% select(name,brainwt,bodywt) %>% head


# El concepto de pipe (tuberías) es el mismo que en Unix. En este caso %> % representa el pipe, el cual indica que queremos usar el comando de la izquierda como entrada al comando de la derecha del pipe.

# Veamos otro ejemplo, si queremos obtener sólo los
# nombres de las especies domesticadas utilizaremos filter y select:

msleep %>% filter(conservation=="domesticated") %>% select(name) %>% head

# Ahora, imagínate que quieres explorar la relación entre el tiempo del sueño, rem  y tipo de alimentación, pero filtrando grupos de menos de 20 individuos.

# Hay 3 pasos para preparar estos datos:

# 1. Agrupar por una variable de interés

# 2. Sumarizar los cálculos  de otras variables de interés

# 3. Filtrar para remover los puntos de ruido. 

# 1
vore<-group_by(msleep,vore)
# 2
mean_sleep_vore<-
summarize(vore,count=n(),mean(sleep_total),mean(sleep_rem,na.rm=TRUE))
# 3
(mean_sleep_vore<-filter(mean_sleep_vore, count>=20))


# Esto puede resultar un poco frustrante porque escribimos datos intermedios para poder continuar a través de nuestro análisis.

# Cuando abordamos el mismo problema con tubería (pipes), nos ahorramos los resultados intermedios:

(mean_sleep_vore<-msleep %>% 
                 group_by(vore) %>%
                 summarize(
                          count=n(),
                          sleep=mean(sleep_total),
                          rem=mean(sleep_rem,na.rm=TRUE)
                 ) %>%
                 filter(count>=20))


# Entre bastidores,

#      x %>% f(y)  se convierte en f(x,y)


#     x %>% f(y) %>% g(z) se convierte en g(f(x, y),z)

#########################################
## Alternativas para el uso de pipes


#  Las tuberías (pipes) son una poderosa herramienta que hace mas claro y fácil aplicar una secuencia de operaciones. Ahora las examinaremos mas a detalle para aprender muchas otras ventajas de trabajar con tuberías (pipes)

# El punto de las tuberías es ayudarte a escribir código de una manera fácil para leer y entender. 
# Para terminar de ver porque las tuberías son también útiles, exploraremos las maneras de escribir el mismo código. 


# En el libro [R for Data Science](http://r4ds.had.co.nz/introduction.html), utilizan la historia de un pequeño conejo llamado Foo:


# Pero...En la versión Latinoamericana, usaremos la versión de Pimpon:
#  Pimpon es un muñeco muy guapo y de carton
#    Se lava la carita con agua y con jabon
#    se desenreda el pelo con peina de marfil
#    y aunque se de estirones, no llora ni hace asi.


#- Empezamos por crear un objeto que represente a Pimpón.


#  Pimpon<-es_un_muneco(muy_guapos, carton)

# - Y necesitamos funciones para cada verbo: 

#     - lava() 
#     - desenreda() 
#     - NoLlora()
#     - HaceAsi()

# Usando este objeto y sus verbos hay  (al menos) 4 maneras de recontar la historia en código:

# 1. Salvar cada paso intermedio como un nuevo objeto

# 2. Sobrescribir el objeto original

# 3. Composición de funciones

# 4. Uso de pipes

##########################
### 1. Salvar cada paso intermedio como un nuevo objeto

# Esta es la mas simple aproximación:

# Pimpon_1<-lava(Pimpon, que=Carita,conque=Agua,Jabon)
# Pimpom_2<-desenreda(Pimpom_1, Que=Pelo, conque=PeineMarfil)
# Pimpom_3<-NoLlora(Pimpon_2)
# Pimpom_4<-NiHaceAsi(Pimpom_3)

#### ¿ Cuales son las desventajas de esto?

# La principal desventaja es que debemos forzar  que generamos nombres por cada paso, que no siempre son naturales, ya que debemos anexar el subfijo numérico para que sean únicos. Entonces:

# 1.  El código esta lleno de nombres de variables sin importancia.

# 2. Hay que prestar atención o ser cuidadosos en el incremento del subfijo por cada línea. 

# 3. Es muy común que cuando yo generó este tipo de código, me equivoco en el subfijo y tardo 10 minutos o mas rompiéndome la cabeza tratando de encontrar el error.

# 4. Pudiéramos pensar que además estamos creando muchas copias que usaran mucha memoria...esto no es del todo cierto en R. 

# Demos una mirada a un pipeline de manipulación de datos donde adicionamos una una columna a ggplot2::diamonds:

diamonds<- ggplot2::diamonds

diamonds2 <- diamonds %>%
        dplyr::mutate(price_per_carat = price / carat)

pryr::object_size(diamonds)

pryr::object_size(diamonds2)

pryr::object_size(diamonds, diamonds2)

# pryr::object-size() regresa la memoria ocupada por todos objetos definidos como argumentos:

  # - `diamonds` toma 3.46 MB,
  # - `diamonds2` usa 3.89 MB,
  # - `diamonds` y `diamonds2` juntos usan 3.89 MB!

# ¿Cómo puede funcionar eso? Bueno, `diamonds2` tiene 10 columnas en común con `diamonds`: no es necesario duplicar todos esos datos, por lo que los dos marcos de datos tienen variables en común. Estas variables solo se copiarán si modifica una de ellas.

### 2. Sobrescribir el objeto original

# En lugar de crear objetos intermedios en cada pasó, sobrescribimos en el original:


# Pimpon <- lava(Pimpon, que=Carita,conque=Agua,Jabon)
# Pimpom <-desenreda(Pimpom, Que=Pelo, conque=PeineMarfil)
# Pimpom <-NoLlora(Pimpon)
# Pimpom <-NiHaceAsi(Pimpom)

#### ¿ Cuales son las ventajas y desventajas de esto?

# La ventaja es que escribimos y pensamos menos y por lo tanto nos equivocamos menos.

# Las desventajas:

# 1. La depuración es dolorosa, si tu cometes un error debes re-correr el pipeline (canalización) completo desde el inicio. 

# 2. La repetición del objeto que se esta transformado hace obscuros los cambios en cada paso ( 8 veces cambia!)

### 3. Composición de funciones

# Otra aproximación es abandonar la asignación y solo encadenar el llamado de las funciones: 

# NiHaceAsi(
# 	NoLlora(
# 		desenreda(
# 		     lava(Pimpon, que=Carita,conque=Agua,Jabon),
# 		     que=Pelo, conque=PeineMarfil)
# 	)
# )



#### ¿ Cuales son las ventajas y desventajas de esto?



# La ventaja es que es un código muy compacto, sin repetición de variables.

# La desventaja es que tu tienes que leer de adentro hacia fuera, de izq a derecha  y que los argumentos terminan separados(evocativamente llamado el problema del emparedado dagwood ). En resumen...es un codigo dificil de digerir para los humanos.



### 4. Uso de pipe

# - Finalmente podemos usar el pipe:

# Pimpon %>% 
# 	lava(que=Carita,conque=Agua,Jabon) %>%
#            desenreda(Que=Pelo, conque=PeineMarfil) %>%
# 	NoLlora() %>%
# 	NiHaceAsi() 






#### ¿ Cuales son las ventajas y desventajas de esto?


# Puede ser facilmente la preferida, porque se enfoca en los verbos no el sujeto, tu puedes leer esta serie de funciones como leirías el conjunto inicial de acciones imperativas.  Pimpón se lava, se desenreda, No llora, NiHaceAsi.

# La única desventaja, es que si tu no estas familiarizado con el pipe, puede resultar dificil la interpretación de lo que hace un código que incluye %>%.  Afortunadamente la mayoría de la gente capta la idea muy rápidamente. 

#  Los `pipes` trabajan realizando una "transformación lexica": detrás de escena, magrittr reensambla el código en la tubería a una forma que funciona sobrescribiendo un objeto intermedio. Cuando ejecuta una tubería como la de arriba, magrittr hace algo como esto:

my_pipe <-function(.) {
	. <- lava(., que=Carita,conque=Agua,Jabon)
  . <- desenreda(., Que=Pelo, conque=PeineMarfil)
	. <- NoLlora(.)
	. <- NiHaceAsi(.) 
}

my_pipe(Pimpon)




## Cuando no usar Pipes 


# - Cuando tus pipes son muy largos (mas de 10 paso). En este caso crea objetos intermedios con nombres útiles...para facilitar checar los errores y hacerlo mas fácil de entender.

# - Cuando tienes múltiples entradas o salidas.

# - Si tu estas pensando en dirigirte hacia una grafica con dependencias complejas de la estructura.  Recuerda.:  los pipelines son fundamentalmente lineales

# - Funciones que usan "variables de ambiente", como assign, tryCatch, get(), load() entre otras. 



## Otras herramientas de magrittr

# - Cuando trabajas con tuberías mas complejas, algunas veces es útil llamar a una función para conocer sus efectos secuendarios, como imprimir un objeto ó graficarlo o escribirlo a un archivo, y ese tipo de acciones no regresar nada y terminan el pipe o tubería.

# Para darle vuelta a este problema, puedes usar el "tee pie" %T% porque literalmente funciona con esa forma de tuberia, dando una salida hacia la grafica y otra hacia la escritura del objeto, por ejemplo. 


#### Tee pipe

# Veamos un ejemplo de aplicación:  graficar datos e imprimir la lista de valores. 

#  Usando solo los pipes, la salida es nula:


rnorm(100) %>%
   matrix(ncol = 2) %>%
   plot() %>%
   str()

# Usando un Tee pipe, los datos se grafican y se imprimen en pantalla:

rnorm(100) %>%
   matrix(ncol = 2) %T>%
   plot() %>%
   str()


# - Si estás trabajando con funciones que no están basados en data.frame
# (es decir, les pasas vectores individuales, no un data.frame y expresiones para evaluar en el contexto de ese data.frame), es posible que %$% te resulte útil. “Desglosa” las variables de un data.frame para que pueda hacer referencia a ellas explícitamente. Esto es útil cuando se trabaja con muchas funciones en base R:

mtcars %$%
  cor(disp,mpg)

# - Para asignaciones magrittr proporciona el operador %<>% el cual perimite premplazar este codigo:

mtcars <- mtcars %>%
  transform(cyl = cyl *2)

# con este:


mtcars %<>% transform(cyl = cyl *2)


## Ejercicios 2:

# 1. ¿Cuántos estilos de programación existen sin usar pipes? 

# 2. ¿Existe correlación entre el tamaño del cuerpo y el tamaño del cerebro en la tabla msleep?  

# 3. Usando pipes, generé un codigo para calcular la correlación entre tiempo de sueño y tiempo rem, por orden taxonomica, filtrando solo para aquellos grupos con mas de 3 individuos
  
  
 