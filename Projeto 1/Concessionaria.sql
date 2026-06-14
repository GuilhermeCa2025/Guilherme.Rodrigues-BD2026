CREATE DATABASE concessionaria;
use concessionaria;

CREATE TABLE cliente (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    cnh VARCHAR(15) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(30) NOT NULL,
    estado VARCHAR(20),
    placa VARCHAR(15) UNIQUE NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    cor VARCHAR(20),
    ano_fabricacao INT,
    quilometragem INT NOT NULL DEFAULT 0
);

CREATE TABLE pagamento (
    id_pag INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    cpf_cliente VARCHAR(14),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE devolucao (
    id_devolucao INT AUTO_INCREMENT PRIMARY KEY,
    data_devolucao_real DATETIME NOT NULL,
    km_final INT NOT NULL,
    danos_ident VARCHAR(250),
    valor_adic DECIMAL(10,2) DEFAULT 0.00,
    cpf_cliente VARCHAR(14),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE SET NULL
);

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    data_res DATE NOT NULL,
    data_retirada_prevista DATE NOT NULL,
    data_devolucao_prevista DATE NOT NULL,
    status_reserva VARCHAR(20) DEFAULT 'Pendente',
    id_veiculo INT,
    cpf_cliente VARCHAR(14),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo) ON DELETE CASCADE,
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE contrato (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    da_retirada DATETIME NOT NULL,
    da_devolucao_prevista DATETIME NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    tipo_seguro VARCHAR(50),
    cpf_cliente VARCHAR(14),
    id_veiculo INT,
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE RESTRICT,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo) ON DELETE RESTRICT
);

CREATE TABLE manutencao (
    id_manutencao INT AUTO_INCREMENT PRIMARY KEY,
    data_manutencao DATE NOT NULL,
    desc_manutencao VARCHAR(250) NOT NULL,
    custo DECIMAL(10,2) DEFAULT 0.00,
    id_veiculo INT,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo) ON DELETE CASCADE
);

CREATE TABLE multa (
    id_multa INT AUTO_INCREMENT PRIMARY KEY,
    desc_multa VARCHAR(250) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    id_veiculo INT,
    id_contrato INT,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo) ON DELETE CASCADE,
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato) ON DELETE CASCADE
);

INSERT INTO cliente (cpf, nome, telefone, cnh, data_nascimento, email) VALUES
('595.669.756-78', 'Ana Silva', '(11) 97793-1383', '46685474635', '1998-05-18', 'anasilva@email.com'),
('698.815.772-23', 'Bruno Santos', '(11) 98319-5835', '85547936733', '1997-09-08', 'brunosantos@email.com'),
('535.590.231-13', 'Carlos Oliveira', '(11) 98013-6497', '57467389146', '1979-05-19', 'carlosoliveira@email.com'),
('146.126.975-29', 'Daniela Souza', '(11) 96316-2487', '73516597752', '1999-10-09', 'danielasouza@email.com'),
('866.529.230-68', 'Eduardo Pereira', '(11) 97576-9045', '11880456170', '1970-07-28', 'eduardopereira@email.com'),
('649.332.222-68', 'Fernanda Lima', '(11) 98660-8433', '26651817452', '1976-11-09', 'fernandalima@email.com'),
('563.818.175-10', 'Gabriel Costa', '(11) 97395-5026', '69339247657', '1990-10-14', 'gabrielcosta@email.com'),
('542.756.961-12', 'Helena Rodrigues', '(11) 96174-8848', '33433878413', '1977-10-18', 'helenarodrigues@email.com'),
('625.591.353-83', 'Igor Almeida', '(11) 99347-1981', '74423405390', '1988-06-25', 'igoralmeida@email.com'),
('813.568.966-31', 'Juliana Ribeiro', '(11) 96879-1300', '14061619623', '1987-12-14', 'julianaribeiro@email.com'),
('617.915.228-44', 'Lucas Carvalho', '(11) 96602-5369', '38249080649', '1986-07-23', 'lucascarvalho@email.com'),
('622.385.495-20', 'Mariana Gomes', '(11) 97793-1996', '34484082697', '1982-10-17', 'marianagomes@email.com');

INSERT INTO veiculo (id_veiculo, categoria, estado, placa, modelo, cor, ano_fabricacao, quilometragem) VALUES
(1, 'Hatch', 'Em Manutencao', 'OMN6X67', 'Fiat Uno', 'Prata', 2021, 52125),
(2, 'Hatch', 'Alugado', 'KOB0G60', 'Chevrolet Onix', 'Cinza', 2024, 18561),
(3, 'Hatch', 'Disponivel', 'SRQ5S78', 'Hyundai HB20', 'Branco', 2022, 107384),
(4, 'Sedan', 'Disponivel', 'WVY2D73', 'Toyota Corolla', 'Preto', 2021, 101416),
(5, 'Sedan', 'Alugado', 'ZPN9L12', 'Honda Civic', 'Cinza', 2020, 24869),
(6, 'SUV', 'Em Manutencao', 'LYL9V01', 'Jeep Compass', 'Vermelho', 2018, 93699),
(7, 'SUV', 'Alugado', 'RUM4F70', 'Volkswagen T-Cross', 'Azul', 2018, 99220),
(8, 'Subcompacto', 'Alugado', 'SST5J85', 'Renault Kwid', 'Prata', 2022, 60611),
(9, 'Hatch', 'Alugado', 'DUB2M79', 'Ford Ka', 'Cinza', 2022, 94056),
(10, 'SUV', 'Disponivel', 'WUR2G05', 'Nissan Kicks', 'Prata', 2024, 73523),
(11, 'Hatch', 'Em Manutencao', 'KEX0O40', 'Fiat Uno', 'Preto', 2021, 114400),
(12, 'Hatch', 'Disponivel', 'AXF4K41', 'Chevrolet Onix', 'Vermelho', 2019, 93902);

INSERT INTO pagamento (id_pag, status, valor, cpf_cliente) VALUES
(1, 'Cancelado', 413.78, '595.669.756-78'),
(2, 'Cancelado', 985.34, '698.815.772-23'),
(3, 'Pendente', 376.67, '535.590.231-13'),
(4, 'Pago', 872.23, '146.126.975-29'),
(5, 'Pago', 1104.99, '866.529.230-68'),
(6, 'Cancelado', 712.91, '649.332.222-68'),
(7, 'Pago', 1195.95, '563.818.175-10'),
(8, 'Pago', 1335.79, '542.756.961-12'),
(9, 'Pendente', 206.87, '625.591.353-83'),
(10, 'Pago', 545.92, '813.568.966-31'),
(11, 'Cancelado', 1045.08, '617.915.228-44'),
(12, 'Pendente', 315.65, '622.385.495-20');

INSERT INTO devolucao (id_devolucao, data_devolucao_real, km_final, danos_ident, valor_adic, cpf_cliente) VALUES
(1, '2026-05-02 18:31:00', 85521, 'Risco leve na porta', 231.29, '595.669.756-78'),
(2, '2026-05-19 12:47:00', 104719, 'Sem danos', 0.00, '698.815.772-23'),
(3, '2026-05-23 18:03:00', 83789, 'Sem danos', 0.00, '535.590.231-13'),
(4, '2026-05-28 08:34:00', 117865, 'Sem danos', 0.00, '146.126.975-29'),
(5, '2026-05-24 16:03:00', 133480, 'Pequeno amasso no parachoque', 222.10, '866.529.230-68'),
(6, '2026-05-03 14:14:00', 80894, 'Sem danos', 0.00, '649.332.222-68'),
(7, '2026-05-15 17:35:00', 140590, 'Sem danos', 0.00, '563.818.175-10'),
(8, '2026-05-06 09:37:00', 92794, 'Sem danos', 0.00, '542.756.961-12'),
(9, '2026-05-18 10:14:00', 137330, 'Risco leve na porta', 320.14, '625.591.353-83'),
(10, '2026-05-10 16:03:00', 117769, 'Sem danos', 0.00, '813.568.966-31'),
(11, '2026-05-17 10:48:00', 90449, 'Sem danos', 0.00, '617.915.228-44'),
(12, '2026-05-05 13:00:00', 110696, 'Risco leve na porta', 28.32, '622.385.495-20');

INSERT INTO reserva (id_reserva, data_res, data_retirada_prevista, data_devolucao_prevista, status_reserva, id_veiculo, cpf_cliente) VALUES
(1, '2026-04-03', '2026-04-11', '2026-04-20', 'Pendente', 1, '595.669.756-78'),
(2, '2026-04-04', '2026-04-15', '2026-04-16', 'Pendente', 2, '698.815.772-23'),
(3, '2026-04-06', '2026-04-13', '2026-04-24', 'Pendente', 3, '535.590.231-13'),
(4, '2026-04-07', '2026-04-11', '2026-04-23', 'Confirmada', 4, '146.126.975-29'),
(5, '2026-04-04', '2026-04-14', '2026-04-17', 'Cancelada', 5, '866.529.230-68'),
(6, '2026-04-04', '2026-04-11', '2026-04-17', 'Cancelada', 6, '649.332.222-68'),
(7, '2026-04-08', '2026-04-14', '2026-04-23', 'Cancelada', 7, '563.818.175-10'),
(8, '2026-04-02', '2026-04-15', '2026-04-23', 'Pendente', 8, '542.756.961-12'),
(9, '2026-04-02', '2026-04-13', '2026-04-25', 'Confirmada', 9, '625.591.353-83'),
(10, '2026-04-01', '2026-04-11', '2026-04-16', 'Confirmada', 10, '813.568.966-31'),
(11, '2026-04-06', '2026-04-12', '2026-04-16', 'Confirmada', 11, '617.915.228-44'),
(12, '2026-04-07', '2026-04-11', '2026-04-17', 'Confirmada', 12, '622.385.495-20');

INSERT INTO contrato (id_contrato, da_retirada, da_devolucao_prevista, valor_diaria, tipo_seguro, cpf_cliente, id_veiculo) VALUES
(1, '2026-05-09 10:00:00', '2026-05-18 15:00:00', 211.39, 'Completo', '595.669.756-78', 1),
(2, '2026-05-06 09:00:00', '2026-05-20 18:00:00', 204.38, 'Premium', '698.815.772-23', 2),
(3, '2026-05-09 11:00:00', '2026-05-18 16:00:00', 242.06, 'Sem Seguro', '535.590.231-13', 3),
(4, '2026-05-02 09:00:00', '2026-05-18 15:00:00', 169.57, 'Basico', '146.126.975-29', 4),
(5, '2026-05-02 09:00:00', '2026-05-20 17:00:00', 198.82, 'Sem Seguro', '866.529.230-68', 5),
(6, '2026-05-08 11:00:00', '2026-05-14 17:00:00', 202.93, 'Sem Seguro', '649.332.222-68', 6),
(7, '2026-05-06 12:00:00', '2026-05-14 17:00:00', 170.85, 'Premium', '563.818.175-10', 7),
(8, '2026-05-07 10:00:00', '2026-05-11 15:00:00', 170.38, 'Premium', '542.756.961-12', 8),
(9, '2026-05-03 08:00:00', '2026-05-11 14:00:00', 205.80, 'Basico', '625.591.353-83', 9),
(10, '2026-05-09 11:00:00', '2026-05-12 17:00:00', 151.78, 'Premium', '813.568.966-31', 10),
(11, '2026-05-02 11:00:00', '2026-05-12 16:00:00', 142.34, 'Premium', '617.915.228-44', 11),
(12, '2026-05-09 10:00:00', '2026-05-20 16:00:00', 133.09, 'Sem Seguro', '622.385.495-20', 12);

INSERT INTO manutencao (id_manutencao, data_manutencao, desc_manutencao, custo, id_veiculo) VALUES
(1, '2026-03-20', 'Troca de oleo e filtro', 64.91, 1),
(2, '2026-03-12', 'Alinhamento e balanceamento', 448.33, 2),
(3, '2026-03-08', 'Troca de oleo e filtro', 53.64, 3),
(4, '2026-03-19', 'Revisao dos 40k km', 396.93, 4),
(5, '2026-03-15', 'Substituicao de lampada queimada', 438.40, 5),
(6, '2026-03-07', 'Alinhamento e balanceamento', 179.37, 6),
(7, '2026-03-25', 'Alinhamento e balanceamento', 125.75, 7),
(8, '2026-03-18', 'Troca das pastilhas de freio', 555.27, 8),
(9, '2026-03-14', 'Troca das pastilhas de freio', 287.52, 9),
(10, '2026-03-15', 'Revisao dos 40k km', 407.87, 10),
(11, '2026-03-11', 'Revisao dos 40k km', 670.36, 11),
(12, '2026-03-27', 'Troca das pastilhas de freio', 594.13, 12);

INSERT INTO multa (id_multa, desc_multa, valor, id_veiculo, id_contrato) VALUES
(1, 'Excesso de velocidade (ate 20%)', 130.16, 1, 1),
(2, 'Estacionamento proibido', 130.16, 2, 2),
(3, 'Excesso de velocidade (ate 20%)', 130.16, 3, 3),
(4, 'Avanco de sinal vermelho', 293.47, 4, 4),
(5, 'Excesso de velocidade (20% a 50%)', 195.23, 5, 5),
(6, 'Excesso de velocidade (ate 20%)', 130.16, 6, 6),
(7, 'Excesso de velocidade (ate 20%)', 195.23, 7, 7),
(8, 'Avanco de sinal vermelho', 293.47, 8, 8),
(9, 'Excesso de velocidade (ate 20%)', 130.16, 9, 9),
(10, 'Excesso de velocidade (ate 20%)', 130.16, 10, 10),
(11, 'Excesso de velocidade (20% a 50%)', 195.23, 11, 11),
(12, 'Estacionamento proibido', 130.16, 12, 12);