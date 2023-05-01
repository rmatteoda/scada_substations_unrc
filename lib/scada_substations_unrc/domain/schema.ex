defmodule ScadaSubstationsUnrc.Domain.Schema do
  @moduledoc """
  This module contains a macro for common schema configurations,
  specially regarding UUID keys.
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @timestamps_opts [type: :utc_datetime]
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key :binary_id
      @type t :: %__MODULE__{}
    end
  end
end
