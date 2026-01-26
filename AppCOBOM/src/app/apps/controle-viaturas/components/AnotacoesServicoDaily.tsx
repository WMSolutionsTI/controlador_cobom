import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { ChevronDown, ChevronUp } from 'lucide-react';
import { supabase } from '@/lib/supabase/client';
import { useToast } from '@/hooks/use-toast';
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from '@/components/ui/collapsible';

interface AnotacoesServicoProps {
  grupamentoSelecionado: string;
  controladorSelecionado?: string;
  corProntidao: 'verde' | 'amarela' | 'azul';
}

export const AnotacoesServicoDaily = ({ grupamentoSelecionado, controladorSelecionado, corProntidao }: AnotacoesServicoProps) => {
  const [anotacoes, setAnotacoes] = useState('');
  const [estaCarregando, setEstaCarregando] = useState(true);
  const [registroId, setRegistroId] = useState<string | null>(null);
  const [estaRecolhido, setEstaRecolhido] = useState(true);
  const { toast } = useToast();
  const [nomeControlador, setNomeControlador] = useState<string>('');

  const dataHoje = new Date().toLocaleDateString('pt-BR');

  const obterEstiloProntidao = () => {
    const estilos = {
      verde: 'bg-green-500 text-white',
      amarela: 'bg-yellow-500 text-white',
      azul: 'bg-blue-500 text-white'
    };
    return estilos[corProntidao];
  };

  // Função debounced para salvamento automático
  const salvarAnotacoes = useCallback(
    async (novasAnotacoes: string) => {
      if (!grupamentoSelecionado) return;

      try {
        const dadosAnotacao = {
          grupamento_id: grupamentoSelecionado,
          controlador_id: controladorSelecionado || null,
          anotacoes: novasAnotacoes,
          data: new Date().toISOString().split('T')[0],
          criado_por: controladorSelecionado ? 'Sistema' : 'Anônimo',
          atualizado_em: new Date().toISOString()
        };

        if (registroId) {
          // Atualizar registro existente
          const { error } = await supabase
            .from('anotacoes_servico')
            .update(dadosAnotacao)
            .eq('id', registroId);

          if (error) throw error;
        } else {
          // Criar novo registro
          const { data, error } = await supabase
            .from('anotacoes_servico')
            .insert(dadosAnotacao)
            .select()
            .single();

          if (error) throw error;
          setRegistroId(data.id);
        }

        // Não mostrar toast a cada salvamento automático
        console.log('Anotações salvas automaticamente');
      } catch (error) {
        console.error('Erro ao salvar anotações:', error);
        toast({
          title: "Erro",
          description: "Falha ao salvar anotações automaticamente.",
          variant: "destructive",
        });
      }
    },
    [grupamentoSelecionado, controladorSelecionado, registroId, toast]
  );

  // Debounce para salvamento automático após 2 segundos de inatividade
  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => {
    if (!anotacoes.trim()) return;

    const timeoutId = setTimeout(() => {
      salvarAnotacoes(anotacoes);
    }, 2000);

    return () => clearTimeout(timeoutId);
  }, [anotacoes, salvarAnotacoes]);

  const carregarAnotacoes = async () => {
    if (!grupamentoSelecionado) return;

    try {
      const dataHoje = new Date().toISOString().split('T')[0];
      
      const { data, error } = await supabase
        .from('anotacoes_servico')
        .select('*')
        .eq('grupamento_id', grupamentoSelecionado)
        .eq('data', dataHoje)
        .order('atualizado_em', { ascending: false })
        .limit(1);

      if (error) throw error;

      if (data && data.length > 0) {
        setAnotacoes(data[0].anotacoes);
        setRegistroId(data[0].id);
      } else {
        setAnotacoes('');
        setRegistroId(null);
      }
    } catch (error) {
      console.error('Erro ao carregar anotações:', error);
      toast({
        title: "Erro",
        description: "Falha ao carregar anotações do dia.",
        variant: "destructive",
      });
    } finally {
      setEstaCarregando(false);
    }
  };

  const carregarNomeControlador = useCallback(async () => {
    if (!controladorSelecionado) {
      setNomeControlador('');
      return;
    }

    try {
      const { data, error } = await supabase
        .from('controladores')
        .select('nome')
        .eq('id', controladorSelecionado)
        .single();

      if (error) throw error;
      setNomeControlador(data.nome);
    } catch (error) {
      console.error('Erro ao carregar nome do controlador:', error);
      setNomeControlador('');
    }
  }, [controladorSelecionado]);

  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => {
    if (grupamentoSelecionado) {
      carregarAnotacoes();
    }
  }, [grupamentoSelecionado]);

  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => {
    carregarNomeControlador();
  }, [carregarNomeControlador]);

  if (!grupamentoSelecionado) {
    return (
      <Card className="border-red-200 shadow-lg">
        <Collapsible open={!estaRecolhido} onOpenChange={(open) => setEstaRecolhido(!open)}>
          <CardHeader className="bg-red-50 border-b border-red-200 py-2">
            <CollapsibleTrigger className="flex items-center justify-between w-full hover:bg-red-100 rounded p-1 transition-colors">
              <CardTitle className="text-red-800 text-sm">Anotações do Serviço - {dataHoje}</CardTitle>
              
              <div className="flex items-center gap-2">
                <div className={`px-3 py-1 rounded-md font-bold text-xs shadow-sm ${obterEstiloProntidao()}`}>
                  PRONTIDÃO: {corProntidao.toUpperCase()}
                </div>
                {estaRecolhido ? <ChevronDown className="w-4 h-4 text-red-600" /> : <ChevronUp className="w-4 h-4 text-red-600" />}
              </div>
            </CollapsibleTrigger>
          </CardHeader>
          <CollapsibleContent>
            <CardContent className="p-4">
              <div className="text-center text-gray-500">
                Selecione um grupamento para visualizar as anotações
              </div>
            </CardContent>
          </CollapsibleContent>
        </Collapsible>
      </Card>
    );
  }

  if (estaCarregando) {
    return (
      <Card className="border-red-200 shadow-lg">
        <Collapsible open={!estaRecolhido} onOpenChange={(open) => setEstaRecolhido(!open)}>
          <CardHeader className="bg-red-50 border-b border-red-200 py-2">
            <CollapsibleTrigger className="flex items-center justify-between w-full hover:bg-red-100 rounded p-1 transition-colors">
              <CardTitle className="text-red-800 text-sm">Anotações do Serviço - {dataHoje}</CardTitle>
              
              <div className="flex items-center gap-2">
                <div className={`px-3 py-1 rounded-md font-bold text-xs shadow-sm ${obterEstiloProntidao()}`}>
                  PRONTIDÃO: {corProntidao.toUpperCase()}
                </div>
                {estaRecolhido ? <ChevronDown className="w-4 h-4 text-red-600" /> : <ChevronUp className="w-4 h-4 text-red-600" />}
              </div>
            </CollapsibleTrigger>
          </CardHeader>
          <CollapsibleContent>
            <CardContent className="p-4">
              <div className="text-center">Carregando anotações...</div>
            </CardContent>
          </CollapsibleContent>
        </Collapsible>
      </Card>
    );
  }

  return (
    <Card className="border-red-200 shadow-lg">
      <Collapsible open={!estaRecolhido} onOpenChange={(open) => setEstaRecolhido(!open)}>
        <CardHeader className="bg-red-50 border-b border-red-200 py-2">
          <CollapsibleTrigger className="flex items-center justify-between w-full hover:bg-red-100 rounded p-1 transition-colors">
            <div className="flex items-center gap-2">
              <CardTitle className="text-red-800 text-sm">
                Anotações do Serviço - {dataHoje}
              </CardTitle>
              {nomeControlador && (
                <span className="text-xs text-gray-700 font-semibold bg-gray-100 px-2 py-1 rounded border border-gray-300">
                  CONTROLADOR: {nomeControlador}
                </span>
              )}
            </div>
            
            <div className="flex items-center gap-2">
              <div className={`px-3 py-1 rounded-md font-bold text-xs shadow-sm ${obterEstiloProntidao()}`}>
                PRONTIDÃO: {corProntidao.toUpperCase()}
              </div>
              {estaRecolhido ? <ChevronDown className="w-4 h-4 text-red-600" /> : <ChevronUp className="w-4 h-4 text-red-600" />}
            </div>
          </CollapsibleTrigger>
        </CardHeader>
        <CollapsibleContent>
          <CardContent className="p-4">
            <Textarea
              value={anotacoes}
              onChange={(e) => setAnotacoes(e.target.value)}
              placeholder="Digite as anotações do serviço do dia..."
              className="min-h-32 resize-none border-red-200 focus:border-red-500"
            />
          </CardContent>
        </CollapsibleContent>
      </Collapsible>
    </Card>
  );
};
