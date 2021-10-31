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

    assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
      {:ok, "A chamada custou 4.35 e voce tem 5.65 de creditos"}
    end

    test "Fazer uma ligacao longa e nao tem creditos" do
      Assinante.cadastrar("Rafael", "123", "456", :prepago)

    assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
      {:error, "Voce nao tem creditos para efetuar a ligacao, faca uma recarga"}
    end

  end
end
