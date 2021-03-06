defmodule Database do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def lookup(server, name) do
    GenServer.call(server, { :lookup, name })
  end

  def create(server, name) do
    GenServer.cast(server, { :create, name })
  end

  def init(:ok) do
    
  end
end
