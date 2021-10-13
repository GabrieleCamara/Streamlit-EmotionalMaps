-- # CONSULTAS IMPLEMETADAS JUPYTER #--
-- Mapa das emoções individuais representadas pelos emoji e também mapa de calor
CREATE OR REPLACE VIEW emoc_colec_indiv AS
SELECT emocoes_coletadas.* FROM emocoes_coletadas, emoji_emoc 
WHERE emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji AND emocao = 'Ansiedade, Pressa, Correria'

-- Mapa das emoções por gênero
SELECT emocoes_coletadas.* FROM emocoes_coletadas, participantes 
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND participantes.genero = 'Feminino'

-- Mapa das emoções por modal
SELECT emocoes_coletadas.* FROM emocoes_coletadas, modais 
WHERE emocoes_coletadas.cod_modal = modais.cod_modal AND modais.nome = 'A pé'

-- Mapa das emoções  por idade 
SELECT emocoes_coletadas.* FROM emocoes_coletadas, participantes
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND participantes.faixa_etaria = 'De 25 a 29 anos'

-- Mapa das emoções por cenário
SELECT emocoes_coletadas.* FROM emocoes_coletadas, cenarios
WHERE emocoes_coletadas.cod_cenario = cenarios.cod_cenario AND cenarios.referencia = 'Parque Gomm - Praça 29 março'

-- Mapa das emoções por gênero classificadas por valencia
CREATE OR REPLACE VIEW emoc_colec_gnr AS SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, participantes, emoji_emoc 
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND participantes.genero = '%s' AND emoji_emoc.valencia = '%s' 
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, participantes, emoji_emoc 
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND participantes.genero = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, participantes, emoji_emoc 
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND participantes.genero = '%s' AND emoji_emoc.valencia = '%s'

-- Mapa das emoções por faixa etária classificadas por valencia
CREATE OR REPLACE VIEW emoc_colec_etr AS SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, participantes, emoji_emoc
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND participantes.faixa_etaria = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, participantes, emoji_emoc
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND participantes.faixa_etaria = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, participantes, emoji_emoc
WHERE emocoes_coletadas.cod_part = participantes.cod_part AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND participantes.faixa_etaria = '%s' AND emoji_emoc.valencia = '%s'

-- Mapa das emoções por cenário classificado por valência
CREATE OR REPLACE VIEW emoc_colec_cnr AS SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, cenarios, emoji_emoc
WHERE emocoes_coletadas.cod_cenario = cenarios.cod_cenario AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji AND cenarios.referencia = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, cenarios, emoji_emoc
WHERE emocoes_coletadas.cod_cenario = cenarios.cod_cenario AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji AND cenarios.referencia = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, cenarios, emoji_emoc
WHERE emocoes_coletadas.cod_cenario = cenarios.cod_cenario AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji AND cenarios.referencia = '%s' AND emoji_emoc.valencia = '%s'

-- Mapa das emoções por modal classificado por valência
SELECT emocoes_coletadas.*, emoji_emoc.valencia FROM emocoes_coletadas, modais, emoji_emoc
WHERE emocoes_coletadas.cod_modal = modais.cod_modal AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND modais.nome = 'A pé' AND emoji_emoc.valencia = 'Neutro'

CREATE OR REPLACE VIEW emoc_colec_mdl AS SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, modais, emoji_emoc
WHERE emocoes_coletadas.cod_modal = modais.cod_modal AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND modais.nome = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, modais, emoji_emoc
WHERE emocoes_coletadas.cod_modal = modais.cod_modal AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND modais.nome = '%s' AND emoji_emoc.valencia = '%s'
UNION SELECT emocoes_coletadas.fid, emocoes_coletadas.cod_emoji, ST_Force2D(emocoes_coletadas.geom) AS geom, emoji_emoc.valencia FROM emocoes_coletadas, modais, emoji_emoc
WHERE emocoes_coletadas.cod_modal = modais.cod_modal AND emocoes_coletadas.cod_emoji = emoji_emoc.cod_emoji 
AND modais.nome = '%s' AND emoji_emoc.valencia = '%s'

-- Consulta para pegar os pontos dos cenários
CREATE OR REPLACE VIEW pts_cnr_selec AS SELECT pts_cenarios.fid, pts_cenarios.pt_referencia, ST_Force2D(pts_cenarios.geom) AS geom 
FROM pts_cenarios, cenarios
WHERE pts_cenarios.cod_cenario = cenarios.cod_cenario AND cenarios.referencia = 'Parque Gomm - Praça 29 março'





