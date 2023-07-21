defmodule Leds do
  @moduledoc """
  Documentation for `Leds`.
  """

  use GenServer
  import Bitwise

  alias Circuits.GPIO
  # A1  17 # 0
  # A2  18 # 1
  # A3  27 # 2
  # OE  22 # 3
  # LE  23 # 4
  # SDI 24 # 5
  # CLK 25 # 6

  # LINES 8
  # PER_LINE 12

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    state = state
      |> Map.put(:gpio, %{
        a1: gpio_open_for_output(17),
        a2: gpio_open_for_output(18),
        a3: gpio_open_for_output(27),
        oe: gpio_open_for_output(22),
        le: gpio_open_for_output(23),
        sdi: gpio_open_for_output(24),
        clk: gpio_open_for_output(25)
      })
      |> Map.put(:matrix, [
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b10000000,0b00000001,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,
        ],
        [
          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b00000000,0b00000000,

          0b00000000,0b00000000,
          0b10000000,0b00000001,
        ],
      ])
    #:timer.send_interval(1, :loop)
    Process.send_after(__MODULE__, :loop, 0)
    {:ok, state}
  end

  def handle_info(:loop, state) do
    Enum.each(0..7, fn line ->

      # select line
      GPIO.write(state.gpio.a1, ~~~(line &&& 0b00000001))
      GPIO.write(state.gpio.a2, ~~~(line &&& 0b00000010))
      GPIO.write(state.gpio.a3, ~~~(line &&& 0b00000100))
      GPIO.write(state.gpio.oe, 1)

      Enum.each(0..11, fn position ->
        Enum.each(0..7, fn bit ->
          val = state.matrix
          |> Enum.at(line)
          |> Enum.at(position)

          GPIO.write(state.gpio.sdi, ~~~~~~(val &&& (1 <<< (7 - bit))))
          GPIO.write(state.gpio.clk, 1)
          GPIO.write(state.gpio.clk, 0)
        end)
      end)

      GPIO.write(state.gpio.le, 1)
      GPIO.write(state.gpio.le, 0)
      GPIO.write(state.gpio.oe, 0)
    end)
    {:noreply, state}
  end

  def data(data) do
    GenServer.cast(__MODULE__, {:data, data})
  end

  def handle_cast({:data, data}, state) do
    {:noreply, state}
  end

  defp gpio_open_for_output(pin) do
    {:ok, gpio} = GPIO.open(pin, :output)
    gpio
  end
end
