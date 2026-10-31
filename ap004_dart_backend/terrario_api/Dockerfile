# ---------- Estágio 1: compilação ----------
# A imagem oficial do Dart vem do Docker Hub e traz o SDK completo.
FROM dart:3.12 AS build

WORKDIR /app

# Copiar apenas os arquivos de dependência antes do código-fonte permite
# ao Docker reaproveitar a camada de "pub get" enquanto o pubspec não mudar.
COPY pubspec.* ./
RUN dart pub get

# Agora sim o restante do projeto.
COPY . .
RUN dart pub get --offline

# Compilação AOT: gera um binário nativo, sem necessidade da VM do Dart
# nem do código-fonte em tempo de execução.
RUN dart compile exe bin/server.dart -o /app/bin/server

# ---------- Estágio 2: imagem de execução ----------
# scratch é a imagem vazia: nem distribuição Linux, nem shell, nem
# gerenciador de pacotes. Menos software instalado significa menos
# superfície de ataque.
FROM scratch

# A imagem do Dart mantém em /runtime as bibliotecas de sistema mínimas
# exigidas pelo binário compilado.
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server
# O contrato e a página da documentação são lidos em tempo de execução,
# então precisam existir também na imagem final.
COPY --from=build /app/openapi.yaml /app/openapi.yaml
COPY --from=build /app/web/ /app/web/

WORKDIR /app

# Documenta a porta usada; a publicação efetiva é feita pelo Compose.
EXPOSE 8080

CMD ["/app/bin/server"]
