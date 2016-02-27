defmodule CryptoniteElixir do
  use Application

  def start do
    ConnectionSup.Supervisor.start_link()
  end

  def start(_type, _args) do
    ConnectionSup.Supervisor.start_link()
  end
end
