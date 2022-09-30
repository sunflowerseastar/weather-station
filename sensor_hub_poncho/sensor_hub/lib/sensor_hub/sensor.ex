defmodule SensorHub.Sensor do
  defstruct [:name, :fields, :read, :convert]

  def new(name) do
    %__MODULE__{
      read: read_fn(name),
      convert: convert_fn(name),
      fields: fields(name),
      name: name
    }
  end

  def fields(Ccs811), do: [:eco2, :tvoc]
  def fields(BMP280), do: [:altitude_m, :pressure_pa, :temperature_c]
  def fields(VCNL4040), do: [:light_lumens]

  def read_fn(Ccs811), do: fn -> Ccs811.read_alg_result_data() end
  def read_fn(BMP280), do: fn -> BMP280.measure(BMP280) end
  def read_fn(VCNL4040), do: fn -> VCNL4040.get_measurement() end

  def convert_fn(Ccs811) do
    fn reading ->
      Map.take(reading, [:eco2, :tvoc])
    end
  end

  def convert_fn(BMP280) do
    fn reading ->
      case reading do
        {:ok, measurement} ->
          Map.take(measurement, [:altitude_m, :pressure_pa, :temperature_c])

        _ ->
          %{}
      end
    end
  end

  def convert_fn(VCNL4040) do
    fn data -> %{light_lumens: data} end
  end

  def measure(sensor) do
    sensor.read.()
    |> sensor.convert.()
  end
end
