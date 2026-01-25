'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { PainelFrota } from './PainelFrota'
import { AnotacoesServicoDaily } from './AnotacoesServicoDaily'
import { SeletorControlador } from './SeletorControlador'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Shield, Search } from 'lucide-react'
import { Input } from '@/components/ui/input'

interface Grupamento {
  id: string
  nome: string
  endereco: string | null
}

export function ControleViaturasApp() {
  const [grupamentos, setGrupamentos] = useState<Grupamento[]>([])
  const [grupamentoSelecionado, setGrupamentoSelecionado] = useState<string>('')
  const [controladorSelecionado, setControladorSelecionado] = useState<string>('')
  const [termoPesquisa, setTermoPesquisa] = useState<string>('')
  const [corProntidao, setCorProntidao] = useState<'verde' | 'amarela' | 'azul'>('verde')
  const [refreshKey, setRefreshKey] = useState(0)

  useEffect(() => {
    carregarGrupamentos()
    calcularCorProntidao()
  }, [])

  const carregarGrupamentos = async () => {
    const { data, error } = await supabase
      .from('grupamentos')
      .select('*')
      .order('nome')

    if (!error && data) {
      setGrupamentos(data)
      if (data.length > 0) {
        setGrupamentoSelecionado(data[0].id)
      }
    }
  }

  const calcularCorProntidao = () => {
    const dataReferencia = new Date('2025-06-02T07:30:00-03:00')
    const agora = new Date()
    const diffHoras = Math.floor((agora.getTime() - dataReferencia.getTime()) / (1000 * 60 * 60))
    const ciclos = Math.floor(diffHoras / 24)
    const cores: ('verde' | 'amarela' | 'azul')[] = ['verde', 'amarela', 'azul']
    setCorProntidao(cores[ciclos % 3])
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header Fixo */}
      <div className="fixed top-0 left-0 right-0 z-50 bg-red-700 text-white shadow-lg">
        <div className="max-w-[1400px] mx-auto px-4 py-3">
          <div className="flex items-center justify-between">
            {/* Logo e Título */}
            <div className="flex items-center gap-3">
              <div className="bg-white rounded-full p-2 shadow-lg">
                <Shield className="w-6 h-6 text-red-700" />
              </div>
              <h1 className="text-xl font-bold">
                CBI-1 COBOM | Painel do Controlador
              </h1>
            </div>

            {/* Controles */}
            <div className="flex items-center gap-3">
              {/* Seletor de Grupamento */}
              {grupamentos.length > 0 && (
                <Select value={grupamentoSelecionado} onValueChange={setGrupamentoSelecionado}>
                  <SelectTrigger className="w-48 bg-white text-gray-900">
                    <SelectValue placeholder="Selecione um grupamento" />
                  </SelectTrigger>
                  <SelectContent>
                    {grupamentos.map((g) => (
                      <SelectItem key={g.id} value={g.id}>
                        {g.nome}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}

              {/* Seletor de Controlador */}
              <SeletorControlador
                grupamentoSelecionado={grupamentoSelecionado}
                controladorSelecionado={controladorSelecionado}
                aoMudarControlador={setControladorSelecionado}
              />

              {/* Pesquisa */}
              <div className="relative">
                <Search className="absolute left-2 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  placeholder="Buscar viatura..."
                  value={termoPesquisa}
                  onChange={(e) => setTermoPesquisa(e.target.value)}
                  className="pl-8 w-48 bg-white"
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Conteúdo */}
      <div className="pt-20 max-w-[1400px] mx-auto px-4 py-4 space-y-4">
        <AnotacoesServicoDaily
          grupamentoSelecionado={grupamentoSelecionado}
          controladorSelecionado={controladorSelecionado}
          corProntidao={corProntidao}
          key={`anotacoes-${refreshKey}`}
        />
        
        <PainelFrota
          grupamentoSelecionado={grupamentoSelecionado}
          controladorSelecionado={controladorSelecionado}
          termoPesquisa={termoPesquisa}
          key={`frota-${refreshKey}`}
          bloqueado={!controladorSelecionado}
        />
      </div>
    </div>
  )
}
