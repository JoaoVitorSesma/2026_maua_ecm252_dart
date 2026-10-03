-- O banco já é criado pela variável MYSQL_DATABASE, mas repetir a instrução
-- torna o script utilizável também fora do Docker.
CREATE DATABASE IF NOT EXISTS terrarios
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE terrarios;

CREATE TABLE IF NOT EXISTS terrarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  apelido VARCHAR(80) NOT NULL,
  -- ENUM espelha no banco a mesma restrição que o enum Bioma faz no Dart.
  bioma ENUM('tropical','desertico','temperado','musgo') NOT NULL,
  umidade_alvo TINYINT UNSIGNED NOT NULL,
  -- DECIMAL, e não DOUBLE: volume é uma medida exibida ao usuário e não
  -- deve sofrer os arredondamentos do ponto flutuante binário.
  volume_litros DECIMAL(7,2) NOT NULL,
  data_montagem DATE NOT NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  -- Unicidade garantida pelo banco: é a única defesa que resiste a duas
  -- requisições simultâneas tentando criar o mesmo apelido.
  UNIQUE KEY uk_terrarios_apelido (apelido),
  -- Índice para o filtro por bioma, que é o mais usado nas consultas.
  KEY idx_terrarios_bioma (bioma),
  CONSTRAINT ck_terrarios_umidade CHECK (umidade_alvo BETWEEN 0 AND 100),
  CONSTRAINT ck_terrarios_volume CHECK (volume_litros > 0)
) ENGINE=InnoDB;

-- Carga inicial, para que a API tenha o que mostrar já no primeiro teste.
INSERT INTO terrarios
  (apelido, bioma, umidade_alvo, volume_litros, data_montagem)
VALUES
  ('Vale das Samambaias', 'tropical', 85, 12.50, '2026-03-14'),
  ('Duna de Bolso', 'desertico', 20, 4.00, '2026-01-08'),
  ('Bosque de Musgo', 'musgo', 92, 7.25, '2025-11-30'),
  ('Clareira Fria', 'temperado', 60, 18.00, '2026-05-02');
