drop database if exists sistema_veiculos;
CREATE DATABASE IF NOT EXISTS sistema_veiculos;
USE sistema_veiculos;

-- 1. Tabela Empresa
CREATE TABLE Empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,
    endereco VARCHAR(40),
    email VARCHAR(50),
    telefone VARCHAR(20)
);

-- 2. Tabela Cliente (Adicionei o CPF para as tabelas abaixo funcionarem)
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) NOT NULL UNIQUE, -- Essencial para as chaves estrangeiras abaixo
    nome VARCHAR(40) NOT NULL,
    email VARCHAR(50),
    endereco VARCHAR(40),
    idade INT -- Alterado para INT, pois idade é um número
);

-- 3. Tabela Veiculos
CREATE TABLE Veiculos (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_empresa INT,
    valor DECIMAL(10, 2),
    quilometragem DECIMAL(10, 2),
    CONSTRAINT fk_veiculo_empresa FOREIGN KEY (id_empresa) REFERENCES Empresa(id_empresa)
);

-- 4. Tabela Contrato
CREATE TABLE Contrato (
    id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_veiculo INT,
    data_devolucao DATE, -- Alterado para DATE para permitir cálculos de data
    valor DECIMAL(10, 2),
    quilometragem_inicial DECIMAL(10, 2),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_contrato_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo)
);

-- 5. Tabela Manutenção
CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT,
    id_cliente INT,
    id_contrato INT,
    valor DECIMAL(10, 2),
    tipo_manutencao VARCHAR(20),
    CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_manutencao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_manutencao_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);

-- 6. Tabela Multa (Corrigido nomes de tabelas e acentos)
CREATE TABLE multa (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    desc_multa VARCHAR(50),
    id_veiculo INT,
    id_contrato INT,
    valor_multa DECIMAL(10,2),
    CONSTRAINT fk_multa_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_multa_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);

-- 7. Tabela Reserva
CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    data_res DATE,
    id_veiculo INT,
    id_cliente INT, -- Alterado de CPF para id_cliente para manter o padrão de integridade
    CONSTRAINT fk_reserva_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- 8. Tabela Pagamento
CREATE TABLE pagamento (
    id_pag INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20),
    valor DECIMAL(10,2),
    id_cliente INT,
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- 9. Tabela Devolução (Removido acento do nome da tabela)
CREATE TABLE devolucao (
    id_devolucao INT PRIMARY KEY AUTO_INCREMENT,
    km_final VARCHAR(20),
    danos_ident VARCHAR(50),
    valor_adic DECIMAL(10,2),
    id_cliente INT,
    CONSTRAINT fk_devolucao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

INSERT INTO Cliente ( nome, cpf, email , endereco, idade) VALUES 
('Ricardo Silva' ,  '472910338-25'  , 'ricardo.silva88@gmail.com'  ,'Rua das Palmeiras-450',34),
('Beatriz Souza' ,  '159004672-11'  , 'bia.souza.dev@gmail.com'    ,'Av. Paulista-1500' ,28),
('Carlos Eduardo', '833125490-44'   , 'cadu.vendas@gmail.com'      ,'Rua Amazonas-22',42),
('Mariana Costa' ,  '02874196308'   , 'mari.costa.cine@gmail.com'  ,'Travessa do Sol-98',21),
('Lucas Oliveira', '65539211897'	, 'lucas.oliveira.ti@gmail.com','Alameda Santos-310',37),
('Juliana Martins', '111222333-44', 'juliana@email.com', 'Rua A-10', 29),
('Pedro Henrique', '222333444-55', 'pedro@email.com', 'Rua B-20', 35),
('Camila Rocha', '333444555-66', 'camila@email.com', 'Rua C-30', 26),
('André Luiz', '444555666-77', 'andre@email.com', 'Rua D-40', 40),
('Patricia Gomes', '555666777-88', 'patricia@email.com', 'Rua E-50', 31),
('Rodrigo Alves', '666777888-99', 'rodrigo@email.com', 'Rua F-60', 38),
('Aline Ferreira', '777888999-00', 'aline@email.com', 'Rua G-70', 27),
('Bruno Castro', '888999000-11', 'bruno@email.com', 'Rua H-80', 33),
('Daniela Ribeiro', '999000111-22', 'daniela@email.com', 'Rua I-90', 24),
('Felipe Santos', '000111222-33', 'felipe@email.com', 'Rua J-100', 36);
Select * from Cliente;

INSERT INTO Empresa ( nome,endereco,email,telefone) VALUES
('LocaDrive Brasil', 'Av. das Nações, 1010', 'contato@locadrive.com.br', '(11) 3344-5566'),
('RentCar Express', 'Rua Chile, 250', 'sac@rentcarexpress.com', '(21) 98877-6655'),
('Velocità Alugueis', 'Rodovia Santos Dumont, s/n', 'faturamento@velocita.it', '(19) 3251-4000'),
('Elite Prime Motors', 'Alameda Jauaperi, 45', 'reservas@eliteprime.com.br', '(11) 5051-2233'),
('EcoMove Sustentável', 'Av. Beira Mar, 500', 'administrativo@ecomove.eco.br', '(48) 3222-1100'),
('AutoFlex', 'Rua 1', 'auto@flex.com', '1111-1111'),
('CarMax', 'Rua 2', 'car@max.com', '2222-2222'),
('DriveNow', 'Rua 3', 'drive@now.com', '3333-3333'),
('FastCar', 'Rua 4', 'fast@car.com', '4444-4444'),
('MegaRent', 'Rua 5', 'mega@rent.com', '5555-5555'),
('TopDrive', 'Rua 6', 'top@drive.com', '6666-6666'),
('UrbanCar', 'Rua 7', 'urban@car.com', '7777-7777'),
('GoRent', 'Rua 8', 'go@rent.com', '8888-8888'),
('PrimeAuto', 'Rua 9', 'prime@auto.com', '9999-9999'),
('FlexMove', 'Rua 10', 'flex@move.com', '1010-1010');
Select * from Empresa;


INSERT INTO Veiculos (id_empresa, valor, quilometragem) VALUES
(1, 55000.00, 15200.50),
(2, 72400.00, 8340.00),
(3, 145000.00, 45000.00),
(4, 180000.00, 2100.25),
(5, 149800.00, 500.00),
(6, 80000, 10000),
(7, 90000, 20000),
(8, 75000, 15000),
(9, 120000, 5000),
(10, 110000, 8000),
(11, 95000, 12000),
(12, 70000, 30000),
(13, 130000, 4000),
(14, 85000, 22000),
(15, 99000, 16000);

select * from Veiculos;


INSERT INTO Contrato (id_cliente, id_veiculo, data_devolucao, valor, quilometragem_inicial) VALUES 
(1, 1, '2024-06-15 09:00:00', 1200.00, 15200.50),
(2, 3, '2024-06-20 09:00:00', 3500.00, 45000.00),
(3, 2, '2024-06-12 09:00:00', 950.00, 8340.00),
(4, 5, '2024-07-01 09:00:00', 4200.00, 500.00),
(5, 4, '2024-06-18 09:00:00', 5800.00, 2100.25),
(6, 6, '2024-07-01', 2000, 10000),
(7, 7, '2024-07-02', 2100, 20000),
(8, 8, '2024-07-03', 1800, 15000),
(9, 9, '2024-07-04', 3000, 5000),
(10, 10, '2024-07-05', 2800, 8000),
(11, 11, '2024-07-06', 2200, 12000),
(12, 12, '2024-07-07', 1700, 30000),
(13, 13, '2024-07-08', 3200, 4000),
(14, 14, '2024-07-09', 2100, 22000),
(15, 15, '2024-07-10', 2500, 16000);
select * from Contrato;

INSERT INTO Manutencao (id_veiculo, id_cliente, id_contrato, valor, tipo_manutencao) VALUES
(1, 1, 1, 150.00, 'Troca de Óleo'),
(3, 2, 2, 450.00, 'Alinhamento'),
(5, 4, 4, 1200.00, 'Troca de Pneus'),
(6, 6, 6, 200, 'Óleo'),
(7, 7, 7, 300, 'Freio'),
(8, 8, 8, 250, 'Pneu'),
(9, 9, 9, 400, 'Motor'),
(10, 10, 10, 350, 'Revisão'),
(11, 11, 11, 200, 'Óleo'),
(12, 12, 12, 300, 'Freio'),
(13, 13, 13, 450, 'Motor'),
(14, 14, 14, 280, 'Pneu'),
(15, 15, 15, 320, 'Revisão');
select * from Manutencao;

INSERT INTO multa (desc_multa, id_veiculo, id_contrato, valor_multa) VALUES
('Excesso de Velocidade', 1, 1, 293.47),
('Estacionamento Irregular', 3, 2, 130.16),
('Avanço de Sinal Vermelho', 2, 3, 293.47),
('Velocidade', 6, 6, 200),
('Sinal', 7, 7, 300),
('Estacionamento', 8, 8, 150),
('Celular', 9, 9, 250),
('Velocidade', 10, 10, 200),
('Sinal', 11, 11, 300),
('Estacionamento', 12, 12, 150),
('Celular', 13, 13, 250),
('Velocidade', 14, 14, 200),
('Sinal', 15, 15, 300);
select * from multa;

INSERT INTO reserva (data_res, id_veiculo, id_cliente) VALUES
('2024-08-10', 2, 1),
('2024-08-12', 4, 3),
('2024-08-15', 1, 5),
('2024-08-01', 6, 6),
('2024-08-02', 7, 7),
('2024-08-03', 8, 8),
('2024-08-04', 9, 9),
('2024-08-05', 10, 10),
('2024-08-06', 11, 11),
('2024-08-07', 12, 12),
('2024-08-08', 13, 13),
('2024-08-09', 14, 14),
('2024-08-10', 15, 15);
select * from reserva;

INSERT INTO pagamento (estado, valor, id_cliente) VALUES
('Pago', 1200.00, 1),
('Pendente', 3500.00, 2),
('Pago', 950.00, 3),
('Processando', 4200.00, 4),
('Pago', 5800.00, 5),
('Pago', 2000, 6),
('Pendente', 2100, 7),
('Pago', 1800, 8),
('Pago', 3000, 9),
('Pendente', 2800, 10),
('Pago', 2200, 11),
('Pago', 1700, 12),
('Processando', 3200, 13),
('Pago', 2100, 14),
('Pago', 2500, 15);
select * from pagamento;

INSERT INTO devolucao (km_final, danos_ident, valor_adic, id_cliente) VALUES
('15450.50', 'Nenhum', 0.00, 1),
('45800.00', 'Arranhão porta direita', 250.00, 2),
('8600.00', 'Nenhum', 0.00, 3),
('1200.00', 'Limpeza pesada necessária', 80.00, 4),
('2500.25', 'Nenhum', 0.00, 5),
('10200', 'Nenhum', 0, 6),
('20500', 'Arranhão', 100, 7),
('15200', 'Nenhum', 0, 8),
('5500', 'Amassado', 300, 9),
('8200', 'Nenhum', 0, 10),
('12500', 'Nenhum', 0, 11),
('30500', 'Arranhão', 150, 12),
('4500', 'Nenhum', 0, 13),
('22500', 'Nenhum', 0, 14),
('16500', 'Limpeza', 80, 15);
select * from devolucao;
