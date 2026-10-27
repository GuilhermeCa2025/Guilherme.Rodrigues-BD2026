Create database mapa_alimenta;
use mapa_alimenta;

create table regioes (
id_regioes INT auto_increment,
nome varchar (100) not null,
municipio varchar (100) not null,
uf char(2) not null,
latitude decimal(10,7),
longitude decimal(10,7),
primary key (id_regioes)
)Engine=InnoDB;

CREATE TABLE indicadores (
    id_indicador INT AUTO_INCREMENT,
    id_regioes INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    valor DECIMAL(12,2),
    unidade VARCHAR(30),
    periodo_referencia VARCHAR(30),
    fonte VARCHAR(200) NOT NULL,
    data_atualizacao DATE,
    PRIMARY KEY (id_indicador),

    CONSTRAINT fk_indicadores_regioes
        FOREIGN KEY (id_regioes)
        REFERENCES regioes(id_regioes)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE estabelecimentos (
    id_estabelecimento INT AUTO_INCREMENT,
    id_regioes INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id_estabelecimento),

    CONSTRAINT fk_estabelecimentos_regioes
        FOREIGN KEY (id_regioes)
        REFERENCES regioes(id_regioes)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

SHOW TABLES;

DESCRIBE regioes;
DESCRIBE indicadores;
DESCRIBE estabelecimentos;

INSERT INTO regioes
(nome, municipio, uf)
VALUES
('Bairro de teste', 'Sao Paulo', 'SP');

INSERT INTO estabelecimentos
(id_regioes, nome, tipo, endereco)
VALUES
(1, 'Mercado de teste', 'Mercado',
 'Endereco ficticio para testes');

SELECT
    e.nome AS estabelecimento,
    e.tipo,
    r.nome AS regioes,
    r.municipio
FROM estabelecimentos e
INNER JOIN regioes r
    ON e.id_regioes = r.id_regioes;