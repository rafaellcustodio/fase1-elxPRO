defmodule Pospago do
  defstruct valor: nil

  @custo_minuto 1.40

  def fazer_chamada(numero, data, duracao) do
    Asssinante.buscar_assinante(numero, :pospago)
    |> Chamada.registrar(data, duracao)

    {:ok, "Chamada feita com sucesso duracao: #{duracao} minutos"}
  end

def imprimir_contas(mesm, ano, numero) do
assinante = Contas.imprimir(mesm, ano, numero, :pospago)

valor_total = assinante.chamadas
Enum.map(&(&1.duracao * @custo_minuto))
Enum.sum()

%Assinante{assinante | plano: %__MODULE__{valor: valor_total}}
end

end
