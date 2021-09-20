#!/bin/bash
  #####################################################################################
  #### SUPORTE REGIONAL - SANTA INÊS - MA
  #### Nilsonlinux
  #####################################################################################
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
  ver="2.1"
  #####################################################################################
  pkill yad
  #####################################################################################
  #############################   VERIFICAÇÃO DE CONEXÃO   ############################
checkinternet () {
  if ping -c 1 8.8.8.8 &>/dev/null; then
    NcodeCheck_att
  else
  notify-send -i dialog-error "PROGRAMA DESCONECTADO. Iniciando em modo offline..." -t 5000
  fi
}
######################## INICIAR INSTALAÇÃO DAS ATUALIZAÇÕES  #########################
atualizar () {
( 
${CONECTADO}
echo "Iniciando atualização." ; sleep 1
echo "Conectando com o servidor de atualizações..." ; sleep 1
echo "Baixando atualizações. Por favor aguarde... ⌛️" ; sleep 1
datainicial=`date +%s`
wget -O /tmp/ncode_amd64_beta1.deb https://github.com/ncode-dev/ncode/raw/main/ncode_amd64_beta1.deb 2>&1 | \
sed -u 's/^[a-zA-Z\-].*//; s/.* \{1,2\}\([0-9]\{1,3\}\)%.*/\1\n#Baixando atualizações... \1%/; s/^20[0-9][0-9].*/#Done./' | \
zenity --height 30 --width 500 --progress --percentage=0 --title=Download dialog --text=Starting... --auto-close --auto-kill
zenity --password --title="Ncode UPDATE" | sudo -S gdebi --non-interactive /tmp/ncode_amd64_beta1.deb
echo "----------------------------------------------------------------" ; sleep 1
echo "Concluíndo atualização." ; sleep 1
echo "----------------------------------------------------------------" ; sleep 1
echo 
echo "****************************************************************"
echo "***** ATUALIZAÇÃO APLICADA COM SUCESSO **** By: Nilsonlinux ****"
echo "****************************************************************"
echo
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo
${CONECTADO} | echo "🕠 Tempo de execução: $tempo "
firefox https://sistemanpdvs.github.io/tabs/contribuir/
) | GTK_THEME="$THEME" yad --text-info --window-icon "audio-x-generic.png" --title "INFORMAÇÃO" --center --height 250 --width 570 --tail --margins 4 --button="gtk-close"
}
#####################################################################################
${CLOSE}
# CHECANDO NOVA VERSÃO
NcodeCheck_att () {
  nota=$(curl --silent -q https://raw.githubusercontent.com/ncode-dev/ncode/main/nota)
  uver=$(curl --silent -q https://raw.githubusercontent.com/ncode-dev/ncode/main/ver)
  if [[ $uver > $ver ]]; then
  echo "              ⚠️⚠️⚠️ Nova versão disponível ⚠️⚠️⚠️

         Versão em uso: $ver 🙁 ➤  Nova versão: $uver 😎
  ----------------------------------------------------------------
         $nota 
  ----------------------------------------------------------------" | GTK_THEME="$THEME" yad --text-info --window-icon "audio-x-generic.png" --title "ATUALIZAÇÃO DISPONÍVEL" --center --height 500 --width 670 --tail --margins 4 --button="gtk-close" | ${ALERTA}
atualizar
fi
}
#####################################################################################
# INICIALIZAÇÃO DA VERIFICAÇÃO DE REDE
checkinternet 
clear && reset | inicio
#####################################################################################
    while true
    do
    NOME=
    CARGO=
    CODIGO=
    LOJA=
    TIPO=
    PRINTER=
    ###############################################################################################
      FORMULARY=$(GTK_THEME="$THEME" yad --form --borders=10 --center --width=550      \
          --window-icon="gtk-execute"  --image="$DIR/img/ncode.png" --item-separator=","          \
          --title "$NOME_PROG - VERSÃO $ver"                                                      \
          --form                                                                                  \
          --field="N O M E" $NOME ""                                                              \
          --field="C A R G O":CBE $CARGO "OPERADOR,FISCAL,CPD,VENDEDOR,GERENTE"                   \
          --field="C Ó D I G O" $CODIGO ""                                                        \
          --field="L O J A S":CB $LOJA "SUPER,MIX,CAMIÑO,ELETRO,GRUPO"                            \
          --field="T I P O ":CB $TIPO "EAN13,EAN8,CODE39,CODE93,CODE11,CODE128,CODABAR,ITF,STF"   \
          --field="I M P R E S S O R A" $PRINTER ""                                               \
          --button="🌙":$DIR/ncode-dark.sh --button="IMPRESSORAS":$DIR/printer.sh --button="CANCELAR":1 --button="GERAR CÓDIGO":0)
      [ $? != 0 ] && exit
      NOME=$(echo $FORMULARY      | awk -F '|' '{ print $1 }')
      CARGO=$(echo $FORMULARY     | awk -F '|' '{ print $2 }')
      CODIGO=$(echo $FORMULARY    | awk -F '|' '{ print $3 }')
      LOJA=$(echo $FORMULARY      | awk -F '|' '{ print $4 }')
      TIPO=$(echo $FORMULARY      | awk -F '|' '{ print $5 }')
      PRINTER=$(echo $FORMULARY   | awk -F '|' '{ print $6 }')
      break
      done
  ###################################################################################################
   DADOS_USUARIO="<center table border=0><br/> <meta charset="UTF-8">
     <title>Usuário MaxiPOS:$CODIGO</title>
          <a title='Imprimir código' href='javascript:window.print()'><img src='$DIR/img/print.png' border="0" /></a>
         <td><center> - - - - - - - - - - - - - - - - - - - - - </td></tr>
         <td><center><img width=100 height=50 src='$DIR/img/logo_loja/$LOJA.png' /></td></tr>
         <td><center><font size=+2>$NOME</font></td></tr>
         <td><center>$CARGO</td></tr>
         <td><center><img width=200 height=80 src='/home/$USER/Codigo_MaxiPOS/codigo.png' /></td></tr>
         <td><center><code>Usuário MaxiPOS:$CODIGO</code></td></tr>
         <td><center> - - - - - - - - - - - - - - - - - - - - - </td></tr>
      </table>" 
 DADOS_USUARIO1=" <meta charset="UTF-8">
         <td><center><img width=100 height=50 src='$DIR/img/logo_loja/$LOJA.png' /></td></tr>
         <td><center><font size=+2>$NOME</font></td></tr>
         <td><center>$CARGO</td></tr>
         <td><center><img width=200 height=80 src='/home/$USER/Codigo_MaxiPOS/codigo.png' /></td></tr>
         <td><center><code>Usuário MaxiPOS:$CODIGO</code></td></tr>
         <td><center> - - - - - - - - - - - - - - - - - - - - - </td></tr>
      </table>" 
 DADOS_USUARIO2=" <meta charset="UTF-8">
         <td><center><img width=100 height=50 src='$DIR/img/logo_loja/$LOJA.png' /></td></tr>
         <td><center><font size=+2>$NOME</font></td></tr>
         <td><center>$CARGO</td></tr>
         <td><center><img width=200 height=80 src='/home/$USER/Codigo_MaxiPOS/codigo.png' /></td></tr>
         <td><center><code>Usuário MaxiPOS:$CODIGO</code></td></tr>
         <td><center> - - - - - - - - - - - - - - - - - - - - - </td></tr>
  <section>
  <p></p>
     <p></p>
        <p></p>
          <p></p>
            <p></p>
            <footer>
               <p></p>
               <cemter><img src="$DIR/img/nilsonlinux.png" height="80" width="110"></center>
            <font size=-8>Dev: Nilsonlinux</font></td></tr>
        <p></p>
    </footer>
  </section>
      </table>" 
#########################################################################
# Verificando se o usuario digitou pelo menos o nome
if [ -z $NOME ]
then
# Notificação de erro para gerar codigo
$ERRO | GTK_THEME="$THEME" yad --title="Aviso !"  \
    --center                                      \
    --width=400                                   \
    --height=100                                  \
    --image="$DIR/img/erro.svg"                   \
    --fixed                                       \
    --text="Você não digitou o nome
no campo solicitado!"                             \
    --text-align=center                           \
    --button=Fechar
else
######################################
if [ -e "$HOME/Codigo_MaxiPOS" ]
then
echo " o diretorio existe"
else
echo " o diretorio não existe vamos criar o diretorio"
mkdir $HOME/Codigo_MaxiPOS
fi
  # Enviado dados para um arquivo HTML
$DIR/ncode "000000$CODIGO" --type $TIPO --file $HOME/Codigo_MaxiPOS/codigo.png --savespace 1 --xdim 2
echo $DADOS_USUARIO $DADOS_USUARIO1 $DADOS_USUARIO2 > $HOME/Codigo_MaxiPOS/codigo.html
##########################################################################
${CONECTADO} | xdg-open $HOME/Codigo_MaxiPOS/codigo.html && wkhtmltopdf $HOME/Codigo_MaxiPOS/codigo.html $HOME/Codigo_MaxiPOS/$CODIGO.pdf |
  # Notificação de sucesso para gerar codigo
  GTK_THEME="$THEME" yad --title="Parabéns, Código Gerado !"    \
      --center                                       \
      --width=350                                    \
      --height=110                                   \
      --image="$DIR/img/ok.svg"                      \
      --progress-text="Concluido 100%  !"            \
      --percentage=99                                \
      --progress --auto-kill                         \
      --fixed                                        \
      --text-align=center                            \
      --button=Fechar                                \
      --text="Código do(a) $NOME gerado com sucesso.
      Desenvolvedor: Nilsonlinux"
################################################
fi
lp -d $PRINTER $HOME/Codigo_MaxiPOS/codigo.pdf
################################################
${CLOSE}
