defmodule VCNL4040.Config do
  defstruct int_time: :it_80_ms,
            shutdown: false,
            interrupt: false

  def new, do: struct(__MODULE__)
  def new(opts), do: struct(__MODULE__, opts)

  def to_integer(config) do
    reserved = 0
    persistence_protect = 0

    <<integer::8>> = <<
      int_time(config.int_time)::2, # ALS_IT
      reserved::2,
      persistence_protect::2, # ALS_PERS
      interrupt(config.interrupt)::1, # ALS_INT_EN
      shutdown(config.shutdown)::1 # ALS_SD
    >>

    integer
  end

  defp int_time(:it_80_ms), do: 0b00
  defp int_time(:it_160_ms), do: 0b01
  defp int_time(:it_320_ms), do: 0b10
  defp int_time(:it_640_ms), do: 0b11
  defp int_time(:it_default), do: 0b00

  defp shutdown(true), do: 1
  defp shutdown(_), do: 0

  defp interrupt(true), do: 1
  defp interrupt(_), do: 0

  # https://github.com/akoutmos/nerves_weather_station/blob/master/nerves_code/veml6030/lib/veml6030/config.ex
  # @to_lumens_factor %{
  #   {:it_800_ms, :gain_2x} => 0.0036,
  #   {:it_800_ms, :gain_1x} => 0.0072,
  #   ...
  # }

  # def to_lumens(config, measurement) do
  #   @to_lumens_factor[{config.int_time, config.gain}] * measurement
  # end
end
