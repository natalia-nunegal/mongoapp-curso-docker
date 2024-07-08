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