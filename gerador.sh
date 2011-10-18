#!/bin/bash

cria_arqs_entrada() {

# Garantindo que temos uma lista de arquivos com extensao kml:
for i in $@; do

    if [[ "$i" =~ .*.kml ]]; then
        grep '<name>.*km/h' $i|cut -d\~ -f2|tr -d ' '|sed 's/km\/h//' > ${i/.*.kml/.input}

    else
        echo "Erro, apenas arquivos .kml sao permitidos."
        exit 1
    fi

done 

}

cria_codigos_de_cor() {

# Gera todas as saidas possiveis (locais e globais):
for i in $@; do

    if [[ "$i" =~ .*.input ]]; then
        ./main.py $i
        mv ${i/input/colorCodes} ${i/input/colorCodes.local}

    else
        echo "Erro, apenas arquivos .input sao permitidos."
        exit 1
    fi
done

# Se houver mais de um arquivo passado como parametro, entao fazer as medicoes
# para os valores globais.
if (( ${#@} > 1 )); then
    ./main.py $@
fi

}

# O programa deve receber arquivos com extensao kml como argumentos na linha de
# comando. Se isto nao ocorrer, o programa sai com erro.
cria_arqs_entrada $@
cria_codigos_de_cor ${@/.*.kml/.input}
