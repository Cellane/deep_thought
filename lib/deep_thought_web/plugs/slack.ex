defmodule DeepThoughtWeb.Plugs.Slack do
  import Plug.Conn

  def init(signing_key), do: signing_key

  def call(conn, signing_key) do
    with [timestamp] <- get_req_header(conn, "x-slack-request-timestamp"),
         [expected] <- get_req_header(conn, "x-slack-signature"),
         body <- DeepThoughtWeb.CacheBodyReader.read_cached_body(conn),
         sig_basestring <- "v0:" <> timestamp <> ":" <> body,
         key <- signing_key,
         digest <-
           :crypto.mac(:hmac, :sha256, key, sig_basestring)
           |> Base.encode16(case: :lower),
         signature when signature == expected <- "v0=" <> digest do
      conn
    else
      _ -> halt(conn)
    end
  end
end
