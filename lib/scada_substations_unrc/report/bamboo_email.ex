defmodule ScadaSubstationsUnrc.Report.BambooEmail do
  @moduledoc false

  require Logger

  import Bamboo.Email

  def welcome_email do
    new_email(
      to: "rmatteoda@gmail.com",
      from: "metodosunrc@gmail.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end

  def csv_report_email(csv_file, substation_name) do
    new_email(
      to: "rmatteoda@gmail.com",
      from: "metodosunrc@gmail.com",
      subject: "Reporte for substation: " <> substation_name,
      html_body: "<strong>CSV Files SCADA UNRC</strong>",
      text_body: "scada report attached in csv files \n!",
      attachment: csv_file
    )
  end
end
