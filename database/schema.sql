-- Criar Banco de Dados
CREATE DATABASE IF NOT EXISTS agroflow_ia;
USE agroflow_ia;

CREATE TABLE PRODUTOR (
    id_produtor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(20) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cidade VARCHAR(100),
    fazenda VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Ativo'
);

CREATE TABLE MOTORISTA (
    id_motorista INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    cnh VARCHAR(20) NOT NULL,
    telefone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'Ativo'
);

CREATE TABLE CAMINHAO (
    id_caminhao INT PRIMARY KEY AUTO_INCREMENT,
    id_motorista INT NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50),
    capacidade_toneladas FLOAT,
    ano INT,
    FOREIGN KEY (id_motorista) REFERENCES MOTORISTA(id_motorista) ON DELETE CASCADE
);

CREATE TABLE SILO (
    id_silo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100),
    capacidade_total FLOAT NOT NULL,
    ocupacao_atual FLOAT DEFAULT 0.0,
    status VARCHAR(20) DEFAULT 'Operacional'
);

CREATE TABLE ROTA (
    id_rota INT PRIMARY KEY AUTO_INCREMENT,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    distancia_km FLOAT NOT NULL,
    tempo_estimado TIME,
    condicao_estrada VARCHAR(50)
);

CREATE TABLE ENTREGA (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_caminhao INT NOT NULL,
    id_silo INT NOT NULL,
    id_rota INT NOT NULL,
    id_produtor INT NOT NULL,
    data_saida DATE,
    data_chegada DATE,
    quantidade_grao FLOAT NOT NULL,
    tipo_grao VARCHAR(50) NOT NULL,
    status_entrega VARCHAR(60) DEFAULT 'Em Trânsito', -- Aumentado para 60 para aceitar textos da IA
    FOREIGN KEY (id_caminhao) REFERENCES CAMINHAO(id_caminhao),
    FOREIGN KEY (id_silo) REFERENCES SILO(id_silo),
    FOREIGN KEY (id_rota) REFERENCES ROTA(id_rota),
    FOREIGN KEY (id_produtor) REFERENCES PRODUTOR(id_produtor)
);

CREATE TABLE LOG_IA (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    decisao_ia VARCHAR(255) NOT NULL,
    motivo VARCHAR(255),
    confianca FLOAT
);

CREATE TABLE PREVISAO_IA (
    id_previsao INT PRIMARY KEY AUTO_INCREMENT,
    id_log_ia INT NOT NULL,
    id_silo INT NOT NULL,
    data_previsao DATE NOT NULL,
    ocupacao_prevista FLOAT NOT NULL,
    tempo_espera_previsto TIME,
    nivel_alerta VARCHAR(30),
    FOREIGN KEY (id_log_ia) REFERENCES LOG_IA(id_log) ON DELETE CASCADE,
    FOREIGN KEY (id_silo) REFERENCES SILO(id_silo) ON DELETE CASCADE
);
