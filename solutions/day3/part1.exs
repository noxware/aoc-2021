#! /usr/bin/env elixir

defmodule BitCounter do
  defstruct zeros: 0, ones: 0

  def incrementZeros(counter) do
    %{counter | zeros: counter.zeros + 1}
  end

  def incrementOnes(counter) do
    %{counter | ones: counter.ones + 1}
  end

  def mostCommon(counter) do
    if counter.zeros > counter.ones, do: "0", else: "1"
  end

  def lessCommon(counter) do
    if counter.zeros < counter.ones, do: "0", else: "1"
  end
end

defmodule Day3Part1 do
  def solve() do
    bits_per_row =
      File.stream!("#{Path.dirname(__ENV__.file)}/input.txt")
      |> Enum.at(0)
      |> String.trim()
      |> String.length()

    bit_counters = List.duplicate(%BitCounter{}, bits_per_row)

    bit_counters =
      File.stream!("#{Path.dirname(__ENV__.file)}/input.txt")
      |> Stream.filter(&(&1 != ""))
      |> Stream.map(&String.trim/1)
      # Transform here
      |> Stream.map(&String.graphemes/1)
      |> Enum.reduce(bit_counters, fn graphemes, acc ->
        Stream.zip(graphemes, acc)
        |> Stream.map(fn
          {"0", counter} -> BitCounter.incrementZeros(counter)
          {"1", counter} -> BitCounter.incrementOnes(counter)
        end)
        |> Enum.to_list()
      end)

    gamma_rate =
      Stream.map(bit_counters, &BitCounter.mostCommon/1)
      |> Enum.join()
      |> String.to_integer(2)

    epsilon_rate =
      Stream.map(bit_counters, &BitCounter.lessCommon/1)
      |> Enum.join()
      |> String.to_integer(2)

    IO.puts(gamma_rate * epsilon_rate)
  end
end

Day3Part1.solve()