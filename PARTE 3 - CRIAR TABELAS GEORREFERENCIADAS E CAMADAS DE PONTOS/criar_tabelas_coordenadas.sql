-- ====================================================================================
-- SCRIPT SQL: JUNÇÃO DOS DADOS BASE HISTÓRICOS COM AS COORDENADAS DO GEOCODEBR
-- ANOS: 1990, 2000, 2010
-- ====================================================================================

-- ==========================================
-- 1. REGIÃO METROPOLITANA DE FORTALEZA (RMF)
-- ==========================================
CREATE TABLE RMF_1990_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMF_1990 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMF_2000_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMF_2000 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMF_2010_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMF_2010 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMF_2025_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMF_2025 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');


-- ==========================================
-- 2. REGIÃO METROPOLITANA DO RIO DE JANEIRO (RMRJ)
-- ==========================================
CREATE TABLE RMRJ_1990_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMRJ_1990 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMRJ_2000_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMRJ_2000 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMRJ_2010_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMRJ_2010 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMRJ_2025_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMRJ_2025 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');


-- ==========================================
-- 3. REGIÃO METROPOLITANA DE BELO HORIZONTE/MG (RMG)
-- ==========================================
CREATE TABLE RMG_1990_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMG_1990 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMG_2000_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMG_2000 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMG_2010_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMG_2010 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMG_2025_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMG_2025 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');



-- ==========================================
-- 4. DISTRITO FEDERAL (DF)
-- ==========================================
CREATE TABLE DF_1990_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM DF_1990 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE DF_2000_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM DF_2000 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE DF_2010_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM DF_2010 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE DF_2025_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM DF_2025 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');



-- ==========================================
-- 5. REGIÃO METROPOLITANA DE SÃO PAULO (RMSP)
-- ==========================================
CREATE TABLE RMSP_1990_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMSP_1990 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMSP_2000_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMSP_2000 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMSP_2010_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMSP_2010 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');

CREATE TABLE RMSP_2025_georreferenciado AS
SELECT b.*, g.latitude, g.longitude, g.precisao_geocodebr, g.rua_buscada
FROM RMSP_2025 b
INNER JOIN enderecos_geocodificados_final g ON b.cnpj_completo = g.cnpj_completo
WHERE g.precisao_geocodebr NOT IN ('Centroide do Bairro', 'Centroide do Município');