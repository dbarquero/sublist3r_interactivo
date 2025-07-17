#!/bin/bash

# ╔══════════════════════════════════════════════════════════╗
# ║ Instalador Interactivo de Sublist3r                     ║
# ║ Autor: David Barquero · CyberBalance                    ║
# ╚══════════════════════════════════════════════════════════╝

REPO="https://github.com/aboul3la/Sublist3r.git"
VENV_DIR="sublist3r-venv"
APP_DIR="Sublist3r"
HTML_REPORT="reporte_sublist3r.html"

echo " Verificando entorno..."

# 1. Verificar si python3-venv está instalado
if ! dpkg -s python3-venv &> /dev/null; then
  echo "⚙️ Instalando python3-venv..."
  sudo apt update && sudo apt install python3-venv -y
else
  echo " python3-venv ya está instalado."
fi

# 2. Verificar y crear entorno virtual
if [ ! -d "$VENV_DIR" ]; then
  echo "🔧 Creando entorno virtual..."
  python3 -m venv $VENV_DIR
else
  echo " Entorno virtual ya existe."
fi

# 3. Activar entorno virtual
source $VENV_DIR/bin/activate

# 4. Clonar Sublist3r si no existe
if [ ! -d "$APP_DIR" ]; then
  echo " Clonando Sublist3r..."
  git clone $REPO
else
  echo "Sublist3r ya está clonado."
fi

cd $APP_DIR
echo " Instalando dependencias de Sublist3r..."
pip install --upgrade pip
pip install -r requirements.txt

# Función para generar el reporte HTML
generar_html() {
    local dominio=$1
    local archivo=$2
    cat <<EOF > ../$HTML_REPORT
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Reporte Sublist3r - $dominio</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
body { font-family: 'Segoe UI', sans-serif; background-color: #0f1117; color: #f0f0f0; margin: 0; padding: 0; }
header { background-color: #1f2937; padding: 20px; text-align: center; color: #10b981; }
main { padding: 30px; }
table { width: 100%; border-collapse: collapse; margin-top: 20px; }
th, td { border: 1px solid #374151; padding: 12px; text-align: left; }
th { background-color: #111827; color: #93c5fd; }
tr:nth-child(even) { background-color: #1f2937; }
footer { background-color: #1f2937; color: #9ca3af; text-align: center; padding: 10px; margin-top: 40px; }
.icon { margin-right: 10px; color: #60a5fa; }
</style>
</head>
<body>
<header>
  <h1><i class="fas fa-network-wired icon"></i>Reporte de Subdominios</h1>
  <h2><i class="fas fa-globe icon"></i>Dominio: $dominio</h2>
  <p><i class="fas fa-calendar-day icon"></i>Generado: $(date '+%Y-%m-%d %H:%M:%S')</p>
</header>
<main>
  <h3><i class="fas fa-list icon"></i>Resultados:</h3>
  <table>
    <tr><th>#</th><th>Subdominio</th></tr>
EOF

    local count=1
    while IFS= read -r line; do
        echo "    <tr><td>$count</td><td>$line</td></tr>" >> ../$HTML_REPORT
        ((count++))
    done < "$archivo"

    cat <<EOF >> ../$HTML_REPORT
  </table>
</main>
<footer>
  <i class="fas fa-shield-alt icon"></i> Reporte generado por Sublist3r + CyberBalance
</footer>
</body>
</html>
EOF
    echo " Reporte HTML generado: $(realpath ../$HTML_REPORT)"
}

# Menú interactivo
mostrar_menu() {
  clear
  echo " Sublist3r - Menú Avanzado"
  echo "1. Búsqueda simple en pantalla"
  echo "2. Búsqueda de dominio y Guardar en archivo en HTML"
  echo "3. Verbose"
  echo "4. Multithread"
  echo "5. Verbose + Guardar"
  echo "6. Guardar + Multithread"
  echo "7. Verbose + Multithread + Guardar"
  echo "8. Salir"
  read -p "Selecciona una opción (1-8): " opcion

  case $opcion in
    1)
      read -p "Dominio: " dominio
      python3 sublist3r.py -d "$dominio"
      ;;
    2)
      read -p "Dominio: " dominio
      read -p "Archivo salida: " archivo
      python3 sublist3r.py -d "$dominio" -o "$archivo"
      generar_html "$dominio" "$archivo"
      ;;
    3)
      read -p "Dominio: " dominio
      python3 sublist3r.py -v -d "$dominio"
      ;;
    4)
      read -p "Dominio: " dominio
      read -p "Hilos (ej. 50): " hilos
      python3 sublist3r.py -d "$dominio" -t "$hilos"
      ;;
    5)
      read -p "Dominio: " dominio
      read -p "Archivo salida: " archivo
      python3 sublist3r.py -v -d "$dominio" -o "$archivo"
      generar_html "$dominio" "$archivo"
      ;;
    6)
      read -p "Dominio: " dominio
      read -p "Archivo salida: " archivo
      read -p "Hilos: " hilos
      python3 sublist3r.py -d "$dominio" -o "$archivo" -t "$hilos"
      generar_html "$dominio" "$archivo"
      ;;
    7)
      read -p "Dominio: " dominio
      read -p "Archivo salida: " archivo
      read -p "Hilos: " hilos
      python3 sublist3r.py -v -d "$dominio" -t "$hilos" -o "$archivo"
      generar_html "$dominio" "$archivo"
      ;;
    8)
      deactivate
      echo " Entorno virtual cerrado. Hasta pronto."
      exit 0
      ;;
    *)
      echo " Opción inválida."
      ;;
  esac
}

while true; do
  mostrar_menu
  read -p "Presione Enter para continuar..."
done
