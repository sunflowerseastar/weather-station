defmodule VCNL4040.Comm do
  alias Circuits.I2C
  alias VCNL4040.Config

  # ALS_DATA_L & ALS_DATA_M
  @light_register <<9>> # <<4>> for VEML6030

  def discover(possible_addresses \\ [0x10, 0x60]) do
    I2C.discover_one!(possible_addresses)
  end

  def open(bus_name) do
    {:ok, i2c} = I2C.open(bus_name)
    i2c
  end

  def write_config(configuration, i2c, sensor) do
    command = Config.to_integer(configuration)
    I2C.write(i2c, sensor, <<0, command::little-16>>)
  end

  def read(i2c, sensor, configuration) do
    <<value::little-16>> = I2C.write_read!(i2c, sensor, @light_register, 2)
    value
  end
end
