#!/bin/bash

#Função para verificar se um diretório existe
verificar_existencia_diretorio() {
if [ ! -d "$1" ]; then
echo "Diretório '$1' não existe."
return 1
fi
}

#Função para realizar o backup
realizar_backup() {
echo "Iniciando o backup..."
rsync -av --delete --log-file="$arquivo_log" "$diretorio_origem/" "$diretorio_destino"
echo "Backup concluído!"
}

#Função para solicitar ao usuário a origem e o destino do backup
solicitar_caminhos_backup() {
read -p "Digite o caminho do diretório de origem: " diretorio_origem
diretorio_origem=$(eval echo "$diretorio_origem")
verificar_existencia_diretorio "$diretorio_origem" || return 1

read -p "Digite o caminho do diretório de destino para o backup: " diretorio_destino
diretorio_destino=$(eval echo "$diretorio_destino")
verificar_existencia_diretorio "$diretorio_destino" || return 1

Define arquivo_log
arquivo_log="$diretorio_origem/logsync.txt"
}

#Função para solicitar ao usuário a confirmação do backup
confirmar_backup() {
echo "Origem do backup: $diretorio_origem"
echo "Destino do backup: $diretorio_destino"
read -p "Deseja continuar com o backup? (s/n): " confirmar

if [ "$confirmar" != "s" ]; then
echo "Backup cancelado."
return 1
fi
}

#Função principal para controlar o fluxo do programa
principal() {
echo "Bem-vindo ao script de backup!"

solicitar_caminhos_backup || return 1

confirmar_backup || return 1

realizar_backup
}

#Exibir as opções ao usuário
exibir_opcoes() {
echo "[1] - Executar o backup"
echo "[2] - Sair"
}

#Executar o programa até que o usuário escolha sair
while true; do
exibir_opcoes
read -p "Escolha uma opção: " opcao

case $opcao in
1)
principal
;;
2)
echo "Encerrando o programa..."
break
;;
*)
echo "Opção inválida. Por favor, escolha novamente."
;;
esac

echo
done
