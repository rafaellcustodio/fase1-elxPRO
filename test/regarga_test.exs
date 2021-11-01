defmodule RecargaTest do
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



  test "Deve realizar uma recarga" do
    assinante = Assinante.cadastrar("Rafael", "123", "456", :prepago)

    {:ok, msg} =  Recarga.nova(DateTime.utc_now(), 20, "123")
    assert msg == "Recarga realizada com sucesso!"

    assinante = Assinante.buscar_assinante("123", :prepago)
    assert assinante.plano.creditos == 30
    assert Enum.count(assinante.plano.recargas) == 1
  end
  describe "Testa estrutura" do
    test "Teste simples de estrutura" do
      %Recarga{data: DateTime.utc_now(), valor: 50}
    end
  end
end
