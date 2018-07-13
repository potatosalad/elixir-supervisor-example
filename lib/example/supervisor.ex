defmodule Example.Supervisor do
  def start_link() do
    ref = :erlang.make_ref()
    _pid = :erlang.spawn_link(__MODULE__, :init, [self(), ref])

    receive do
      {^ref, reply} ->
        reply
    end
  end

  def init(parent, ref) do
    _ = :erlang.process_flag(:trap_exit, true)
    {:ok, pid} = Example.Worker.start_link()
    _ = send(parent, {ref, {:ok, self()}})
    loop(pid)
  end

  def loop(pid) do
    receive do
      {:EXIT, ^pid, _reason} ->
        {:ok, new_pid} = Example.Worker.start_link()
        loop(new_pid)
    end
  end
end
