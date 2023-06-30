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
      cc: "fernando.magnago@gmail.com",
      from: "metodosunrc@gmail.com",
      subject: "Report for substation #{substation_name}",
      html_body: "<strong>CSV File with data from substations scada device</strong>",
      text_body: "scada report attached in csv file #{csv_file} \n!"
      # attachment: csv_file
    )
  end
end
