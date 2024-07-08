# Imágenes

Devolver un listado de todas las imágenes que  tengamos descargadas en nuestra máquina:
- **REPOSITORY**: Nombre de la imagen
- **TAG**: Versión
- **IMAGE ID**: Identificador único
- **CREATED**: Fecha de creación de la imagen
- **SIZE**: Tamaño de la imagen

```docker images```

Descargar una imagen. Si no indicamos versión se descarga la última:

```docker pull {nombre-imagen}```

Descargar una imagen de una versión concreta:

```docker pull {nombre-imagen}:{version-imagen}```

Eliminar una imagen:

```docker image rm {nombre-imagen}:{version-imagen}```

# Contenedores

Crear un contenedor en base a una imagen (nos devuelve su identificador único):

```docker create {nombre-imagen-base}``` 

```docker container create {nombre-imagen-base}```

Levantar o iniciar un contenedor (nos devuelve su identificador): 

```docker start {id-contenedor}```

```docker start {nombre-contenedor}```

Listar todos los contenedores **en ejecución**:

Devuelve una tabla con todos los contenedores **en ejecución**:

- **CONTAINER ID**: Identificador del contenedor (versión acortada)
- **IMAGE**: En base a qué imagen se creó el contenedor
- **COMMAND**: Comando que usa el contenedor para poder ejecutarse
- **CREATED**: Hace cuanto se creó el contenedor
- **STATUS**: Estado del contenedor
- **PORTS**: Puerto que está usando el contenedor 
- **NAMES**: Nombre de nuestro contenedor. Si no ponemos uno propio crea uno random

```docker ps```

Listar **todos** los contenedores, tanto si están en ejecución como si están detenidos:

```docker ps -a ```

Detener la ejecución de un contenedor

```docker stop {id-contenedor}```

```docker stop {nombre-contenedor}```

Eliminar un contenedor

```docker rm {id-contenedor}```

```docker rm {nombre-contenedor}```

Crear un contenedor con un nombre personalizado

```docker create --name {nombre-contenedor-personalizado} {nombre-imagen-base}```

# Port Mapping
Para poder conectarnos a un contenedor levantado vamos a tener que mapear el puerto donde está escuchando nuestro contenedor con un puerto de nuestra máquina host

Mapear el puerto de un contenedor a un puerto de la máquina host (se especifica el puerto del host)

```docker create -p{puerto-maquina-host}:{puerto-contenedor} --name {nombre-contenedor-personalizado} {nombre-imagen-base}```

Mapear el puerto de un contenedor a un puerto de la máquina host (NO se especifica el puerto del host. Se mapera a un puerto aleatorio, suelen ser los que empiezan por 50.000)

```docker create -p{puerto-contenedor} --name {nombre-contenedor-personalizado} {nombre-imagen-base}```

# Logs

Consultar los logs del contenedor. Devuelve a la línea de comandos (si se sigue escribiendo en el log no se ve):

```docker logs {nombre-contenedor}```

```docker logs {id-contenedor}```

Consultar los logs del contenedor. Se queda escuchando los logs que emite:

```docker logs --follow {nombre-contenedor}```

```docker logs --follow {id-contenedor}```

# docker run

Combinación de los comandos anteriores. Realiza las siguientes acciones:
- Comprueba si se encuentra la imagen. En caso negativo, la descarga.
- Crea un contenedor
- Inicia el contenedor

Iniciar el contenedor y quedar escuchando los logs. Si se hace Ctrl + C se detiene el contenedor:

```docker run {nombre-imagen}```

Iniciar el contenedor en modo detach. No muestra los logs y nos devuelve inmediatamente a la línea de comandos:

```docker run -d {nombre-imagen}```

TODAS LAS OPCIONES VISTAS HASTA AHORA CON EL COMANDO DE DOCKER CREATE PUEDEN USARSE CON DOCKER RUN


# EJEMPLO PRÁCTICO. ¿Cómo conectarnos desde una aplicación local en node.js a un contenedor de mongodb?

Descargar la imagen de mongo

```docker pull mongo```

Crear un contenedor de mongo (llamado monguito) y configurarlo para poder conectarnos a la base de datos (con las dos variables de entorno necesarias, username y password):

```docker create -p27017:27017 --name monguito -e MONGO_INITDB_ROOT_USERNAME=natalia -e MONGO_INITDB_ROOT_PASSWORD=admin mongo```

Arrancar el contenedor

```docker start monguito```

Ejecutar nuestra aplicación node.js y desde el navegador acceder a las operaciones para listar y crear los documentos

```node index.js```

# Networks o Redes
Para que mis contenedores puedan comunicarse entre sí, hay que agruparlos en una red interna de docker. 
La comunicación se hace a través del nombre del contenedor. 

Listar todas las redes internas de docker que tenemos configuradas

```docker network ls```

Crear una red

```docker network create {nombre-red}```

Eliminar una red

```docker network rm {nombre-red}```

# Dockerizar (meter en contenedor) una app desarrollada en node.js, que se conecta con un contenedor de mongodb

¿Cómo puedo meter una aplicación dentro de un contenedor? 
Para eso necesito crear en el directorio raíz de mi aplicación un fichero llamado **Dockerfile**

1. Crear el fichero **Dockerfile**

```Dockerfile
# Especificar la imagen en la que se va a basar nuestro contenedor (en este ejemplo es una aplicación node)
FROM node:18

# Indicar la carpeta en la que va a estar alojado el código de nuestra aplicación. 
# Es una ruta dentro de nuestro contenedor (linux)
RUN mkdir -p /home/app

# Indicar la ruta local de nuestra máquina de dónde vamos a leer el código fuente. 
# El primer parámetro es el origen (local) y el segundo es el destino (linux)
COPY . /home/app

# Exponer un puerto para que nosotros (desde local) u otros contenedores, puedan conectarse con este contenedor.
EXPOSE 3000

# Indicar el comando que tiene que ejecutar el contenedor para que nuestra aplicación corra. 
# Se hace con la instrucción CMD seguida de un array con la instrucción y los argumentos (usar ruta completa)
CMD ["node", "/home/app/index.js"]
```

2. Crear la imagen de mi contenedor, en base al fichero Dockerfile

```docker build -t {nombre-imagen}:{etiqueta-version} {ruta-dockerfile}```

3. Crear una red (como vimos en el apartado anterior)

```docker network create {nombre-red}```

4. Crear mis contenedores indicando que éstos pertenecen a la red creada en el punto anterior
- Crear el contenedor de mongo

```docker create -p{puerto-maquina}:{puerto-contenedor} --name {nombre-contenedor} --network {nombre-red} -e MONGO_INITDB_ROOT_USERNAME={usuario-bd} -e MONGO_INITDB_ROOT_PASSWORD={pass-bd} {nombre-imagen-base}```

- Crear el contenedor de la imagen que creé con mi aplicación

```docker create -p{puerto-maquina}:{puerto-contenedor} --name {nombre-contenedor} --network {nombre-red} {nombre-imagen-base}```

# Docker Compose
Permite realizar todos los pasos vistos hasta ahora para crear y comunicar contenedores de forma más sencilla.
Se hace a través de un fichero llamado **docker-compose.yml**, que se añadirá a la ruta raíz de nuestro proyecto.

1. Crear el fichero **docker-compose.yml**

```yaml
version: "3.9"
	services:
		{nombre-contenedor-1}:  
			build: {ruta-dockerfile-build}  or image: {nombre-imagen}  #Uno de los dos
			ports:
				- "{puerto-máquina-host}:{puerto-contenedor}"
			links:
				- "{contenedores-utilizados}"
			environment:
				- NOMBRE_VARIABLE_1=valor_variable_1
				- NOMBRE_VARIABLE_2=valor_variable_2
```

**EJEMPLO**

```yaml
version: "3.9" # Versión de docker compose con la que estamos trabajando
services: # Contenedores que queremos crear. Se indican sus nombres
  miappcont: # Contenedor para mi aplicación node.js
    build: .  # Ruta donde está el código para construir la imagen
    ports: # Port Mapping 
      - "3000:3000" # {puerto-máquina-host:puerto-contenedor}
    links: # Otros contenedores utilizados por este
      - "mongoserver"
  mongoserver: # Contenedor basado en la imagen de mongodb
    image: mongo # Imagen en la que se basa el contenedor
    ports: # Port Mapping
      - "27017:27017" # {puerto-máquina-host:puerto-contenedor}
    environment: # Variables de entorno que hay que pasarle al contenedor para configurarlo
      - MONGO_INITDB_ROOT_USERNAME=natalia # Usuario
      - MONGO_INITDB_ROOT_PASSWORD=admin # Password
```
2. Ejecutar el comando **docker compose**
- Descarga las imágenes
- Crea los contenedores
- Inicia los contenedores

```docker compose up```

3. Detener y eliminar los contenedores (todos a la vez, sin tener que ir uno por uno)

```docker compose down```

# Volúmenes

Permiten solucionar los siguientes problemas:
- Los datos con los que trabaja nuestra aplicación contenedorizada (bases datos) se borran cada vez que se detiene el contenedor.
- Cada vez que actualizamos el código de una aplicación contenedorizada, tenemos que hacer la build de la misma para actualizar el código dentro del contenedor

Mediante volumes podemos montar ciertas carpetas de datos en el sistema operativo anfitrión para que así la información no sea volátil, o no tener que hacer la build de 
nuestro contenedor cada vez que los desarrolladores cambien el código. 

Tipos de volúmenes: 
- Anónimo: sólo indicas la ruta origen datos (no puede reutilizarse con otras imágenes)
- De anfitrión a host
- Nombrado: puede reutilizarse con otras imágenes

En el fichero docker-compose.yml se definen así:

volumes:
	{nombre-volumen}:
		
y los hay que referenciar dentro de los contenedores (a la altura de environment, links, ports, ...)
	volumes:
		- {nombre-volumen}: {ruta-contenedor-donde-estan-datos}

Las rutas donde están los datos dentro del contenedor pueden consultarse en la información de la imagen (Docker Hub).

Ejemplo con el fichero docker-compose.yml del apartado anterior:

```yaml
version: "3.9" # Versión de docker compose con la que estamos trabajando
services: # Contenedores que queremos crear. Se indican sus nombres
  miappcont: # Contenedor para mi aplicación node.js
    build: .  # Ruta donde está el código para construir la imagen
    ports: # Port Mapping 
      - "3000:3000" # {puerto-máquina-host:puerto-contenedor}
    links: # Otros contenedores utilizados por este
      - "mongoserver"
  mongoserver: # Contenedor basado en la imagen de mongodb
    image: mongo # Imagen en la que se basa el contenedor
    ports: # Port Mapping
      - "27017:27017" # {puerto-máquina-host:puerto-contenedor}
    environment: # Variables de entorno que hay que pasarle al contenedor para configurarlo
      - MONGO_INITDB_ROOT_USERNAME=natalia # Usuario
      - MONGO_INITDB_ROOT_PASSWORD=admin # Password
    volumes: # Volúmenes que usa nuestro contenedor. Las rutas están en la documentación oficial de Docker Hub
      - mongo-data:/data/db # {nombre-volumen-definido-en-seccion-volumes}:{ruta-datos-en-contenedor}
volumes:  # Definimos los volúmenes anónimos (no indicamos ruta local)
  mongo-data: # Sólo hace falta darle un nombre para referenciarlo desde un contenedor
```

