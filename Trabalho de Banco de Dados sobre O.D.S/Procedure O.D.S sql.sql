CREATE DATABASE IF NOT EXISTS mapa_alimenta;

USE mapa_alimenta;


CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT,
    nome VARCHAR(120),
    email VARCHAR(150),
    senha_hash VARCHAR(255),
    telefone VARCHAR(20),
    data_cadastro DATETIME,
    ativo BOOLEAN,
    PRIMARY KEY (id_usuario)
) ENGINE=InnoDB;


CREATE TABLE regioes (
    id_regiao INT AUTO_INCREMENT,
    nome VARCHAR(100),
    municipio VARCHAR(100),
    uf CHAR(2),
    zona VARCHAR(20),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    PRIMARY KEY (id_regiao)
) ENGINE=InnoDB;


CREATE TABLE alimentos (
    id_alimento INT AUTO_INCREMENT,
    nome VARCHAR(120),
    categoria VARCHAR(80),
    unidade_medida VARCHAR(20),
    perecivel BOOLEAN,
    descricao TEXT,
    PRIMARY KEY (id_alimento)
) ENGINE=InnoDB;


CREATE TABLE voluntarios (
    id_voluntario INT AUTO_INCREMENT,
    id_usuario INT,
    disponibilidade VARCHAR(150),
    regiao_atuacao INT,
    data_cadastro DATETIME,
    ativo BOOLEAN,
    PRIMARY KEY (id_voluntario),

    CONSTRAINT fk_voluntarios_usuarios
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),

    CONSTRAINT fk_voluntarios_regioes
        FOREIGN KEY (regiao_atuacao)
        REFERENCES regioes(id_regiao)
) ENGINE=InnoDB;


CREATE TABLE doadores (
    id_doador INT AUTO_INCREMENT,
    id_usuario INT,
    tipo_doador VARCHAR(20),
    nome_publico VARCHAR(120),
    PRIMARY KEY (id_doador),

    CONSTRAINT fk_doadores_usuarios
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;


CREATE TABLE ongs (
    id_ong INT AUTO_INCREMENT,
    id_regiao INT,
    nome VARCHAR(150),
    cnpj VARCHAR(18),
    email VARCHAR(150),
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    descricao TEXT,
    ativa BOOLEAN,
    PRIMARY KEY (id_ong),

    CONSTRAINT fk_ongs_regioes
        FOREIGN KEY (id_regiao)
        REFERENCES regioes(id_regiao)
) ENGINE=InnoDB;


CREATE TABLE doacoes (
    id_doacao INT AUTO_INCREMENT,
    id_doador INT,
    id_ong INT,
    data_doacao DATETIME,
    status VARCHAR(20),
    observacoes TEXT,
    PRIMARY KEY (id_doacao),

    CONSTRAINT fk_doacoes_doadores
        FOREIGN KEY (id_doador)
        REFERENCES doadores(id_doador),

    CONSTRAINT fk_doacoes_ongs
        FOREIGN KEY (id_ong)
        REFERENCES ongs(id_ong)
) ENGINE=InnoDB;


CREATE TABLE itens_doacao (
    id_item_doacao INT AUTO_INCREMENT,
    id_doacao INT,
    id_alimento INT,
    valor DECIMAL(10,2),
    data_validade DATE,
    observacoes VARCHAR(255),
    PRIMARY KEY (id_item_doacao),

    CONSTRAINT fk_itens_doacao_doacoes
        FOREIGN KEY (id_doacao)
        REFERENCES doacoes(id_doacao),

    CONSTRAINT fk_itens_doacao_alimentos
        FOREIGN KEY (id_alimento)
        REFERENCES alimentos(id_alimento)
) ENGINE=InnoDB;


CREATE TABLE entregas (
    id_entrega INT AUTO_INCREMENT,
    id_doacao INT,
    id_voluntario INT,
    endereco_entrega VARCHAR(200),
    data_agendada DATETIME,
    data_conclusao DATETIME,
    status VARCHAR(20),
    PRIMARY KEY (id_entrega),

    CONSTRAINT fk_entregas_doacoes
        FOREIGN KEY (id_doacao)
        REFERENCES doacoes(id_doacao),

    CONSTRAINT fk_entregas_voluntarios
        FOREIGN KEY (id_voluntario)
        REFERENCES voluntarios(id_voluntario)
) ENGINE=InnoDB;


CREATE TABLE indicadores_sociais (
    id_indicador INT AUTO_INCREMENT,
    id_regiao INT,
    nome VARCHAR(150),
    valor DECIMAL(14,4),
    unidade VARCHAR(40),
    periodo_referencia VARCHAR(50),
    fonte VARCHAR(255),
    url_fonte VARCHAR(500),
    data_atualizacao DATE,
    observacoes TEXT,
    PRIMARY KEY (id_indicador),

    CONSTRAINT fk_indicadores_sociais_regioes
        FOREIGN KEY (id_regiao)
        REFERENCES regioes(id_regiao)
) ENGINE=InnoDB;


CREATE TABLE iniciativas_sustentaveis (
    id_iniciativa INT AUTO_INCREMENT,
    id_regiao INT,
    nome VARCHAR(150),
    tipo VARCHAR(80),
    descricao TEXT,
    endereco VARCHAR(200),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    contato VARCHAR(150),
    ativa BOOLEAN,
    PRIMARY KEY (id_iniciativa),

    CONSTRAINT fk_iniciativas_regioes
        FOREIGN KEY (id_regiao)
        REFERENCES regioes(id_regiao)
) ENGINE=InnoDB;


INSERT INTO regioes
(nome, municipio, uf, zona, latitude, longitude)
VALUES
('Itaquera', 'Sao Paulo', 'SP', 'Leste', -23.5400, -46.4550),
('Tatuape', 'Sao Paulo', 'SP', 'Leste', -23.5408, -46.5760),
('Penha', 'Sao Paulo', 'SP', 'Leste', -23.5230, -46.5420),
('Sao Mateus', 'Sao Paulo', 'SP', 'Leste', -23.6000, -46.4800),
('Guaianases', 'Sao Paulo', 'SP', 'Leste', -23.5500, -46.4100),
('Itaim Paulista', 'Sao Paulo', 'SP', 'Leste', -23.5000, -46.4000),
('Cidade Tiradentes', 'Sao Paulo', 'SP', 'Leste', -23.5900, -46.4100),
('Santana', 'Sao Paulo', 'SP', 'Norte', -23.5000, -46.6250),
('Tucuruvi', 'Sao Paulo', 'SP', 'Norte', -23.4800, -46.6000),
('Casa Verde', 'Sao Paulo', 'SP', 'Norte', -23.5100, -46.6600),
('Vila Maria', 'Sao Paulo', 'SP', 'Norte', -23.5100, -46.5850),
('Santo Amaro', 'Sao Paulo', 'SP', 'Sul', -23.6528, -46.7130),
('Grajaú', 'Sao Paulo', 'SP', 'Sul', -23.7300, -46.6900),
('Capao Redondo', 'Sao Paulo', 'SP', 'Sul', -23.6700, -46.7800),
('Campo Limpo', 'Sao Paulo', 'SP', 'Sul', -23.6300, -46.7600),
('Jabaquara', 'Sao Paulo', 'SP', 'Sul', -23.6470, -46.6420),
('Pinheiros', 'Sao Paulo', 'SP', 'Oeste', -23.5614, -46.7017),
('Lapa', 'Sao Paulo', 'SP', 'Oeste', -23.5220, -46.7050),
('Butanta', 'Sao Paulo', 'SP', 'Oeste', -23.5700, -46.7200),
('Perdizes', 'Sao Paulo', 'SP', 'Oeste', -23.5350, -46.6750),
('Se', 'Sao Paulo', 'SP', 'Centro', -23.5505, -46.6333),
('Republica', 'Sao Paulo', 'SP', 'Centro', -23.5430, -46.6420),
('Bela Vista', 'Sao Paulo', 'SP', 'Centro', -23.5620, -46.6460);


DELIMITER //


CREATE PROCEDURE cadastrar_usuario(
    IN p_nome VARCHAR(120),
    IN p_email VARCHAR(150),
    IN p_senha_hash VARCHAR(255),
    IN p_telefone VARCHAR(20)
)
BEGIN
    INSERT INTO usuarios
    (nome, email, senha_hash, telefone, data_cadastro, ativo)
    VALUES
    (p_nome, p_email, p_senha_hash, p_telefone, NOW(), TRUE);
END //


CREATE PROCEDURE cadastrar_voluntario(
    IN p_id_usuario INT,
    IN p_disponibilidade VARCHAR(150),
    IN p_regiao_atuacao INT
)
BEGIN
    INSERT INTO voluntarios
    (id_usuario, disponibilidade, regiao_atuacao,
     data_cadastro, ativo)
    VALUES
    (p_id_usuario, p_disponibilidade, p_regiao_atuacao,
     NOW(), TRUE);
END //


CREATE PROCEDURE cadastrar_doador(
    IN p_id_usuario INT,
    IN p_tipo_doador VARCHAR(20),
    IN p_nome_publico VARCHAR(120)
)
BEGIN
    INSERT INTO doadores
    (id_usuario, tipo_doador, nome_publico)
    VALUES
    (p_id_usuario, p_tipo_doador, p_nome_publico);
END //


CREATE PROCEDURE cadastrar_ong(
    IN p_id_regiao INT,
    IN p_nome VARCHAR(150),
    IN p_cnpj VARCHAR(18),
    IN p_email VARCHAR(150),
    IN p_telefone VARCHAR(20),
    IN p_endereco VARCHAR(200),
    IN p_descricao TEXT
)
BEGIN
    INSERT INTO ongs
    (id_regiao, nome, cnpj, email, telefone,
     endereco, descricao, ativa)
    VALUES
    (p_id_regiao, p_nome, p_cnpj, p_email,
     p_telefone, p_endereco, p_descricao, TRUE);
END //


CREATE PROCEDURE cadastrar_alimento(
    IN p_nome VARCHAR(120),
    IN p_categoria VARCHAR(80),
    IN p_unidade_medida VARCHAR(20),
    IN p_perecivel BOOLEAN,
    IN p_descricao TEXT
)
BEGIN
    INSERT INTO alimentos
    (nome, categoria, unidade_medida, perecivel, descricao)
    VALUES
    (p_nome, p_categoria, p_unidade_medida,
     p_perecivel, p_descricao);
END //


CREATE PROCEDURE registrar_doacao(
    IN p_id_doador INT,
    IN p_id_ong INT,
    IN p_observacoes TEXT
)
BEGIN
    INSERT INTO doacoes
    (id_doador, id_ong, data_doacao, status, observacoes)
    VALUES
    (p_id_doador, p_id_ong, NOW(), 'Pendente', p_observacoes);
END //


CREATE PROCEDURE adicionar_item_doacao(
    IN p_id_doacao INT,
    IN p_id_alimento INT,
    IN p_valor DECIMAL(10,2),
    IN p_data_validade DATE,
    IN p_observacoes VARCHAR(255)
)
BEGIN
    INSERT INTO itens_doacao
    (id_doacao, id_alimento, valor,
     data_validade, observacoes)
    VALUES
    (p_id_doacao, p_id_alimento, p_valor,
     p_data_validade, p_observacoes);
END //


CREATE PROCEDURE agendar_entrega(
    IN p_id_doacao INT,
    IN p_id_voluntario INT,
    IN p_endereco_entrega VARCHAR(200),
    IN p_data_agendada DATETIME
)
BEGIN
    INSERT INTO entregas
    (id_doacao, id_voluntario, endereco_entrega,
     data_agendada, status)
    VALUES
    (p_id_doacao, p_id_voluntario, p_endereco_entrega,
     p_data_agendada, 'Agendada');
END //


CREATE PROCEDURE consultar_bairros_zona(
    IN p_zona VARCHAR(20)
)
BEGIN
    SELECT
        id_regiao,
        nome AS bairro,
        municipio,
        uf,
        zona,
        latitude,
        longitude
    FROM regioes
    WHERE zona = p_zona
    ORDER BY nome;
END //


CREATE PROCEDURE consultar_doacoes_ong(
    IN p_id_ong INT
)
BEGIN
    SELECT
        d.id_doacao,
        o.nome AS ong,
        doad.nome_publico AS doador,
        d.data_doacao,
        d.status,
        d.observacoes
    FROM doacoes d
    INNER JOIN ongs o
        ON d.id_ong = o.id_ong
    INNER JOIN doadores doad
        ON d.id_doador = doad.id_doador
    WHERE d.id_ong = p_id_ong;
END //


CREATE PROCEDURE consultar_entregas_voluntario(
    IN p_id_voluntario INT
)
BEGIN
    SELECT
        e.id_entrega,
        u.nome AS voluntario,
        e.endereco_entrega,
        e.data_agendada,
        e.data_conclusao,
        e.status
    FROM entregas e
    INNER JOIN voluntarios v
        ON e.id_voluntario = v.id_voluntario
    INNER JOIN usuarios u
        ON v.id_usuario = u.id_usuario
    WHERE e.id_voluntario = p_id_voluntario;
END //


CREATE PROCEDURE consultar_indicadores_bairro(
    IN p_id_regiao INT
)
BEGIN
    SELECT
        r.nome AS bairro,
        r.zona,
        i.nome AS indicador,
        i.valor,
        i.unidade,
        i.periodo_referencia,
        i.fonte,
        i.data_atualizacao
    FROM indicadores_sociais i
    INNER JOIN regioes r
        ON i.id_regiao = r.id_regiao
    WHERE i.id_regiao = p_id_regiao;
END //


CREATE PROCEDURE consultar_iniciativas_zona(
    IN p_zona VARCHAR(20)
)
BEGIN
    SELECT
        i.id_iniciativa,
        i.nome AS iniciativa,
        i.tipo,
        i.descricao,
        i.endereco,
        i.contato,
        r.nome AS bairro,
        r.zona
    FROM iniciativas_sustentaveis i
    INNER JOIN regioes r
        ON i.id_regiao = r.id_regiao
    WHERE r.zona = p_zona
    AND i.ativa = TRUE;
END //


DELIMITER ;


SHOW TABLES;

DESCRIBE usuarios;
DESCRIBE voluntarios;
DESCRIBE doadores;
DESCRIBE doacoes;
DESCRIBE entregas;
DESCRIBE itens_doacao;
DESCRIBE alimentos;
DESCRIBE ongs;
DESCRIBE regioes;
DESCRIBE indicadores_sociais;
DESCRIBE iniciativas_sustentaveis;


SELECT
    id_regiao,
    nome AS bairro,
    municipio,
    uf,
    zona
FROM regioes
ORDER BY zona, nome;


SELECT
    zona,
    COUNT(*) AS total_bairros
FROM regioes
GROUP BY zona;


SELECT
    o.nome AS ong,
    r.nome AS bairro,
    r.zona,
    o.telefone
FROM ongs o
INNER JOIN regioes r
    ON o.id_regiao = r.id_regiao;


SELECT
    d.id_doacao,
    doad.nome_publico AS doador,
    o.nome AS ong,
    d.data_doacao,
    d.status
FROM doacoes d
INNER JOIN doadores doad
    ON d.id_doador = doad.id_doador
INNER JOIN ongs o
    ON d.id_ong = o.id_ong;


SELECT
    e.id_entrega,
    u.nome AS voluntario,
    e.endereco_entrega,
    e.data_agendada,
    e.data_conclusao,
    e.status
FROM entregas e
INNER JOIN voluntarios v
    ON e.id_voluntario = v.id_voluntario
INNER JOIN usuarios u
    ON v.id_usuario = u.id_usuario;


SHOW PROCEDURE STATUS
WHERE Db = 'mapa_alimenta';


CALL consultar_bairros_zona('Leste');

CALL consultar_bairros_zona('Norte');

CALL consultar_bairros_zona('Sul');

CALL consultar_bairros_zona('Oeste');

CALL consultar_bairros_zona('Centro');