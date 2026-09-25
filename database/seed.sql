-- ============================================================
-- DADOS FICTÍCIOS - CENÁRIO DE DECISÃO AGROFLOW IA
-- ============================================================

-- 1. CADASTRO DOS SILOS
INSERT INTO silo (nome, cidade, capacidade_total, ocupacao_atual, status) 
VALUES 
('Silo A - Sorriso', 'Sorriso', 10000.0, 9200.0, 'Operacional'), -- 92% Ocupado
('Silo B - Sinop', 'Sinop', 10000.0, 5800.0, 'Operacional');   -- 58% Ocupado

-- 2. PRODUTOR RURAL (Fazenda de Origem)
INSERT INTO produtor (nome, cpf_cnpj, telefone, email, cidade, fazenda, status)
VALUES 
('Fazenda Agroflow MT', '12.345.678/0001-90', '(66) 99999-1010', 'contato@agroflow.com.br', 'Sorriso', 'Fazenda Primavera', 'Ativo');

-- 3. ROTAS (Silo A próximo vs Silo B alternativo)
INSERT INTO rota (origem, destino, distancia_km, tempo_estimado, condicao_estrada)
VALUES 
('Fazenda Primavera', 'Silo A - Sorriso', 15.0, '00:20:00', 'Boa'),
('Fazenda Primavera', 'Silo B - Sinop', 45.0, '00:45:00', 'Excelente');

-- 4. CADASTRO DA FROTA (18 Motoristas e Caminhões)
INSERT INTO motorista (nome, cpf, cnh, telefone, status) VALUES
('Motorista 01', '111.111.111-01', 'CNH0001', '(66) 98100-0001', 'Ativo'),
('Motorista 02', '111.111.111-02', 'CNH0002', '(66) 98100-0002', 'Ativo'),
('Motorista 03', '111.111.111-03', 'CNH0003', '(66) 98100-0003', 'Ativo'),
('Motorista 04', '111.111.111-04', 'CNH0004', '(66) 98100-0004', 'Ativo'),
('Motorista 05', '111.111.111-05', 'CNH0005', '(66) 98100-0005', 'Ativo'),
('Motorista 06', '111.111.111-06', 'CNH0006', '(66) 98100-0006', 'Ativo'),
('Motorista 07', '111.111.111-07', 'CNH0007', '(66) 98100-0007', 'Ativo'),
('Motorista 08', '111.111.111-08', 'CNH0008', '(66) 98100-0008', 'Ativo'),
('Motorista 09', '111.111.111-09', 'CNH0009', '(66) 98100-0009', 'Ativo'),
('Motorista 10', '111.111.111-10', 'CNH0010', '(66) 98100-0010', 'Ativo'),
('Motorista 11', '111.111.111-11', 'CNH0011', '(66) 98100-0011', 'Ativo'),
('Motorista 12', '111.111.111-12', 'CNH0012', '(66) 98100-0012', 'Ativo'),
('Motorista 13', '111.111.111-13', 'CNH0013', '(66) 98100-0013', 'Ativo'),
('Motorista 14', '111.111.111-14', 'CNH0014', '(66) 98100-0014', 'Ativo'),
('Motorista 15', '111.111.111-15', 'CNH0015', '(66) 98100-0015', 'Ativo'),
('Motorista 16', '111.111.111-16', 'CNH0016', '(66) 98100-0016', 'Ativo'),
('Motorista 17', '111.111.111-17', 'CNH0017', '(66) 98100-0017', 'Ativo'),
('Motorista 18', '111.111.111-18', 'CNH0018', '(66) 98100-0018', 'Ativo');

INSERT INTO caminhao (id_motorista, placa, modelo, capacidade_toneladas, ano) VALUES
(1,  'RAX-1A01', 'Volvo FH 540', 25.0, 2023), (2,  'RAX-1A02', 'Scania R450',  25.0, 2022),
(3,  'RAX-1A03', 'DAF XF',       25.0, 2023), (4,  'RAX-1A04', 'Volvo FH 540', 25.0, 2021),
(5,  'RAX-1A05', 'Mercedes Actros', 25.0, 2020), (6,  'RAX-1A06', 'Scania R450',  25.0, 2023),
(7,  'RAX-1A07', 'Volvo FH 540', 25.0, 2022), (8,  'RAX-1A08', 'DAF XF',       25.0, 2023),
(9,  'RAX-1A09', 'Mercedes Actros', 25.0, 2021), (10, 'RAX-1A10', 'Volvo FH 540', 25.0, 2022),
(11, 'RAX-1A11', 'Scania R450',  25.0, 2023), (12, 'RAX-1A12', 'DAF XF',       25.0, 2021),
(13, 'RAX-1A13', 'Volvo FH 540', 25.0, 2022), (14, 'RAX-1A14', 'Mercedes Actros', 25.0, 2023),
(15, 'RAX-1A15', 'Scania R450',  25.0, 2020), (16, 'RAX-1A16', 'Volvo FH 540', 25.0, 2023),
(17, 'RAX-1A17', 'DAF XF',       25.0, 2022), (18, 'RAX-1A18', 'Mercedes Actros', 25.0, 2023);

-- 5. REGISTRO DE DECISÃO DA AGROFLOW IA
INSERT INTO log_ia (data_hora, decisao_ia, motivo, confianca)
VALUES (
    CURRENT_TIMESTAMP,
    'DIRECIONAR CARGA PARA SILO B',
    'Silo A próximo da capacidade (92%). Silo B possui 58% de ocupação com menor tempo total de ciclo.',
    0.98
);

INSERT INTO previsao_ia (id_log_ia, id_silo, data_previsao, ocupacao_prevista, tempo_espera_previsto, nivel_alerta)
VALUES 
(1, 1, CURRENT_DATE, 92.0, '02:30:00', 'CRITICO'), -- Silo A
(1, 2, CURRENT_DATE, 58.0, '00:15:00', 'NORMAL');  -- Silo B

-- 6. EXECUÇÃO DO DESVIO PELA IA (Corrigido colunas: id_produtor e tipo_grao)
INSERT INTO entrega (id_caminhao, id_silo, id_rota, id_produtor, data_saida, quantidade_grao, tipo_grao, status_entrega)
VALUES 
(1, 2, 2, 1, CURRENT_DATE, 25.0, 'Soja', 'Em Transito (Redirecionado pela IA)'),
(2, 2, 2, 1, CURRENT_DATE, 25.0, 'Soja', 'Em Transito (Redirecionado pela IA)');
