class Movie < ActiveRecord::Base
  before_save :extract_youtube_id
  
  def thumbnail
    "http://img.youtube.com/vi/#{youtube}/default.jpg"
  end
  
  private
  
  def extract_youtube_id
    yt_id = self.youtube.match /http:\/\/www\.youtube\.com\/watch\?v\=([^\"][a-zA-Z0-9\-_]+)/
    if Regexp.last_match(1)
      self.youtube = Regexp.last_match(1)
    end
  end
end
