require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  # Ler a informacao do url com nokogiri (transformar em html)
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)
  links = []
  html_doc.search(".titleColumn a").each do |movie|
    links << "https://www.imdb.com" + movie.attributes["href"].value.gsub(/\?.+/,"")
  end
  links.first(5)
end

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  title_with_year = html_doc.search('h1').text.strip

  match = title_with_year.match(/^(?<title>.*).\((?<year>\d{4})\)$/)
  title = match['title']
  year = match['year']

  cast = []
  html_doc.search('.credit_summary_item:nth-of-type(3) a').each do |name|
    cast << name.text
  end


  {
    title: title,
    year: year.to_i,
    storyline: html_doc.search('.summary_text').text.strip,
    director: html_doc.search('.credit_summary_item:nth-of-type(1) a').text,
    cast: cast.first(3)
  }

end

