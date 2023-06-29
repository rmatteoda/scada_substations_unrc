defmodule ScadaSubstationsUnrc.Workers.EmailObanWorker do
  @moduledoc false
  @max_attempts 3

  use Oban.Worker,
    max_attempts: @max_attempts

  require Logger

  alias ScadaSubstationsUnrc.Mailer
  alias ScadaSubstationsUnrc.Report.BambooEmail

  @impl Oban.Worker
  @spec perform(Oban.Job.t()) ::
          :ok | {:error, any()}
  def perform(%Oban.Job{
        args: _args
      }) do
    Logger.info("Send email report worker runing")
    # Create your email
    BambooEmail.report_email()
    # Send your email
    |> Mailer.deliver_now()
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)

  # defp do_report_email do
  #   substation_list = Application.get_env(:scada_master,:device_table) #save the device_table table configured
  #   Reporter.do_report substation_list, :last_week
  #   do_report_email substation_list
  #   do_report_email_weather()
  # end

  # defp do_report_email([subconfig | substation_list]) do
  #   file_name = Path.join(report_path(), subconfig.name <> "_last_week.csv")
  #   Logger.debug "Sending email report for substation" <> subconfig.name
  #   EmailScheme.report(file_name,subconfig.name) |> Mailer.deliver
  #   do_report_email substation_list
  # end

  # defp do_report_email([]), do: nil

  # defp do_report_email_weather do
  #   Reporter.do_report_weather(:last_week)
  #   file_name = Path.join(report_path(), "weather_last_week.csv")
  #   Logger.debug "Sending email report with weather data"
  #   EmailScheme.report(file_name,"weather") |> Mailer.deliver
  # end

end
