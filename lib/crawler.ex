defmodule Crawler do
  use HTTPoison.Base

  @depth 2

  def get_links(link, n \\ @depth) do
    case link do
      %Link{ local: local, url: url } ->
        if n > 0 do
          case HTTPoison.get(url, [ { "User-Agent", "CrawlerBot" } ]) do
            { :ok, %HTTPoison.Response{ status_code: 301, headers: headers } } ->
              get_links(%Link{ local: local, url: headers["Location"] }, n)

            { :ok, %HTTPoison.Response{ status_code: 200, body: body } } ->
              title = Floki.parse(body)
                |> Floki.find("title")
                |> Floki.text

              IO.puts "#{indentation(n)}#{local} #{title} #{url}"

              Floki.parse(body)
                |> Floki.find("a")
                |> Floki.attribute("href")
                |> Enum.uniq
                |> Enum.map(&handle(&1, url, n - 1))

            { :ok, %HTTPoison.Response{ status_code: 404 } } ->
              IO.puts "Not found :("

            { :error, %HTTPoison.Error{ reason: reason } } ->
              IO.inspect reason
          end
        else
          IO.puts "#{indentation(n)}#{local} #{url}"
        end
      url when is_binary(link) ->
        get_links(%Link{local: false, url: url}, n)
      end
  end

  defp indentation(n) do
    String.duplicate(" ", max(0, @depth - n))
  end

  defp remove_leading_slash(url) do
    String.lstrip(url, ?/)
  end

  # Maybe send the body to the handle function?
  defp handle(url, origin, n) do
    if String.starts_with?(url, origin) do
      get_links(%Link{ local: true, url: url }, n)
    else
      if String.starts_with?(url, "http://") do
        get_links(%Link{ local: false, url: url }, n)
      else
        get_links(%Link{ local: true, url: origin <> remove_leading_slash(url) }, n)
      end
    end
    #spawn Crawler, :get_links, [url, n]
  end
end
