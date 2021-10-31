defmodule Assinante do
  @moduledoc """
  Cadastro dos tipos de assinantes como `prepago` e `pospago`

  Utilize a função `cadastrar/4`
  """
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes(), do: read(:pospago) ++ read(:prepago)
  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)
@doc """
Função para cadastro de assinante `:prepago` e `:pospago`

## Parâmetros da função
- nome: String contendo nome
- numero: String contendo número, não devem existir 2 assinantes com mesmo número
- cpf: String contendo CPF
- plano: Atom com valor `prepago` ou `pospago`

## Informaçoes adicionais

- Uma mensagem de erro será exibida caso tente-se utilizar um número de usuário já existente

## Exemplo

    iex> Assinante.cadastrar("Joao", "1234", "9999", :pospago)
    {:ok, "Assinante Joao cadastrado!"}

"""
  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})
  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}
        (read(pega_plano(assinante)) ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, "Assinante #{nome} cadastrado!"}

      _assinante ->
        {:error, "Assinante ja cadastrado"}
    end
  end

  def atualizar(numero, assinante) do
    {assinante_antigo, nova_lista} = deletar_item(numero)

    case assinante.plano.__struct__ == assinante_antigo.plano.__struct__ do
    true ->
      (nova_lista ++ [assinante])
      |> :erlang.term_to_binary()
      |> write(pega_plano(assinante))

      false ->
        {:erro, "Assinante nao pode alterar o plano"}

    end
  end
  def pega_plano(assinante) do
    case assinante.plano.__struct__ == Prepago do
    true -> :prepago
    false -> :pospago
    end
  end

  def deletar(numero) do
    {assinante, nova_lista} = deletar_item(numero)

    nova_lista
    |> :erlang.term_to_binary()
    |> write(assinante.plano)
    {:ok, "Assinante #{assinante.nome} deletado!"}
  end

  def deletar_item(numero) do
    assinante = buscar_assinante(numero)
    nova_lista = read(pega_plano(assinante))
    |> List.delete(assinante)
    {assinante, nova_lista}
  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, :ennoent} ->
        {:error, "Arquivo invalido"}
    end
  end
end
