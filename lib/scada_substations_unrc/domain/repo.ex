defmodule ScadaSubstationsUnrc.Domain.Repo do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Ecto.Repo,
    otp_app: :scada_substations_unrc,
    adapter: Ecto.Adapters.Postgres
end
