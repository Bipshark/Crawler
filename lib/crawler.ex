defmodule Crawler do
  use HTTPoison.Base

  defp depth, do: 1

  def get_links(url), do: get_links(url, depth)

  def get_links(url, n) do
    if n > 0 do
      case HTTPoison.get(url, [{"User-Agent", "CrawlerBot"}]) do
        {:ok, %HTTPoison.Response{status_code: 301, headers: headers}} ->
          get_links(headers["Location"])

        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          Floki.parse(body)
            |> Floki.find("a")
            |> Floki.attribute("href")
            |> Enum.uniq
            |> Enum.map(&absolutify(&1, url))
            |> Enum.map(&handle(&1, n-1))

            IO.puts String.duplicate(" ", depth-n) <> url
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("

        {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
      end
    else
      IO.puts String.duplicate(" ", depth-n) <> url
    end
  end

  defp remove_leading_slash(url) do
    url |> String.lstrip(?/)
  end

  defp absolutify(url, origin) do
    if ((url |> String.starts_with? origin) or (url |> String.starts_with? "http://")) do
      url
    else
      origin <> (url |> remove_leading_slash)
    end
  end

  defp handle(url, n) do
    spawn Crawler, :get_links, [url, n]
  end
end
