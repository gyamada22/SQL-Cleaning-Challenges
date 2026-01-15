-- Criação da tabela (apenas para referência de tipos, ajuste conforme seu banco)
CREATE TABLE treino_limpeza.raw.logistica_suja (
    id_envio VARCHAR(50),
    data_pedido VARCHAR(50),
    cliente_info VARCHAR(255), -- Desafio: Extrair Nome e Email
    rota VARCHAR(100), -- Desafio: Separar Origem e Destino
    dimensoes_cm VARCHAR(50), -- Desafio: Calcular volume cúbico
    peso_bruto VARCHAR(20),
    custo_frete VARCHAR(20),
    status_entrega VARCHAR(50)
);

INSERT INTO treino_limpeza.raw.logistica_suja VALUES
-- Padrao relativamente limpo
('TRK-001', '2025-02-01', '{"nome": "Carlos Silva", "email": "carlos@uol.com.br"}', 'SP > RJ', '10x20x30', '1.5kg', 'R$ 25.00', 'Entregue'),
('TRK-002', '2025-02-01', '{"nome": "Ana Souza", "email": "ana.s@gmail.com"}', 'MG > SP', '15x15x15', '2kg', 'R$ 30.00', 'Em Transito'),

-- Problemas de Duplicidade e Case
('TRK-001', '2025-02-01', '{"nome": "Carlos Silva", "email": "carlos@uol.com.br"}', 'SP > RJ', '10x20x30', '1.500kg', '25.00', 'ENTREGUE'),
('trk-003', '2025/02/02', '{"nome": "Beatriz", "email": "bia@site.com"}', 'BA - PE', '30x30x10', '5kg', '45,50', 'Pendente'),
('TRK-003', '02/02/2025', 'Nome: Beatriz | Email: bia@site.com', 'Salvador para Recife', '30x30x10', '5000g', 'R$ 45,50', 'PENDENTE'),

-- JSON quebrado / Texto Livre
('TRK-004', '2025.02.03', 'Cliente: João | j@empresa.com', 'RS -> SC', '20x20x20', '3kg', 'USD 10', 'Cancelado'),
('TRK-005', '03-02-2025', '{"nome": "M. Oliveira", "email": "m@oli.com"', 'PR > SP', '100x10x5', '10kg', 'U$ 15.00', 'Entregue'),
('TRK-006', 'NULL', 'Anonimo', 'AM > PA', 'null', '0.5kg', '0', 'Extraviado'),

-- Datas Ambíguas (Dia/Mes invertido) e Moedas
('TRK-007', '05/02/2025', '{"n": "Lucas", "e": "lucas@test.com"}', 'SP-RJ', '50x50x50', '20kg', '120.00', 'Devolvido'),
('TRK-007', '2025-05-02', '{"n": "Lucas", "e": "lucas@test.com"}', 'Sao Paulo - Rio de Janeiro', '50x50x50', '20.0 kg', '120,00', 'Devolvido'),

-- Dimensões e Pesos complexos
('TRK-008', '2025-02-06', '{"nome": "Fernanda", "vip": true}', 'GO > DF', '10cm x 20cm x 10cm', '500 g', 'R$ 15,90', 'Entregue'),
('TRK-009', '06/02/2025', 'Fernanda (VIP)', 'Goias para Distrito Federal', '10/20/10', '0.5 kg', '15.90', 'Entregue'),

-- Erros de Lógica e Sujeira pesada
('TRK-010', 'Invalid Date', 'N/A', '?? > SP', 'Unknown', '-5kg', 'Free', 'Erro'),
('   TRK-011 ', '2025-02-08', '{"nome": "  Roberto  "}', 'RJ>ES', '12x12x12', '1kg', 'R$ 20', 'Entregue'),
('TRK-011', '2025-02-08', 'Roberto', 'RJ > Espirito Santo', '12 x 12 x 12', '1000g', '20.00', 'Entregue'),

-- Separadores de Rota e Lixo
('TRK-012', '2025-02-09', '{"nome": "Julia"}', 'MG / RJ', '5x5x5', '0.1kg', 'R$ 9,99', 'Recebido'),
('TRK-013', '09-Fev-2025', 'Julia M.', 'Minas -> Rio', '5x5x5', '100g', '9.99', 'Recebido'),

-- Valores Altos e Formatação Americana de milhar
('TRK-014', '2025-02-10', '{"nome": "Empresa X"}', 'SP > SP', '100x100x100', '150kg', '1,500.00', 'Em Processamento'),
('TRK-015', '2025-02-10', 'Empresa X Ltda', 'SP capital > SP interior', '1m x 1m x 1m', '150000g', 'R$ 1.500,00', 'Processando'),

-- Casos de Borda (Empty strings, Null strings, NaN)
('TRK-016', '', '', '', '', '', '', ''),
('TRK-017', 'NaN', 'undefined', 'null > null', '0x0x0', 'NaN', 'NaN', 'Falha'),
('TRK-018', '2025-02-12', '{"nome": "Paulo", "obs": "Cuidado"}', 'SC > PR', '20x10x?', '2kg', 'NULL', 'Avariado');
