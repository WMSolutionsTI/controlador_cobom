-- =========================================
-- Migration: Crew Members (Integrantes da Equipe)
-- Criado em: 2026-01-21
-- =========================================

-- Tabela: integrantes_equipe (Crew Members)
CREATE TABLE integrantes_equipe (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    viatura_id UUID NOT NULL REFERENCES viaturas(id) ON DELETE CASCADE,
    nome TEXT NOT NULL,
    telefone TEXT,
    posto_graduacao TEXT,
    cursos TEXT[], -- Array de cursos/especializações
    funcao TEXT, -- Ex: Comandante, Motorista, Socorrista
    ativo BOOLEAN DEFAULT TRUE,
    ordem INTEGER DEFAULT 0, -- Para ordenação na exibição
    criado_em TIMESTAMPTZ DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índice para busca rápida por viatura
CREATE INDEX idx_integrantes_viatura ON integrantes_equipe(viatura_id);
CREATE INDEX idx_integrantes_ativo ON integrantes_equipe(ativo) WHERE ativo = TRUE;

-- Trigger para atualizar atualizado_em
CREATE TRIGGER trigger_integrantes_updated_at
    BEFORE UPDATE ON integrantes_equipe
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Comentário
COMMENT ON TABLE integrantes_equipe IS 'Crew members assigned to vehicles';

-- =========================================
-- Dados de Exemplo (Seed Data)
-- =========================================

-- Equipe exemplo para a primeira viatura (você pode ajustar os IDs reais)
-- Descomente e ajuste os UUIDs reais das viaturas após criação
/*
INSERT INTO integrantes_equipe (viatura_id, nome, telefone, posto_graduacao, cursos, funcao, ordem) VALUES
    -- Equipe ABT-01 (substitua pelo ID real da viatura)
    ('UUID_DA_VIATURA_ABT01', 'Cap. João Silva', '(11) 98765-4321', 'Capitão', ARRAY['Combate a Incêndio', 'Salvamento'], 'Comandante', 1),
    ('UUID_DA_VIATURA_ABT01', 'Sgt. Maria Santos', '(11) 98765-4322', 'Sargento', ARRAY['Motorista Especializado', 'APH'], 'Motorista', 2),
    ('UUID_DA_VIATURA_ABT01', 'Cb. Pedro Oliveira', '(11) 98765-4323', 'Cabo', ARRAY['Primeiros Socorros', 'DEJEM'], 'Socorrista', 3),
    ('UUID_DA_VIATURA_ABT01', 'Sd. Ana Costa', '(11) 98765-4324', 'Soldado', ARRAY['Bombeiro Civil', 'Busca e Resgate'], 'Guarnição', 4);
*/
