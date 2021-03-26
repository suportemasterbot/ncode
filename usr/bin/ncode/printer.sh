#!/bin/bash
  #####################################################################################
  #### SUPORTE REGIONAL - SANTA INÊS - MA
  #### Nilsonlinux
  #####################################################################################
  ${OPEN} 
# #####################################################################################
  export DIR="$(dirname "$(readlink -f "$0")")"
  ALERTA="mpv $DIR/sounds-alert/update.mp3"
  OPEN="play $DIR/sounds-alert/window-new.oga"
  CLOSE="play $DIR/sounds-alert/window-close.oga"
  ERRO="play $DIR/sounds-alert/erro.oga"
  CONECTADO="play $DIR/sounds-alert/ok.oga"
  THEME="Ncode Light Theme"
  NOME_PROG="NCODE - GERADOR DE CÓDIGO DE BARRAS"
  #####################################################################################
  lpstat -a | yad --text-info --window-icon "audio-x-generic.png" --title "IMPRESSORAS NA REDE" --center --height 200 --width 800 --tail --margins 4 --button="gtk-close"
  #####################################################################################
 ${CLOSE}