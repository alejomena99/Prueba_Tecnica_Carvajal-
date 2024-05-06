<div align="justify">
#DOCUMENTACIÓN

Esta es la documentación relacionada con el desafío #1 de la prueba técnica de Carvajal para el puesto de Ingeniero DevOps Senior.

## FRONT

El proyecto fue construido con Vue-React y cuenta con 1 asset en el cual tenemos los países disponibles para las consultas de comparación de temperatura. Se realizó de esta manera dado a que el consumo de otra API para dicho fin consumiría más recursos que la implementación del asset. Dentro de `components` nos encontramos con una única utilidad que permite realizar los llamados a la API de OpenWeatherMap [openweathermap.org/current](https://openweathermap.org/current), con la cual realizaremos nuestras comparaciones. Este componente además contiene la estructura de cada componente de búsqueda. Los estilos se encuentran en `App.css`. Otro archivo importante es `index.html`, que es la estructura básica de la página. Finalmente, nos encontramos con `env.js`, el cual contiene las variables de entorno con las cuales se espera que se use la API key.

## DOCKERFILE

En el Dockerfile nos encontramos que se está utilizando la imagen de Nginx para disponibilizar el front. Además, se envían configuraciones específicas de los archivos de Nginx como los son `my-site` y `nginx.conf`. Finalmente, el Dockerfile inicializa Nginx, por lo cual al correr la imagen se estará ejecutando en el puerto 3000 del contenedor, pero por medio de un port forwarding se puede disponibilizar en otro puerto en la máquina local.

## SCRIPTS

Dentro de la gama de archivos que contamos se encuentran dos scripts que se utilizan y funcionan tanto localmente como en GitHub Actions. El primero es `build_and_push.sh`, que nos permite conectarnos a DockerHub por medio de nuestro usuario y key que son esperadas a modo de variables de entorno `DOCKERHUB_USER` y `DOCKERHUB_KEY`. Además, el script espera recibir un argumento que permite taggear la imagen subida. El otro script es `pull-and-run.sh`. Este script nos permite hacer pull a la imagen y después disponibilizarla a nivel de contenedor en el puerto 3000 y por medio de un argumento se hará el port forwarding del contenedor.

## GITHUB ACTIONS

Dentro de GitHub Actions se desarrolló 1 pipeline con 2 jobs, `build` y `docker`. El primer job se encarga de compilar el proyecto y lo publica como un artefacto. Además, utiliza el `replace token` para reemplazar el token que será utilizado por el front para hacer las consultas a la API. El segundo job `docker` descargará el artefacto anterior dado a que es necesario para la construcción de la imagen en DockerHub. Esa construcción se hace por medio del script `build_and_push.sh` y el argumento del tag es la variable predefinida de `${{ github.run_number }}` para que el tag esté relacionado con el pipeline. Finalmente, es necesario recalcar que el pipeline requiere de 3 secretos para funcionar: `API_KEY` (API key para el uso de la API meteorológica), `DOCKERHUB_KEY` (Llave de acceso a DockerHub) y `DOCKERHUB_USER` (usuario de la cuenta de DockerHub).

<div>
