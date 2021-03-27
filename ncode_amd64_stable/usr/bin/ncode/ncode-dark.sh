  #!/bin/bash
  #####################################################################################
  #### SUPORTE REGIONAL - SANTA INÊS - MA
  #### Nilsonlinux
  #####################################################################################
  export DIR="$(dirname "$(readlink -f "$0")")"
  pkill yad
##########################################################################
  OPEN="play $DIR/sounds-alert/window-new.oga"
  CLOSE="play $DIR/sounds-alert/window-close.oga"
  ERRO="play $DIR/sounds-alert/erro.oga"
  CONECTADO="play $DIR/sounds-alert/ok.oga"
  THEME="Ncode Dark Theme"
  #####################################################################################
    while true
    do
    NOME=
    CARGO=
    CODIGO=
    LOJA=
    TIPO=
    ###############################################################################################
      FORMULARY=$( ${OPEN} | GTK_THEME="$THEME" yad --form --borders=10 --center --width=550      \
          --window-icon="gtk-execute"  --image="$DIR/img/ncode.png" --item-separator=","          \
          --title "NCODE - GERADOR DE CÓDIGO DE BARRAS"                                           \
          --form                                                                                  \
          --field="N O M E"  $NOME ""                                                             \
          --field="C A R G O":CBE $CARGO "OPERADOR,FISCAL,CPD,VENDEDOR,GERENTE"                   \
          --field="C Ó D I G O" $CODIGO ""                                                        \
          --field="L O J A S":CB $LOJA "SUPER,MIX,CAMIÑO,ELETRO,GRUPO"                            \
          --field="T I P O ":CB $TIPO "EAN13,EAN8,CODE39,CODE93,CODE11,CODE128,CODABAR,ITF,STF"   \
          --field="I M P R E S S O R A" $PRINTER ""                                               \
          --button="☀️":$DIR/ncode.sh --button="IMPRESSORAS":$DIR/printer.sh --button="CANCELAR":1 --button="GERAR CÓDIGO":0)
      [ $? != 0 ] && exit
      NOME=$(echo $FORMULARY      | awk -F '|' '{ print $1 }')
      CARGO=$(echo $FORMULARY     | awk -F '|' '{ print $2 }')
      CODIGO=$(echo $FORMULARY    | awk -F '|' '{ print $3 }')
      TIPO=$(echo $FORMULARY      | awk -F '|' '{ print $4 }')
      PRINTER=$(echo $FORMULARY   | awk -F '|' '{ print $5 }')
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
    --text="Por favor, preencha os campos.
Para que seja gerado o código!"                   \
    --text-align=center                           \
    --button=Fechar
else
######################################
if [ -e "/home/$USER/Codigo_MaxiPOS" ]
then
echo " o diretorio existe"
else
echo " o diretorio não existe vamos criar o diretorio"
mkdir /home/$USER/Codigo_MaxiPOS
fi
  # Enviado dados para um arquivo HTML
$DIR/ncode "0000000$CODIGO" --type $TIPO --file /$HOME/Codigo_MaxiPOS/codigo.png --savespace 1 --xdim 2
echo $DADOS_USUARIO $DADOS_USUARIO1 $DADOS_USUARIO2 > /$HOME/Codigo_MaxiPOS/codigo.html
##########################################################################
${CONECTADO} | xdg-open /$HOME/Codigo_MaxiPOS/codigo.html && wkhtmltopdf /home/$USER/Codigo_MaxiPOS/codigo.html /home/$USER/Codigo_MaxiPOS/codigo.pdf |
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
lp -d $PRINTER /$USER/Codigo_MaxiPOS/codigo.pdf
################################################
${CLOSE}