defmodule Example.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Example.Supervisor.start_link()
  end
end
