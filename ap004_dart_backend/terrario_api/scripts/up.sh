#!/usr/bin/env bash
# Sobe todo o ambiente da API de Terrários.
# Uso: ./scripts/up.sh [--rebuild] [--reset]

set -euo pipefail                   # aborta em erro, em variável indefinida e em falha de pipe

cd "$(dirname "$0")/.."                          # roda sempre a partir da raiz do projeto

RECONSTRUIR=false
RESETAR=false

for argumento in "$@"; do
  case "$argumento" in
    --rebuild) RECONSTRUIR=true ;;
    --reset)               RESETAR=true ;;
    *) echo "Argumento desconhecido: $argumento"; exit 1 ;;
  esac
done

# 1. Garante que a configuração existe.
if [ ! -f .env ]; then
  echo "Arquivo .env nao encontrado. Criando a partir de .env.example..."
  cp .env.example .env
  echo "Edite o .env e defina as senhas antes de continuar."
  exit 1
fi

# 2. Opcionalmente apaga o volume para recriar o banco do zero.
if [ "$RESETAR" = true ]; then
  echo "Removendo contêineres e volumes..."
  docker compose down -v
fi

# 3. Sobe os serviços.
if [ "$RECONSTRUIR" = true ]; then
  docker compose up -d --build
else
  docker compose up -d
fi

# 4. Espera a API responder antes de devolver o controle ao usuário.
PORTA="$(grep -E '^SERVER_PORT=' .env | cut -d= -f2)"
echo "Aguardando a API responder em http://localhost:${PORTA} ..."

for tentativa in $(seq 1 60); do
  if curl -fsS "http://localhost:${PORTA}/health/ready" > /dev/null 2>&1; then
    echo
    echo "Ambiente pronto."
    echo "            API .......: http://localhost:${PORTA}/api/v1/terrarios"
    echo "            Documentos : http://localhost:${PORTA}/docs"
    echo "            Saude .....: http://localhost:${PORTA}/health/ready"
    exit 0
  fi
  printf '.'
  sleep 2
done

echo
echo "A API nao respondeu a tempo. Logs:"
docker compose logs --tail=50 api
exit 1
