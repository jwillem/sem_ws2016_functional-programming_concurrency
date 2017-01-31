defmodule Profiling do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def map(collection, func) do
    collection
    |> Enum.map(&(func.(&1)))
  end

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
    |> Float.round(4)
  end

  def run() do
    range = 1..1000
    IO.puts "Starting Profiling with pmap"
    result_a = measure(fn -> pmap range, &(&1 * &1) end)
    IO.puts "Result"
    IO.puts result_a
    IO.puts "Starting Profiling with normal map"
    result_b = measure(fn -> Enum.map range, &(&1 * &1) end)
    IO.puts "Result"
    IO.puts result_b
  end
end
