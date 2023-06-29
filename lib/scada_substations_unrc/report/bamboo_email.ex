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

  # def welcome_email do
  #   base_email() # Build your default email then customize for welcome
  #   |> to("foo@bar.com")
  #   |> subject("Welcome!!!")
  #   |> put_header("Reply-To", "someone@example.com")
  #   |> html_body("<strong>Welcome</strong>")
  #   |> text_body("Welcome")
  # end

  # defp base_email do
  #   new_email()
  #   |> from("myapp@example.com") # Set a default from
  #   |> put_html_layout({MyApp.LayoutView, "email.html"}) # Set default layout
  #   |> put_text_layout({MyApp.LayoutView, "email.text"}) # Set default text layout
  # end
end
