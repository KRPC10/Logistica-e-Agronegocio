-- ============================================================
-- SCRIPT DDL: PLATAFORMA DE LOGÍSTICA PREDITIVA E OTIMIZAÇÃO
-- Baseado no Modelo Lógico BRModelo
-- ============================================================

-- 1. Tabela PRODUTOR
CREATE TABLE produtor (
    id_produtor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(20) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cidade VARCHAR(100),
    fazenda VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Ativo'
);

-- 2. Tabela PRODUTO (Vinculado ao Produtor)
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    id_produtor INT NOT NULL,
    tipo_grao VARCHAR(50) NOT NULL,
    quantidade_grao FLOAT NOT NULL,
    status VARCHAR(20) DEFAULT 'Disponivel',
    CONSTRAINT fk_produto_produtor FOREIGN KEY (id_produtor) 
        REFERENCES produtor (id_produtor) ON DELETE CASCADE
);

-- 3. Tabela MOTORISTA
CREATE TABLE motorista (
    id_motorista SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cnh VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'Ativo'
);

-- 4. Tabela CAMINHÃO (Vinculado ao Motorista)
CREATE TABLE caminhao (
    id_caminhao SERIAL PRIMARY KEY,
    id_motorista INT NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50),
    capacidade_toneladas FLOAT NOT NULL,
    ano INT,
    CONSTRAINT fk_caminhao_motorista FOREIGN KEY (id_motorista) 
        REFERENCES motorista (id_motorista) ON DELETE RESTRICT
);

-- 5. Tabela SILO
CREATE TABLE silo (
    id_silo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    capacidade_total FLOAT NOT NULL,
    ocupacao_atual FLOAT NOT NULL DEFAULT 0.0,
    status VARCHAR(20) DEFAULT 'Operacional'
);

-- 6. Tabela ROTA
CREATE TABLE rota (
    id_rota SERIAL PRIMARY KEY,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    distancia_km FLOAT NOT NULL,
    tempo_estimado TIME,
    condicao_estrada VARCHAR(50)
);

-- 7. Tabela LOG IA (Auditoria e rastreamento de decisões)
CREATE TABLE log_ia (
    id_log SERIAL PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    decisao_ia VARCHAR(255) NOT NULL,
    motivo VARCHAR(255),
    confianca FLOAT
);

-- 8. Tabela PREVISÃO IA (Métricas de ocupação projetada)
CREATE TABLE previsao_ia (
    id_previsao SERIAL PRIMARY KEY,
    id_log_ia INT NOT NULL,
    id_silo INT NOT NULL,
    data_previsao DATE NOT NULL,
    ocupacao_prevista FLOAT NOT NULL, -- Tipo ajustado para FLOAT (porcentagem/tonelada)
    tempo_espera_previsto TIME,
    nivel_alerta VARCHAR(20),
    CONSTRAINT fk_previsao_log FOREIGN KEY (id_log_ia) 
        REFERENCES log_ia (id_log) ON DELETE CASCADE,
    CONSTRAINT fk_previsao_silo FOREIGN KEY (id_silo) 
        REFERENCES silo (id_silo) ON DELETE CASCADE
);

-- 9. Tabela ENTREGA (Centraliza Rota, Veículo, Silo e Carga)
CREATE TABLE entrega (
    id_entrega SERIAL PRIMARY KEY,
    id_caminhao INT NOT NULL,
    id_silo INT NOT NULL,
    id_rota INT NOT NULL,
    id_produto INT NOT NULL,
    data_saida TIMESTAMP,
    data_chegada TIMESTAMP,
    quantidade_grao FLOAT NOT NULL,
    status_entrega VARCHAR(30) DEFAULT 'Em Transito',
    CONSTRAINT fk_entrega_caminhao FOREIGN KEY (id_caminhao) REFERENCES caminhao (id_caminhao),
    CONSTRAINT fk_entrega_silo FOREIGN KEY (id_silo) REFERENCES silo (id_silo),
    CONSTRAINT fk_entrega_rota FOREIGN KEY (id_rota) REFERENCES rota (id_rota),
    CONSTRAINT fk_entrega_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
);