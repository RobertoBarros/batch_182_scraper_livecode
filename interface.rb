require 'yaml'
require_relative 'scraper'

movies = []
fetch_top_movie_urls.each do |link|
  movies << scrape_movie(link)
end

File.open('movies.yml', 'wb') do |file|
  file.write(movies.to_yaml)
end

