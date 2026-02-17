# Instalación de Git 
- Descargar: Ir a git-scm.com y descargar la última versión.

![Img](/img/Installgit.png)

Una vez instalado, ejecutamos el `.exe` y seleccionamos `next` y seguir la instalación.

![Img](/img/gitsetup.png)

En la siguiente parte seleccionaremos el `editor` y en toda la instalación seguimos seleccionando `next`.

![Img](/img/giteditor.png)

![Img](/img/gitdecide.png)

También se necesita crear una cuenta en `Github`, por lo que es recomendable iniciar sesión con una cuenta personal

![Img](/img/gitlog.png)

Para continuar con las siguientes instalaciones de `Docker` y `SQL Managment`, debemos habilitar `Windows Subsystem for Linux`.

![Img](/img/windowsfeatures.png)

Instalación `Windows`

Ejecuta el instalador.

- Asegurar de marcar la opción que integra Git Bash en el menú contextual.

- En la selección de editor, se puede elegir VS Code como editor predeterminado.

- Recomendación: En la opción de PATH environment, selecciona "Git from the command line and also from 3rd-party software".

```
Bash

git --version
```
## Configuración Inicial

- Antes de hacer el primer commit, debes decirle a Git quién eres. Estos datos aparecerán en el historial de cambios.
```
Bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu_email@ejemplo.com"
```
## Comandos Esenciales del Flujo de Trabajo

- Iniciar un Repositorio
```
Bash
git init
```
Esto crea la carpeta oculta .git donde se guarda el historial.

- El ciclo de vida de los archivos (Stage y Commit)
Ver el estado: Revisa qué archivos han cambiado.
```
Bash
git status
```
Subir al Stage (Preparar archivos).
Para un archivo específico:
```
Bash
git add nombre_archivo.md
```
Para todos los archivos modificados:
```
Bash
git add .
```
Hacer Commit (Guardar la versión): Crea un punto en la historia con un mensaje descriptivo.
```
Bash
git commit -m "Estructura inicial del proyecto de Base de Datos"
``` 
# Ramas (Branches)

Crear una nueva rama:
```
Bash
git branch nombre-de-nueva-rama
```
Cambiar de rama:
```
Bash
git checkout nombre-de-nueva-rama
```
Para la versión moderna:
```
git switch nombre-de-nueva-rama
```
Fusionar ramas (Merge): (Estando en la rama principal, ej. main)
```
Bash
git merge nombre-de-la-rama-a-fusionar
```
# Conectando con la Nube (GitHub/GitLab)
Para subir tu repositorio local a internet:

Vincular repositorio remoto: (Obtén la URL de tu repositorio en GitHub primero)
```
Bash
git remote add origin https://github.com/USUARIO/BaseDeDatosNegociosDigitales.git
```
Subir cambios (Push):
```
Bash
git push -u origin main
git push -u origin rama-ma
```
Descargar cambios (Pull): Si se trabaja en otro equipo y se necesita bajar las actualizaciones:
```
Bash
git pull origin main
```
# Git y Bases de Datos: Seguridad Crítica
Cuando trabajas con bases de datos (SQL, NoSQL, Docker), nunca debes subir contraseñas o credenciales al repositorio.

```
.gitignore
```
Este comando funciona para dar seguimiento a todas las carpetas de trabajo.