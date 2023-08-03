# Copyright (c) 2022 Forte Labs
# All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains the property of
# Forte Labs and their suppliers, if any.  The intellectual and technical
# concepts contained herein are proprietary to Forte Labs and their suppliers
# and may be covered by U.S. and Foreign Patents, patents in process, and are
# protected by trade secret or copyright law. Dissemination of this information
# or reproduction of this material is strictly forbidden unless prior written
# permission is obtained from Forte Labs.
defmodule ScadaSubstationsUnrc.HealthcheckPlug do
  @moduledoc """
  This module contain the endpoints for healthcheck.
  """
  use Plug.Router

  require Logger

  @vsn Mix.Project.config()[:version]

  plug(:match)
  plug(:dispatch)

  # Is this container in a state that is can not server traffic. And example of
  # this would be if we hook up some kind of back pressure support in a queue
  # we want this instance to let that flush out for a bit before accepting more.
  get "/ready" do
    do_response(conn, 200, %{"status" => "ready"})
  end

  # This is a general liveness probe. If this doesn't respond the Kubernetes
  # will think this pod is dead in the water and will restart it after a
  # configured amount of failed attempts happens
  get "/health" do
    do_response(conn, 200, %{"status" => "pass"})
  end

  get "/health/full" do
    do_response(conn, 200, %{
      "status" => "pass",
      "version" => @vsn,
      "details" => [
        %{
          "service_name" => "SCADA UNRC Service"
        }
      ]
    })
  end

  match _ do
    do_response(conn, 404, %{"error" => "path_not_found"})
  end

  defp do_response(conn, code, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Jason.encode!(message))
  end

  def get_port do
    Application.get_env(:scada_substations_unrc, :healthcheck_port, "4000")
    |> String.to_integer()
  end
end
