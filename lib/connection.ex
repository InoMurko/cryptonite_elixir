defmodule Connection do
  use GenServer

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: Connection)
  end

  def init (path) do
    { :ok,  %{:path => path}}
  end
  # Callbacks

  def handle_call({:'exchange-rates', from, to}, _from, state) when is_list(from) and is_list(to) do
    rates = get_rates(state[:path], from)
    {:reply, {:ok, rates[to |> List.to_string |> String.upcase]}, state}
  end

  def handle_call({:'exchange-rates', from, to}, _from, state) when is_binary(from) and is_binary(to) do
    from0 = String.to_char_list(from)
    rates = get_rates(state[:path], from0)
    {:reply, {:ok, rates[to |> String.upcase]}, state}
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item|state]}
  end

  def handle_info(_msg, state) do
    { :noreply, state }
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  defp get_rates(path, from) do
    {:ok, {_, _, response_body}} = :httpc.request(:get, {path ++ 'exchange-rates?currency=#{from}', []}, [], [])
    {:ok, body} = Poison.Parser.parse(response_body)
    data = body["data"]
    data["rates"]
  end
end
