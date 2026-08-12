-- ==========================================================================================
-- SCRIPT AUTOMÁTICO: CRIAÇÃO DE VIEWS HISTÓRICAS REGIONAIS
-- Regiões: DF, RMF, RMG, RMSP, RMRJ
-- Anos: 1990, 2000, 2010, 2025
-- ==========================================================================================

-- ========================================================================================
-- REGIÃO: DF
-- ========================================================================================

-- --- View para Região DF - Ano 1990 ---
DROP VIEW IF EXISTS DF_1990;
CREATE VIEW DF_1990 AS
SELECT * FROM DF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '19901231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '19901231'
        )
    )
);

-- --- View para Região DF - Ano 2000 ---
DROP VIEW IF EXISTS DF_2000;
CREATE VIEW DF_2000 AS
SELECT * FROM DF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20001231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20001231'
        )
    )
);

-- --- View para Região DF - Ano 2010 ---
DROP VIEW IF EXISTS DF_2010;
CREATE VIEW DF_2010 AS
SELECT * FROM DF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20101231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20101231'
        )
    )
);

-- --- View para Região DF - Ano 2025 ---
DROP VIEW IF EXISTS DF_2025;
CREATE VIEW DF_2025 AS
SELECT * FROM DF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20251231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20251231'
        )
    )
);

-- ========================================================================================
-- REGIÃO: RMF
-- ========================================================================================

-- --- View para Região RMF - Ano 1990 ---
DROP VIEW IF EXISTS RMF_1990;
CREATE VIEW RMF_1990 AS
SELECT * FROM RMF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '19901231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '19901231'
        )
    )
);

-- --- View para Região RMF - Ano 2000 ---
DROP VIEW IF EXISTS RMF_2000;
CREATE VIEW RMF_2000 AS
SELECT * FROM RMF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20001231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20001231'
        )
    )
);

-- --- View para Região RMF - Ano 2010 ---
DROP VIEW IF EXISTS RMF_2010;
CREATE VIEW RMF_2010 AS
SELECT * FROM RMF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20101231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20101231'
        )
    )
);

-- --- View para Região RMF - Ano 2025 ---
DROP VIEW IF EXISTS RMF_2025;
CREATE VIEW RMF_2025 AS
SELECT * FROM RMF
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20251231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20251231'
        )
    )
);

-- ========================================================================================
-- REGIÃO: RMG
-- ========================================================================================

-- --- View para Região RMG - Ano 1990 ---
DROP VIEW IF EXISTS RMG_1990;
CREATE VIEW RMG_1990 AS
SELECT * FROM RMG
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '19901231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '19901231'
        )
    )
);

-- --- View para Região RMG - Ano 2000 ---
DROP VIEW IF EXISTS RMG_2000;
CREATE VIEW RMG_2000 AS
SELECT * FROM RMG
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20001231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20001231'
        )
    )
);

-- --- View para Região RMG - Ano 2010 ---
DROP VIEW IF EXISTS RMG_2010;
CREATE VIEW RMG_2010 AS
SELECT * FROM RMG
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20101231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20101231'
        )
    )
);

-- --- View para Região RMG - Ano 2025 ---
DROP VIEW IF EXISTS RMG_2025;
CREATE VIEW RMG_2025 AS
SELECT * FROM RMG
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20251231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20251231'
        )
    )
);

-- ========================================================================================
-- REGIÃO: RMSP
-- ========================================================================================

-- --- View para Região RMSP - Ano 1990 ---
DROP VIEW IF EXISTS RMSP_1990;
CREATE VIEW RMSP_1990 AS
SELECT * FROM RMSP
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '19901231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '19901231'
        )
    )
);

-- --- View para Região RMSP - Ano 2000 ---
DROP VIEW IF EXISTS RMSP_2000;
CREATE VIEW RMSP_2000 AS
SELECT * FROM RMSP
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20001231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20001231'
        )
    )
);

-- --- View para Região RMSP - Ano 2010 ---
DROP VIEW IF EXISTS RMSP_2010;
CREATE VIEW RMSP_2010 AS
SELECT * FROM RMSP
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20101231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20101231'
        )
    )
);

-- --- View para Região RMSP - Ano 2025 ---
DROP VIEW IF EXISTS RMSP_2025;
CREATE VIEW RMSP_2025 AS
SELECT * FROM RMSP
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20251231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20251231'
        )
    )
);

-- ========================================================================================
-- REGIÃO: RMRJ
-- ========================================================================================

-- --- View para Região RMRJ - Ano 1990 ---
DROP VIEW IF EXISTS RMRJ_1990;
CREATE VIEW RMRJ_1990 AS
SELECT * FROM RMRJ
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '19901231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '19901231'
        )
    )
);

-- --- View para Região RMRJ - Ano 2000 ---
DROP VIEW IF EXISTS RMRJ_2000;
CREATE VIEW RMRJ_2000 AS
SELECT * FROM RMRJ
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20001231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20001231'
        )
    )
);

-- --- View para Região RMRJ - Ano 2010 ---
DROP VIEW IF EXISTS RMRJ_2010;
CREATE VIEW RMRJ_2010 AS
SELECT * FROM RMRJ
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20101231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20101231'
        )
    )
);

-- --- View para Região RMRJ - Ano 2025 ---
DROP VIEW IF EXISTS RMRJ_2025;
CREATE VIEW RMRJ_2025 AS
SELECT * FROM RMRJ
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            '4531701',
            '4531702',
            '4541201',
            '4541202',
            '4621400',
            '4622200',
            '4623101',
            '4623106',
            '4623109',
            '4631100',
            '4632001',
            '4632003',
            '4633801',
            '4634601',
            '4634602',
            '4634603',
            '4635401',
            '4635402',
            '4635499',
            '4636201',
            '4637101',
            '4637199',
            '4639701',
            '4639702',
            '4641901',
            '4642701',
            '4643501',
            '4644301',
            '4645101',
            '4646001',
            '4647801',
            '4649401',
            '4649402',
            '4649408',
            '4649499',
            '4651601',
            '4652400',
            '4661300',
            '4662100',
            '4663000',
            '4664800',
            '4665600',
            '4669901',
            '4669999',
            '4671100',
            '4672900',
            '4673700',
            '4674500',
            '4679601',
            '4679699',
            '4681801',
            '4682600',
            '4683400',
            '4684299',
            '4685100',
            '4686901',
            '4687701',
            '4687702',
            '4689301',
            '4689399',
            '4691500',
            '4692300',
            '4693100',
            '5211701',
            '5211799',
            '5212500',
            '5229099',
            '5250803',
            '5250804',
            '5250805'
        )
        OR (
            cnae_fiscal_secundaria LIKE '%4531701%'
            OR cnae_fiscal_secundaria LIKE '%4531702%'
            OR cnae_fiscal_secundaria LIKE '%462%'
            OR cnae_fiscal_secundaria LIKE '%463%'
            OR cnae_fiscal_secundaria LIKE '%464%'
            OR cnae_fiscal_secundaria LIKE '%465%'
            OR cnae_fiscal_secundaria LIKE '%466%'
            OR cnae_fiscal_secundaria LIKE '%467%'
            OR cnae_fiscal_secundaria LIKE '%468%'
            OR cnae_fiscal_secundaria LIKE '%469%'
            OR cnae_fiscal_secundaria LIKE '%52117%'
            OR cnae_fiscal_secundaria LIKE '%52125%'
            OR cnae_fiscal_secundaria LIKE '%52508%'
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                UPPER(razao_social) LIKE '%ALIMENT%'
                OR UPPER(razao_social) LIKE '%BEBIDA%'
                OR UPPER(razao_social) LIKE '%DISTRIB%'
                OR UPPER(razao_social) LIKE '%ATACAD%'
                OR UPPER(razao_social) LIKE '%LATICIN%'
                OR UPPER(razao_social) LIKE '%FRIGORIF%'
                OR UPPER(razao_social) LIKE '%FABRICA%'
                OR UPPER(razao_social) LIKE '%INDUSTRIA%'
                OR UPPER(razao_social) LIKE '%TRANSPORTE%'
                OR UPPER(razao_social) LIKE '%LOGISTICA%'
                OR UPPER(razao_social) LIKE '%AUTO PECAS%'
                OR UPPER(razao_social) LIKE '%COMERCIO%'
                OR UPPER(razao_social) LIKE '%MERCADO%'
                OR UPPER(razao_social) LIKE '%ARMAZEM%'
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            'Empresa Pública',
            'Sociedade de Economia Mista',
            'Sociedade Anônima Aberta',
            'Sociedade Anônima Fechada',
            'Sociedade Empresária Limitada',
            'Sociedade Empresária em Nome Coletivo',
            'Sociedade Empresária em Comandita Simples',
            'Sociedade Empresária em Comandita por Ações',
            'Sociedade Mercantil de Capital e Indústria',
            'Sociedade em Conta de Participação',
            'Empresário (Individual)',
            'Cooperativa',
            'Consórcio de Sociedades',
            'Grupo de Sociedades',
            'Estabelecimento, no Brasil, de Sociedade Estrangeira',
            'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira',
            'Empresa Domiciliada no Exterior',
            'Clube/Fundo de Investimento',
            'Sociedade Simples Pura',
            'Sociedade Simples Limitada',
            'Sociedade Simples em Nome Coletivo',
            'Sociedade Simples em Comandita Simples',
            'Empresa Binacional',
            'Consórcio de Empregadores',
            'Consórcio Simples',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)',
            'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)',
            'Sociedade Unipessoal de Advocacia',
            'Cooperativas de Consumo',
            'Empresa Simples de Inovação'
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '20251231'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '20251231'
        )
    )
);

