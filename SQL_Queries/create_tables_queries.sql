-- Create table cenario
CREATE TABLE cenarios (
  cod_cenario INTEGER,
  referencia TEXT,
  CONSTRAINT pk_cenario PRIMARY KEY (cod_cenario)
);

SELECT AddGeometryColumn('public','cenarios','geom', 4326,'LINESTRING', 2);

-- Create table emoji_emoc
CREATE TABLE emoji_emoc (
  cod_emoji INTEGER,
  emocao TEXT,
  valencia TEXT,
  CONSTRAINT pk_emoji_emoc PRIMARY KEY (cod_emoji));

-- Create table escala_emoji
CREATE TABLE escala_emoji (
  cod_escala INTEGER, 
  escala_likert TEXT,
  CONSTRAINT pk_escala_emoji PRIMARY KEY (cod_escala));
  
-- Create table modais
CREATE TABLE modais (
  cod_modal INTEGER, 
  nome TEXT,
  CONSTRAINT pk_modais PRIMARY KEY (cod_modal));
  
-- Create table participantes
CREATE TABLE participantes (
  cod_part VARCHAR(50), 
  nome TEXT,
  faixa_etaria TEXT,
  genero TEXT,
  amostra BOOLEAN,
  cod_escala INTEGER,
  cod_modal INTEGER,
  CONSTRAINT fk_escala_emoji FOREIGN KEY(cod_escala) REFERENCES escala_emoji(cod_escala),
  CONSTRAINT fk_modais FOREIGN KEY(cod_modal) REFERENCES modais(cod_modal),
  CONSTRAINT pk_participantes PRIMARY KEY (cod_part));
  
-- Create table emocoes_coletadas
CREATE TABLE emocoes_coletadas (
  fid INTEGER,
  cod_emoji INTEGER,
  cod_cenario INTEGER,
  cod_part VARCHAR(50),
  descricao TEXT,
  CONSTRAINT pk_emocoes_coletadas PRIMARY KEY (fid),
  CONSTRAINT fk_cod_emoji FOREIGN KEY(cod_emoji) REFERENCES emoji_emoc(cod_emoji),
  CONSTRAINT fk_cod_cenario FOREIGN KEY(cod_cenario) REFERENCES cenarios(cod_cenario),
  CONSTRAINT fk_cod_part FOREIGN KEY(cod_part) REFERENCES participantes(cod_part)
);

SELECT AddGeometryColumn('public','emocoes_coletadas','geom', 4326,'POINT', 2);

-- Create table emoções atribuídas as ruas
CREATE TABLE emoc_colec_ways (
  fid INTEGER,
  osm_id INTEGER,
  CONSTRAINT pk_emoc_colec_ways PRIMARY KEY (fid)
);
SELECT AddGeometryColumn('public','emoc_colec_ways','geom', 4326,'LINESTRING', 2);