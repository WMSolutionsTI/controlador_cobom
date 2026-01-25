-- Initial database schema for Controlador COBOM
-- This migration creates all necessary tables, enums, functions, and indexes

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create enums
-- Note: These enums match the type definitions in src/integrations/supabase/types.ts
-- 
-- vehicle_category: Reserved for future categorization of vehicle types
--                   Currently defined but not yet applied to any table column
--                   Kept for schema consistency with TypeScript types and future implementation
--                   TODO: Add 'categoria' column to modalidades_viatura or viaturas table
-- 
-- vehicle_status: Applied to viaturas.status column for operational state tracking
CREATE TYPE vehicle_category AS ENUM ('Engine', 'Ladder', 'Rescue', 'Ambulance', 'Chief', 'Utility');
CREATE TYPE vehicle_status AS ENUM ('Available', 'En Route', 'On Scene', 'En Route to Hospital', 'Returning to Base');

-- Table: grupamentos (Fire Brigade Groupings)
CREATE TABLE grupamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    endereco TEXT,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: subgrupamentos (Sub-groupings)
CREATE TABLE subgrupamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    grupamento_id UUID NOT NULL REFERENCES grupamentos(id) ON DELETE CASCADE,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: estacoes (Fire Stations)
CREATE TABLE estacoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    subgrupamento_id UUID NOT NULL REFERENCES subgrupamentos(id) ON DELETE CASCADE,
    endereco TEXT,
    telefone TEXT,
    telegrafista TEXT,
    qsa_radio INTEGER,
    qsa_zello INTEGER,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: controladores (System Controllers/Operators)
CREATE TABLE controladores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    grupamento_id UUID REFERENCES grupamentos(id) ON DELETE SET NULL,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: modalidades_viatura (Vehicle Modalities/Types)
CREATE TABLE modalidades_viatura (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    icone_url TEXT NOT NULL,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: viaturas (Vehicles)
CREATE TABLE viaturas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prefixo TEXT NOT NULL,
    estacao_id UUID NOT NULL REFERENCES estacoes(id) ON DELETE CASCADE,
    modalidade_id UUID NOT NULL REFERENCES modalidades_viatura(id) ON DELETE RESTRICT,
    status vehicle_status DEFAULT 'Available',
    dejem BOOLEAN DEFAULT FALSE,
    qsa_radio INTEGER,
    qsa_zello INTEGER,
    status_alterado_em TIMESTAMPTZ,
    criado_em TIMESTAMPTZ DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: observacoes_viatura (Vehicle Observations)
CREATE TABLE observacoes_viatura (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    viatura_id UUID NOT NULL REFERENCES viaturas(id) ON DELETE CASCADE,
    observacao TEXT NOT NULL,
    criado_por TEXT,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: anotacoes_servico (Service Annotations)
CREATE TABLE anotacoes_servico (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    grupamento_id UUID NOT NULL REFERENCES grupamentos(id) ON DELETE CASCADE,
    controlador_id UUID REFERENCES controladores(id) ON DELETE SET NULL,
    data DATE DEFAULT CURRENT_DATE,
    anotacoes TEXT NOT NULL,
    criado_por TEXT,
    criado_em TIMESTAMPTZ DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Table: logs_atividade (Activity Logs)
CREATE TABLE logs_atividade (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    acao TEXT NOT NULL,
    detalhes TEXT,
    controlador_id UUID REFERENCES controladores(id) ON DELETE SET NULL,
    grupamento_id UUID REFERENCES grupamentos(id) ON DELETE SET NULL,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_subgrupamentos_grupamento ON subgrupamentos(grupamento_id);
CREATE INDEX idx_estacoes_subgrupamento ON estacoes(subgrupamento_id);
CREATE INDEX idx_controladores_grupamento ON controladores(grupamento_id);
CREATE INDEX idx_viaturas_estacao ON viaturas(estacao_id);
CREATE INDEX idx_viaturas_modalidade ON viaturas(modalidade_id);
CREATE INDEX idx_observacoes_viatura ON observacoes_viatura(viatura_id);
CREATE INDEX idx_anotacoes_grupamento ON anotacoes_servico(grupamento_id);
CREATE INDEX idx_logs_grupamento ON logs_atividade(grupamento_id);
CREATE INDEX idx_logs_criado_em ON logs_atividade(criado_em);

-- Function: Clean old activity logs (older than 30 days)
CREATE OR REPLACE FUNCTION clean_old_activity_logs()
RETURNS VOID AS $$
BEGIN
    DELETE FROM logs_atividade WHERE criado_em < NOW() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- Function: Portuguese wrapper for cleaning old logs
CREATE OR REPLACE FUNCTION limpar_logs_antigos()
RETURNS VOID AS $$
BEGIN
    PERFORM clean_old_activity_logs();
END;
$$ LANGUAGE plpgsql;

-- Function: Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Update viaturas.atualizado_em on update
CREATE TRIGGER trigger_viaturas_updated_at
    BEFORE UPDATE ON viaturas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Trigger: Update anotacoes_servico.atualizado_em on update
CREATE TRIGGER trigger_anotacoes_updated_at
    BEFORE UPDATE ON anotacoes_servico
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Comments for documentation
COMMENT ON TABLE grupamentos IS 'Fire brigade groupings (e.g., 1º GB, 2º GB)';
COMMENT ON TABLE subgrupamentos IS 'Sub-groupings within fire brigades';
COMMENT ON TABLE estacoes IS 'Fire stations';
COMMENT ON TABLE controladores IS 'System operators/controllers';
COMMENT ON TABLE modalidades_viatura IS 'Vehicle types/modalities';
COMMENT ON TABLE viaturas IS 'Fire vehicles/apparatus';
COMMENT ON TABLE observacoes_viatura IS 'Observations/notes about vehicles';
COMMENT ON TABLE anotacoes_servico IS 'Daily service annotations';
COMMENT ON TABLE logs_atividade IS 'System activity logs';
