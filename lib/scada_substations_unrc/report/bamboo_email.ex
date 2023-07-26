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

  def csv_report_email(report_file_path, substation_name) do
    report_attached = attachment(report_file_path, substation_name)

    new_email(
      from: {"SCADA Substations UNRC", "metodosunrc@gmail.com"},
      to: {"Fernando", "fernando.magnago@gmail.com"},
      cc: {"Ramiro", "rmatteoda@gmail.com"},
      subject: "Report for substation #{substation_name}",
      html_body: "<strong>CSV File with data from substations scada device</strong>",
      text_body: "scada report attached in csv format\n!",
      attachments: [report_attached]
    )
  end

  defp attachment(report_file_path, substation_name) do
    {:ok, result} = File.read(report_file_path)

    %{
      filename: "report_#{substation_name}.csv",
      content_type: "text/comma-separated-values",
      data: "#{result}"
    }
  end
end
