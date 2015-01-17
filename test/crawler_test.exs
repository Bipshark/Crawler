defmodule CrawlerTest do
    use ExUnit.Case

    test "get links" do
        assert Crawler.get_links("http://www.sweclockers.com")
    end

    test "get links redirect" do
        assert Crawler.get_links("http://sweclockers.com")
    end
end
