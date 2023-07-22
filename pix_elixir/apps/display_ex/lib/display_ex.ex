defmodule DisplayEx do
  @moduledoc """
  Documentation for `DisplayEx`.
  """

  use GenServer

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

  defp init_gpio(state) do
      state
      |> Map.put(:gpio, %{
        a1: gpio_open_for_output(17),
        a2: gpio_open_for_output(18),
        a3: gpio_open_for_output(27),
        oe: gpio_open_for_output(22),
        le: gpio_open_for_output(23),
        sdi: gpio_open_for_output(24),
        clk: gpio_open_for_output(25)
      })
  end

  def init_matrix(state) do
    state
    |> Map.put(
      :matrix,
      Code.eval_string("""
        %{
          {1, 1, 1} => [ # 0
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {1, 1, 0} => [ # 1
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {1, 0, 1} => [ # 2
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {1, 0, 0} => [ # 3
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {0, 1, 1} => [ # 4
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {0, 1, 0} => [ # 5
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {0, 0, 1} => [ # 6
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          ],
          {0, 0, 0} => [ # 7
          # blue
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # green
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

          # red
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
          ],
        }
      """)
      |> elem(0)
    )
  end

  def init(state) do
    state =
      state
      |> init_gpio()
      |> init_matrix()

    :timer.send_interval(1, :loop)
    {:ok, state}
  end

  def handle_info(:loop, state) do
    state.matrix
    |> Enum.each(fn {{a1, a2, a3}, bits} ->
      GPIO.write(state.gpio.a1, a1)
      GPIO.write(state.gpio.a2, a2)
      GPIO.write(state.gpio.a3, a3)
      GPIO.write(state.gpio.oe, 1)

      Enum.each(bits, fn bit ->
        GPIO.write(state.gpio.sdi, bit)
        GPIO.write(state.gpio.clk, 1)
        GPIO.write(state.gpio.clk, 0)
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
    matrix =
      data
      |> List.flatten()
      |> Enum.chunk_every(32)
      |> Enum.map(fn lines ->
        [
          Enum.map(lines, &Kernel.>(Bitwise.band(&1, 0b100), 0)),
          Enum.map(lines, &Kernel.>(Bitwise.band(&1, 0b010), 0)),
          Enum.map(lines, &Kernel.>(Bitwise.band(&1, 0b001), 0))
        ]
        |> List.flatten()
      end)

    {:noreply, state}
  end

  defp gpio_open_for_output(pin) do
    {:ok, gpio} = GPIO.open(pin, :output)
    gpio
  end
end
