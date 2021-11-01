defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end


   describe "Testes responsaveis para cadastro de assinantes" do
    test "Deve retornar estrutura de assinante" do
      assert %Assinante{nome: "Rafa", numero: "234", cpf: "9898"}.nome == "Rafa"
    end

    test "Criar conta prepago" do
      assert Assinante.cadastrar("Rafael", "123", "456", :prepago) ==
        {:ok, "Assinante Rafael cadastrado!"}
    end
    test "Deve retornar erro avisando usuario já cadastrado" do
      Assinante.cadastrar("Rafael", "123", "456", :prepago)
      assert Assinante.cadastrar("Rafael", "123", "456", :prepago) ==
      {:error, "Assinante ja cadastrado"}
    end
  end

  describe "Testes responsaveis por busca de assinantes" do
      test "busca pospago" do
        Assinante.cadastrar("Rafael1", "123123", "12344321", :pospago)
        assert Assinante.buscar_assinante("123123", :pospago).nome == "Rafael1"
        assert Assinante.buscar_assinante("123123", :pospago).plano.__struct__ == Pospago
      end

      test "busca prepago" do
        Assinante.cadastrar("Rafael1", "123123", "12344321", :prepago)
        assert Assinante.buscar_assinante("123123", :prepago).nome == "Rafael1"
      end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("Rafael2", "2222", "9999", :prepago)
      assert Assinante.deletar("2222") == {:ok, "Assinante Rafael2 deletado!"}
    end
  end
end
