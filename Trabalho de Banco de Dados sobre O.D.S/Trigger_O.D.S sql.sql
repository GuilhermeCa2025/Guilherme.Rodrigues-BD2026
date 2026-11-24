CREATE DATABASE IF NOT EXISTS mapa_alimenta
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE mapa_alimenta;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE regioes (
    id_regiao INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    zona VARCHAR(20),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7)
) ENGINE=InnoDB;

CREATE TABLE alimentos (
    id_alimento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    unidade_medida VARCHAR(20) NOT NULL,
    perecivel BOOLEAN NOT NULL DEFAULT TRUE,
    descricao TEXT
) ENGINE=InnoDB;

CREATE TABLE voluntarios (
    id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    disponibilidade VARCHAR(150),
    regiao_atuacao INT,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_voluntarios_usuarios
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_voluntarios_regioes
        FOREIGN KEY (regiao_atuacao)
        REFERENCES regioes(id_regiao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE doadores (
    id_doador INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    tipo_doador VARCHAR(20) NOT NULL,
    nome_publico VARCHAR(120),

    CONSTRAINT chk_tipo_doador
        CHECK (tipo_doador IN ('Pessoa fisica', 'Empresa')),

    CONSTRAINT fk_doadores_usuarios
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE ongs (
    id_ong INT AUTO_INCREMENT PRIMARY KEY,
    id_regiao INT,
    nome VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    email VARCHAR(150),
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    descricao TEXT,
    ativa BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_ongs_regioes
        FOREIGN KEY (id_regiao)
        REFERENCES regioes(id_regiao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE doacoes (
    id_doacao INT AUTO_INCREMENT PRIMARY KEY,
    id_doador INT NOT NULL,
    id_ong INT,
    data_doacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Disponivel',
    observacoes TEXT,

    CONSTRAINT chk_status_doacao
        CHECK (status IN (
            'Disponivel',
            'Aceita',
            'Coletada',
            'Entregue',
            'Cancelada'
        )),

    CONSTRAINT fk_doacoes_doadores
        FOREIGN KEY (id_doador)
        REFERENCES doadores(id_doador)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_doacoes_ongs
        FOREIGN KEY (id_ong)
        REFERENCES ongs(id_ong)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE itens_doacao (
    id_item_doacao INT AUTO_INCREMENT PRIMARY KEY,
    id_doacao INT NOT NULL,
    id_alimento INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    data_validade DATE,
    observacoes VARCHAR(255),

    CONSTRAINT chk_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT fk_itens_doacao_doacoes
        FOREIGN KEY (id_doacao)
        REFERENCES doacoes(id_doacao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_itens_doacao_alimentos
        FOREIGN KEY (id_alimento)
        REFERENCES alimentos(id_alimento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE entregas (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_doacao INT NOT NULL UNIQUE,
    id_voluntario INT,
    endereco_entrega VARCHAR(200) NOT NULL,
    data_agendada DATETIME,
    data_conclusao DATETIME,
    status VARCHAR(20) NOT NULL DEFAULT 'Pendente',

    CONSTRAINT chk_status_entrega
        CHECK (status IN (
            'Pendente',
            'Agendada',
            'Em andamento',
            'Concluida',
            'Cancelada'
        )),

    CONSTRAINT fk_entregas_doacoes
        FOREIGN KEY (id_doacao)
        REFERENCES doacoes(id_doacao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_entregas_voluntarios
        FOREIGN KEY (id_voluntario)
        REFERENCES voluntarios(id_voluntario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE indicadores_sociais (
    id_indicador INT AUTO_INCREMENT PRIMARY KEY,
    id_regiao INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    valor DECIMAL(14,4),
    unidade VARCHAR(40),
    periodo_referencia VARCHAR(50) NOT NULL,
    fonte VARCHAR(255) NOT NULL,
    url_fonte VARCHAR(500),
    data_atualizacao DATE,
    observacoes TEXT,

    CONSTRAINT fk_indicadores_sociais_regioes
        FOREIGN KEY (id_regiao)
        REFERENCES regioes(id_regiao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE iniciativas_sustentaveis (
    id_iniciativa INT AUTO_INCREMENT PRIMARY KEY,
    id_regiao INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    tipo VARCHAR(80) NOT NULL,
    descricao TEXT,
    endereco VARCHAR(200),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    contato VARCHAR(150),
    ativa BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_iniciativas_regioes
        FOREIGN KEY (id_regiao)
        REFERENCES regioes(id_regiao)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER trg_validar_item_doacao
BEFORE INSERT ON itens_doacao
FOR EACH ROW
BEGIN
    DECLARE v_perecivel BOOLEAN;

    IF NEW.quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A quantidade do alimento deve ser maior que zero.';
    END IF;

    SELECT perecivel
    INTO v_perecivel
    FROM alimentos
    WHERE id_alimento = NEW.id_alimento;

    IF v_perecivel = TRUE THEN
        IF NEW.data_validade IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Alimentos pereciveis precisam de data de validade.';
        END IF;

        IF NEW.data_validade < CURDATE() THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nao e permitido cadastrar alimento vencido para doacao.';
        END IF;
    END IF;
END$$

DELIMITER $$

CREATE TRIGGER trg_validar_item_doacao
BEFORE INSERT ON itens_doacao
FOR EACH ROW
BEGIN
    DECLARE v_perecivel BOOLEAN;

    IF NEW.quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A quantidade do alimento deve ser maior que zero.';
    END IF;

    SELECT perecivel
    INTO v_perecivel
    FROM alimentos
    WHERE id_alimento = NEW.id_alimento;

    IF v_perecivel = TRUE THEN
        IF NEW.data_validade IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Alimentos pereciveis precisam de data de validade.';
        END IF;

        IF NEW.data_validade < CURDATE() THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nao e permitido cadastrar alimento vencido para doacao.';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_validar_atualizacao_item
BEFORE UPDATE ON itens_doacao
FOR EACH ROW
BEGIN
    DECLARE v_perecivel BOOLEAN;

    IF NEW.quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A quantidade deve ser maior que zero.';
    END IF;

    SELECT perecivel
    INTO v_perecivel
    FROM alimentos
    WHERE id_alimento = NEW.id_alimento;

    IF v_perecivel = TRUE THEN
        IF NEW.data_validade IS NULL
           OR NEW.data_validade < CURDATE() THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Verifique a validade do alimento perecivel.';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_data_conclusao_entrega
BEFORE UPDATE ON entregas
FOR EACH ROW
BEGIN
    IF NEW.status = 'Concluida'
       AND OLD.status <> 'Concluida' THEN
        SET NEW.data_conclusao = CURRENT_TIMESTAMP;
    END IF;
END$$

CREATE TRIGGER trg_atualizar_status_doacao
AFTER UPDATE ON entregas
FOR EACH ROW
BEGIN
    IF NEW.status = 'Concluida'
       AND OLD.status <> 'Concluida' THEN
        UPDATE doacoes
        SET status = 'Entregue'
        WHERE id_doacao = NEW.id_doacao;
    END IF;
END$$

CREATE TRIGGER trg_indicadores_before_insert
BEFORE INSERT ON indicadores_sociais
FOR EACH ROW
BEGIN
    IF NEW.data_atualizacao IS NULL THEN
        SET NEW.data_atualizacao = CURDATE();
    END IF;
END$$

DELIMITER ;

SHOW TABLES;

SHOW TRIGGERS;