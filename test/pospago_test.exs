defmodule Pospago do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

test "Deve fazer uma ligacao" do
  Assinante.cadastrar("Rafael", "123", "123", :pospago)

  assert Pospago.fazer_chamada("123", DateTime.utc_now(), 5) == {:ok, "Chamada feita com sucesso duracao: 5 minutos"}

end

test "deve informar valores da conta do mes" do
  Assinante.cadastrar("Rafael", "123", "456", :pospago)
  data = DateTime.utc_now()
  data_antiga = ~U[2021-10-01 12:13:36.853320Z]
  Pospago.fazer_chamada("123", data, 3)
  Pospago.fazer_chamada("123", data_antiga, 3)
  Pospago.fazer_chamada("123", data, 3)
  Pospago.fazer_chamada("123", data_antiga, 3)

  assinante = Assinante.buscar_assinante("123", :pospago)
  assert Enum.count(assinante.chamadas) == 4
  assinante = Pospago.imprimir_conta(data.month, data.year, "123")

  assert assinante.numero == "123"
  assert Enum.count(assinante.chamadas) == 3
  assert assinante.plano.valor == 50

end

end
