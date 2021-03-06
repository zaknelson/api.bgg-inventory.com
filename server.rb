require "sinatra"

get "/" do
	json_exists = File.exists?("games.json")
	json_modified_time = json_exists ? File.mtime("games.json") : nil
	scrape_started_long_ago = !File.exists?("scrape-started.txt") || (Time.now - File.mtime("scrape-started.txt") > 60 * 30)
	scrape_finished_long_ago = !json_exists || (Time.now - json_modified_time > 60 * 60 * 8)
	if scrape_started_long_ago && scrape_finished_long_ago
		Thread.new do
			FileUtils.touch("scrape-started.txt")
			puts `ruby bgg-inventory-scraper.rb`
		end
	end
	json_exists ? json_modified_time.to_s : ""
end

get "/api/v1/games.json" do
	response.headers['Access-Control-Allow-Origin'] = "http://bgg-inventory.com"
	send_file File.expand_path("games.json")
end