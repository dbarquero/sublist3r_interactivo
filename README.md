Si te gusta y te funciona para tus tareas 
¡Dale ⭐ al repositorio y compártelo con tu comunidad de hacking ético!

# sublist3r_interactivo
Instalador automático y entorno para Sublist3r interactivo

Características destacadas

Instalación automática de dependencias (`python3-venv`, Sublist3r, pip)  
Creación de entorno virtual seguro (solo si no existe)  
Reutilización del entorno y código ya instalado  
Menú interactivo con **todas las combinaciones posibles** de Sublist3r  
Generación automática de reportes en **HTML bonito** con íconos  
Compatible con auditorías y tareas de pentesting

---

##  Requisitos

- Kali Linux / Ubuntu / Debian
- Git
- Python 3.x
- Conexión a Internet para descargar dependencias

---

##  Instalación y uso

```bash
git clone https://github.com/dbarquero/sublist3r_interactivo.git
cd sublist3r_interactivo
chmod +x sublist3r_interactivo.sh
./sublist3r_interactivo.sh

El script detectará si ya existen:

El entorno virtual (sublist3r-venv)
El repositorio Sublist3r (Sublist3r/)
Si ya existen, los reutiliza sin volver a instalar nada.

Autor
dbarquero
Especialista en Ciberseguridad – CyberBalance

Legal
Este script se proporciona solo con fines educativos y legales. No se debe utilizar en dominios sin autorización explícita. El autor no se hace responsable del mal uso.
