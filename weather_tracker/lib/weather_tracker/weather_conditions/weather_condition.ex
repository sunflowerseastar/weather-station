defmodule WeatherTracker.WeatherConditions.WeatherCondition do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields [
    # :co2_eq_ppm,
    # :tvoc_ppb,
    :altitude_m,
    :humidity_rh,
    :pressure_pa,
    :temperature_c,
    :light_lumens,
  ]

  @derive {Jason.Encoder, only: @allowed_fields}
  @primary_key false
  schema "weather_conditions" do
    field :timestamp, :naive_datetime
    # field :co2_eq_ppm, :decimal
    # field :tvoc_ppb, :decimal
    field :altitude_m, :decimal
    field :humidity_rh, :decimal
    field :pressure_pa, :decimal
    field :temperature_c, :decimal
    field :light_lumens, :integer
  end

  def create_changeset(weather_condition = %__MODULE__{}, attrs) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    weather_condition
    |> cast(attrs, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> put_change(:timestamp, timestamp)
  end
end
