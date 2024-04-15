#!/bin/bash

# Pongo a disposiciÃ³n pÃºblica este script bajo el tÃ©rmino de "software de dominio pÃºblico".
# Puedes hacer lo que quieras con Ã©l porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patraÃ±as similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningÃºn tipo de tÃ©rminos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para bajar el cÃ³digo fuente, compilar y ejecutar el minero de monero
#
#  EjecuciÃ³n remota:
#   curl -s https://raw.githubusercontent.com/nipegun/t-scripts/main/SoftInst/Cryptos-XMR-Minero-BajarCompilarYEjecutar.sh | bash
# ----------

vDirWallet="44Me5bT3H23HVqk18BHNY7ayMvgVsU9C5YmCVm2tVEbgRFq3twPNMQTDKdJ6Vjod82NyAbi4k1hFDYMV611CsyrbQ5gotdV

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Notificar el inicio de ejecuciÃ³n del script
  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de compilaciÃ³n y ejecuciÃ³n de XMRig...${FinColor}"
  echo ""

echo ""
echo "  Actualizando Termux..."
echo ""
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
pkg update -y
pkg upgrade -y
pkg autoclean -y

echo ""
echo "  Descargando el repositorio de XMRig..."
echo ""
rm -rf ~/Cryptos/XMR/minero/ 2> /dev/null
mkdir -p ~/Cryptos/XMR/ 2> /dev/null
cd ~/Cryptos/XMR/
pkg install -y git
git clone https://github.com/xmrig/xmrig.git
cd xmrig

echo ""
echo "  Compilando..."
echo ""
mkdir build
cd build
pkg install -y cmake
cmake .. -DWITH_HWLOC=OFF
make -j $(nproc)

# Preparar la carpeta del minero
  mv ~/Cryptos/XMR/xmrig/build/ ~/Cryptos/XMR/minero/
  rm -rf ~/Cryptos/XMR/xmrig/ 2> /dev/null

echo ""
echo "  Creando ID para el minero..."
echo ""
# A partir de la MAC WiFi
  # Obtener MAC de la WiFi
    vDirMACwlan0=$(ip addr show wlan0 | grep link/ether | cut -d" " -f6 | sed 's/://g')
  # Generar un identificador del minero a partir de la MAC de la WiFi...
    vIdMinero=$(echo -n $DirMACwlan0 | md5sum | cut -d" " -f1)

echo ""
echo "  Determinando la cantidad de hilos a utilizar en el proceso..."
echo ""
vHilos=$(cat /proc/self/status | grep pus_allowed_list | cut -d"-" -f2)

echo ""
echo "  Ejecutando minero con identificador:"
echo ""
echo "  $vIdMinero..."
echo ""
# Sin TLS
  #~/Cryptos/XMR/minero/xmrig -o xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet
# Con TLS
  ~/Cryptos/XMR/minero/xmrig -o xmrpool.eu:9999 --threads=$vHilos --rig-id=$vIdMinero -u $vDirWallet --tls
#/data/data/com.termux/files/home/xmrig/build/xmrig
