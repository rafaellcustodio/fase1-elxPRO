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
    assinante = Assinante.cadastrar("Miguel", "12345", "99998888", :prepago)

    assert Recarga.nova(DateTime.utc_now(), 30, assinante.numero) = {:ok, "Recarga realizada com sucesso"}
    plano = assinante.plano
    credito = assinante.recargas

    assert plano.creditos == 30
    assert Enum.count(recargas) == 1
  end
end
