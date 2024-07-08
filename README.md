# Aplicacion de ejemplo para curso de Docker, del canal Hola Mundo.

Curso completo gratis: https://www.youtube.com/watch?v=4Dko5W96WHg

# Instalar Docker Desktop.

Contiene: 

- Docker engine - Motor de docker, permite crear y ejecutar contenedores
- Docker CLI - Herramienta de línea de comandos para poder interactuar con Docker Engine
- Docker Compose - Mediante configuración .yaml permite definir y ejecutar aplicaciones multi-contenedor
- Kubernetes - Incluye versión simplificada para la orquestación de contenedores
- UI (Interfaz de Usuario)

En Windows, Docker Desktop ejecuta Docker Engine dentro de una máquina virtual (VM) ligera basada en una distribución de Linux. 
Esta máquina virtual utiliza el subsistema de Windows para Linux (WSL 2) o Hyper-V (tecnología de virtualización de Microsoft), dependiendo de la configuración de Docker Desktop.

Puedes verificar si Docker Desktop está usando WSL 2 o Hyper-V desde la configuración de Docker Desktop:

- Abre Docker Desktop.
- Ve a Settings (Configuraciones).
- En la sección General o Resources, busca la opción que indica si Docker está utilizando WSL 2 o Hyper-V.

# Imágenes y contenedores
### ¿Qué es una imagen?
- Empaquetado de aplicaciones y dependencias (incluyendo archivos de configuración): código, variables entorno, ... 
- Características:
	- Portables
	- Permiten que las aplicaciones puedan compartirse entre desarrolladores y con el equipo de operaciones
	- Hace el desarrollo y despliegues de aplicaciones mucho más sencillo
### ¿Dónde se almacenan las imágenes?
- Repositorio de contenedores
	- Privados
	- Públicos
		- Repositorio de imágenes: https://hub.docker.com/
### ¿Imagen vs Contenedor?
- Una imagen es el empaquetado que contiene el código, las dependencias, etc (lo que se comparte)
- Un contenedor es una instancia en la que tenemos corriendo nuestras imágenes 
	- Son capas de imágenes: 
	
		- Imagen App / MySQL ...
		- Imagen X
		- Imagen Y
		- Imagen Sistema Operativo: Alpine por ejemplo
### ¿Máquinas virtuales vs Docker?
- Aplicaciones
- Kernel
- Hardware

Máquinas virtuales - Se virtualiza el Kernel y también las aplicaciones (se usa el hardware de la máquina host) - Pesan varios GBs
Docker - Se virtualiza sólo la capa de las aplicaciones. Se usa el Kernel o Sistema operativo y el hardware de la máquina host - Pesan unos cientos de MBs