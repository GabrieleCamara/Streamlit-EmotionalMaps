-- Criando os cenários com as ruas do osm
CREATE OR REPLACE VIEW ruas_cenarios AS
SELECT ways.*
FROM ways
WHERE bool_cenario IS TRUE
ORDER BY cod_cenario
					
-- Atribuir aos pontos o código da rua mais próxima
CREATE OR REPLACE VIEW emoc_colec_ruas AS
SELECT DISTINCT ON(g1.fid) g1.fid, g1.cod_emoji, g2.osm_id, g2.name, g2.cod_cenario, g1.geom
    FROM emocoes_coletadas As g1, ruas_cenarios As g2 
    WHERE g1.fid <> g2.osm_id AND ST_DWithin(ST_Transform(g1.geom, 32722), ST_Transform(g2.the_geom, 32722), 100)
    ORDER BY g1.fid, ST_Distance(ST_Transform(g1.geom, 32722), ST_Transform(g2.the_geom, 32722))

-- Ponto medio de cada segmento de reta
CREATE OR REPLACE VIEW ponto_medio AS
SELECT ruas_cenarios.gid, ruas_cenarios.name, ruas_cenarios.osm_id, ST_Centroid(ruas_cenarios.the_geom) as geom
FROM ruas_cenarios

-- Seleciona todas as emoções mais próximas do ponto médio das ruas 
WITH knn AS (
 SELECT DISTINCT ON (A.fid)
  A.fid as gid_emoc,
  B.osm_id as hub_ruas,
  round(ST_Distance(ST_Transform(A.geom, 32722), ST_Transform(B.geom, 32722))::numeric,2) as distance
 FROM
  emoc_colec_ruas as A,
  ponto_medio as B
 WHERE
  ST_DWithin(ST_Transform(A.geom, 32722), ST_Transform(B.geom, 32722), 500)
 ORDER BY
  A.fid,
  ST_Distance(ST_Transform(A.geom, 32722), ST_Transform(B.geom, 32722)) ASC)
SELECT * INTO knn FROM knn ORDER BY hub_ruas;

-- Associou o nome dos hub dos pontos médios as emoções
CREATE OR REPLACE VIEW emoc_colec_hub AS
SELECT emoc_colec_ruas.*, knn.hub_ruas
FROM emoc_colec_ruas
INNER JOIN knn ON emoc_colec_ruas.fid = knn.gid_emoc
ORDER BY emoc_colec_ruas.name

-- Tentativa de atribuir ao hub  das ruas a amocao mais coletada
SELECT ponto_medio.*, emoc_colec_hub.hub_ruas,
	CASE
		WHEN COUNT(emoc_colec_hub.cod_emoji) > 1 THEN emoc_colec_hub.cod_emoji
	END emoc_repet
FROM ponto_medio, emoc_colec_hub
GROUP BY emoc_colec_hub.hub_ruas, ponto_medio.gid, ponto_medio.name, ponto_medio.osm_id, ponto_medio.geom, emoc_colec_hub.cod_emoji

SELECT DISTINCT ON (hub_ruas) hub_ruas, CASE
		WHEN COUNT(emoc_colec_hub.cod_emoji) > 1 THEN emoc_colec_hub.cod_emoji
	END emoc_repet
FROM emoc_colec_hub
GROUP BY emoc_colec_hub.hub_ruas, emoc_colec_hub.cod_emoji

-- Determina o ponto medio de cada rua 
SELECT ponto_medio.osm_id, ponto_medio.geom, MAX(teste_contagem.qta_emoji)
FROM ponto_medio, teste_contagem
WHERE ponto_medio.osm_id = teste_contagem.osm_id
GROUP BY ponto_medio.osm_id, ponto_medio.geom 

-- Contagem das emoções por trechos de ruas
CREATE OR REPLACE VIEW teste_contagem AS
SELECT emoc_colec_ruas.osm_id, emoc_colec_ruas.name, emoc_colec_ruas.cod_emoji, count(emoc_colec_ruas.cod_emoji) AS qta_emoji
FROM emoc_colec_ruas
GROUP BY emoc_colec_ruas.cod_emoji, emoc_colec_ruas.osm_id, emoc_colec_ruas.name
ORDER BY emoc_colec_ruas.name

-- Teste join one to many
CREATE OR REPLACE VIEW teste_join AS
SELECT ROW_NUMBER () OVER (ORDER BY ways.osm_id) AS gid_unic, ways.*, emoc_colec_ruas_2.cod_emoji
FROM ways
INNER JOIN emoc_colec_ruas_2 ON emoc_colec_ruas_2.osm_id = ways.osm_id

SELECT count(cod_emoji)
FROM teste_join
WHERE teste_join.name = 'Rua Engenheiro Ostoja Roguski'

-- 
SELECT count(emoc_colec_ruas_2)
FROM emoc_colec_ruas_2
WHERE emoc_colec_ruas_2.name = 'Rua Engenheiro Ostoja Roguski'

SELECT *
FROM teste_join
ORDER BY teste_join.name

-- Consulta contagem emoções linhas
CREATE OR REPLACE VIEW emoji_20 AS
SELECT emoc_colec_ruas.osm_id, emoc_colec_ruas.cod_emoji, COUNT(cod_emoji) AS cod_emoji_20
FROM emoc_colec_ruas WHERE cod_emoji = 20
GROUP BY emoc_colec_ruas.osm_id, emoc_colec_ruas.name , emoc_colec_ruas.cod_emoji

-- Fazendo join das views
CREATE OR REPLACE VIEW teste_1 AS
SELECT emoc_colec_ways.*, emoji_1.cod_emoji_1 FROM emoji_1
FULL OUTER JOIN emoc_colec_ways ON emoc_colec_ways.osm_id = emoji_1.osm_id 

CREATE OR REPLACE VIEW emoc_count_ways_view AS
SELECT teste_19.*, emoji_20.cod_emoji_20 FROM emoji_20
FULL OUTER JOIN teste_19 ON teste_19.osm_id = emoji_20.osm_id 

UPDATE emoc_count_ways
SET cod_emoji_20= 0
WHERE cod_emoji_20 IS NULL;

CREATE table emoc_count_ways_copy AS
SELECT * FROM emoc_count_ways

-- Atribuindo as valencias prevalecentes nas ruas
CREATE OR REPLACE VIEW emoc_count_ways_vlc_maior AS
SELECT fid, osm_id, geom, vlc_positivo, vlc_negativo, vlc_neutro, GREATEST(vlc_positivo, vlc_negativo, vlc_neutro) AS vlc_maior
FROM emoc_count_ways_vlc
GROUP BY fid, osm_id, geom

CREATE OR REPLACE VIEW emoc_ways_vlc_rua AS
SELECT fid, osm_id, geom, vlc_positivo, vlc_neutro, vlc_negativo, vlc_maior,
	CASE 
		WHEN vlc_maior = vlc_positivo THEN 'Positivo'
		WHEN vlc_maior = vlc_negativo THEN 'Negativo'
		ELSE 'Neutro' END AS vlc_maior_text
	FROM emoc_count_ways_vlc_maior
