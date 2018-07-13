defmodule Example.Worker do
  def start_link() do
    ref = :erlang.make_ref()
    pid = :erlang.spawn_link(__MODULE__, :init, [self(), ref])

    receive do
      {^ref, reply} ->
        reply
    end
  end

  # Internal functions below
  def init(parent, ref) do
    _ = send(parent, {ref, {:ok, self()}})
    loop(0)
  end

  def loop(x) do
    receive do
      {:"$gen_call", {pid, ref}, :decrement} ->
        _ = send(pid, {ref, x})
        loop(x - 1)

      {:"$gen_call", {pid, ref}, :increment} ->
        _ = send(pid, {ref, x})
        loop(x + 1)

      {:"$gen_call", {pid, ref}, :value} ->
        _ = send(pid, {ref, x})
        loop(x)
    end
  end
end
