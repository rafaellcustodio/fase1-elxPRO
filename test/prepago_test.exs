defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "Funçoes de Ligacao" do
    test "Fazer uma ligacao" do
      Assinante.cadastrar("Rafael", "123", "456", :prepago)
      Recarga.nova(DateTime.utc_now(), 30, "123")

    assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
      {:ok, "A chamada custou 4.35 e voce tem 35.65 de creditos"}
    end

    test "Fazer uma ligacao longa e nao tem creditos" do
      Assinante.cadastrar("Rafael", "123", "456", :prepago)

    assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
      {:error, "Voce nao tem creditos para efetuar a ligacao, faca uma recarga"}
    end

  end

  describe "Teste para impressao de compras" do
    test "Deve informa valores da conta do mes" do
      Assinante.cadastrar("Rafael", "123", "456", :prepago)
      data = DateTime.utc_now()
      data_antiga = ~U[2021-10-01 12:13:36.853320Z]
      Recarga.nova(data, 30, "123")
      Prepago.fazer_chamada("123", data, 3)
      Recarga.nova(data_antiga, 30, "123")
      Prepago.fazer_chamada("123", data_antiga, 3)

      assinante = Assinante.buscar_assinante("123", :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2
      assinante = Prepago.imprimir_conta(data.month, data.year, "123")

      assert assinante.numero == "123"
      # assert Enum.count(assinante.chamadas) == 1
      # assert Enum.count(assinante.plano.recargas) == 1

    end

  end
end
