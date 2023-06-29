defmodule ScadaSubstationsUnrc.Report.BambooEmail do
  @moduledoc false

  require Logger

  import Bamboo.Email

  def report_email do
    new_email(
      to: "rmatteoda@gmail.com",
      from: "metodosunrc@gmail.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end

  # def report(csv_file, substation_name) do
  #   new(attachment: csv_file)
  #   |> to("fernando.magnago@gmail.com")
  #   |> cc("rmatteoda@gmail.com")
  #   |> from({"SCADA", "metodosunrc@gmail.com"})
  #   |> subject("Reporte for substation: " <> substation_name)
  #   |> html_body("<h2>CSV Files SCADA UNRC</h2>")
  #   |> text_body("reporte scada in csv files \n")
  # end
end
