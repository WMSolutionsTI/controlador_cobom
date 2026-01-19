-- Seed data for Controlador COBOM
-- This migration populates the database with initial test data

-- Insert Grupamentos (Fire Brigade Groupings)
INSERT INTO grupamentos (id, nome, endereco) VALUES
    ('11111111-1111-1111-1111-111111111111', '1º GB', 'Endereço do 1º Grupamento de Bombeiros'),
    ('22222222-2222-2222-2222-222222222222', '2º GB', 'Endereço do 2º Grupamento de Bombeiros'),
    ('33333333-3333-3333-3333-333333333333', '3º GB', 'Endereço do 3º Grupamento de Bombeiros');

-- Insert Subgrupamentos (Sub-groupings)
INSERT INTO subgrupamentos (id, nome, grupamento_id) VALUES
    ('aaaa1111-1111-1111-1111-111111111111', '1º SGB', '11111111-1111-1111-1111-111111111111'),
    ('aaaa2222-2222-2222-2222-222222222222', '2º SGB', '11111111-1111-1111-1111-111111111111'),
    ('bbbb1111-1111-1111-1111-111111111111', '1º SGB', '22222222-2222-2222-2222-222222222222');

-- Insert Estações (Fire Stations)
INSERT INTO estacoes (id, nome, subgrupamento_id, endereco, telefone) VALUES
    ('eeee1111-1111-1111-1111-111111111111', 'Estação Central', 'aaaa1111-1111-1111-1111-111111111111', 'Rua Principal, 100', '(11) 1234-5678'),
    ('eeee2222-2222-2222-2222-222222222222', 'Estação Norte', 'aaaa1111-1111-1111-1111-111111111111', 'Av. Norte, 200', '(11) 2345-6789'),
    ('eeee3333-3333-3333-3333-333333333333', 'Estação Sul', 'aaaa2222-2222-2222-2222-222222222222', 'Rua Sul, 300', '(11) 3456-7890');

-- Insert Controladores (System Controllers/Operators)
INSERT INTO controladores (id, nome, grupamento_id) VALUES
    ('cccc1111-1111-1111-1111-111111111111', 'Controlador Silva', '11111111-1111-1111-1111-111111111111'),
    ('cccc2222-2222-2222-2222-222222222222', 'Controlador Santos', '11111111-1111-1111-1111-111111111111'),
    ('cccc3333-3333-3333-3333-333333333333', 'Controlador Oliveira', '22222222-2222-2222-2222-222222222222');

-- Insert Modalidades de Viatura (Vehicle Types)
INSERT INTO modalidades_viatura (id, nome, icone_url) VALUES
    ('mmmm1111-1111-1111-1111-111111111111', 'ABT', '/icons/abt.svg'),
    ('mmmm2222-2222-2222-2222-222222222222', 'ABS', '/icons/abs.svg'),
    ('mmmm3333-3333-3333-3333-333333333333', 'AT', '/icons/at.svg'),
    ('mmmm4444-4444-4444-4444-444444444444', 'ASE', '/icons/ase.svg'),
    ('mmmm5555-5555-5555-5555-555555555555', 'UR', '/icons/ur.svg'),
    ('mmmm6666-6666-6666-6666-666666666666', 'AEM', '/icons/aem.svg');

-- Insert Viaturas (Vehicles)
INSERT INTO viaturas (id, prefixo, estacao_id, modalidade_id, status, dejem) VALUES
    ('vvvv1111-1111-1111-1111-111111111111', 'ABT-01', 'eeee1111-1111-1111-1111-111111111111', 'mmmm1111-1111-1111-1111-111111111111', 'Available', false),
    ('vvvv2222-2222-2222-2222-222222222222', 'ABS-01', 'eeee1111-1111-1111-1111-111111111111', 'mmmm2222-2222-2222-2222-222222222222', 'Available', false),
    ('vvvv3333-3333-3333-3333-333333333333', 'AT-01', 'eeee2222-2222-2222-2222-222222222222', 'mmmm3333-3333-3333-3333-333333333333', 'Available', false),
    ('vvvv4444-4444-4444-4444-444444444444', 'UR-01', 'eeee2222-2222-2222-2222-222222222222', 'mmmm5555-5555-5555-5555-555555555555', 'Available', false),
    ('vvvv5555-5555-5555-5555-555555555555', 'ABT-02', 'eeee3333-3333-3333-3333-333333333333', 'mmmm1111-1111-1111-1111-111111111111', 'Available', false);

-- Insert some sample observations
INSERT INTO observacoes_viatura (viatura_id, observacao, criado_por) VALUES
    ('vvvv1111-1111-1111-1111-111111111111', 'Viatura em condições operacionais normais', 'Sistema'),
    ('vvvv2222-2222-2222-2222-222222222222', 'Última manutenção realizada em 2026-01-19', 'Sistema');

-- Insert sample activity log
INSERT INTO logs_atividade (acao, detalhes, grupamento_id) VALUES
    ('Sistema Inicializado', 'Banco de dados configurado com dados iniciais', '11111111-1111-1111-1111-111111111111');
