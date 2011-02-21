# encoding: utf-8
class String
  def make_websafe
    self.strip.gsub('d.d.', '').gsub('d.o.o.', '').strip.debalkanize.downcase.gsub(' ', '-').gsub(',', '').gsub('.', '').gsub('---', '-').gsub('--', '-').strip
  end
  
  def debalkanic
    self.gsub(/š/, "ssss").gsub(/č/, "cccc").gsub(/ž/, "zzzz").gsub(/ć/, "csss").gsub(/đ/, "dzzz").gsub(/Š/, "SSSS").gsub(/Č/, "CCCC").gsub(/Ž/, "ZZZZ").gsub(/Ć/, "CSSS").gsub(/Đ/, "DZZZ")
  end
  
  def rebalkanic
    self.gsub(/ssss/, "š").gsub(/cccc/, "č").gsub(/zzzz/, "ž").gsub(/csss/, "ć").gsub(/dzzz/, "đ").gsub(/SSSS/, "Š").gsub(/CCCC/, "Č").gsub(/ZZZZ/, "Ž").gsub(/CSSS/, "Ć").gsub(/DZZZ/, "Đ")
  end
  
  def debalkanize
    self.gsub('Č', 'C').gsub('Š', 'S').gsub('Ž', 'Z').gsub('Ć', 'C').gsub('Đ', 'D').gsub('č', 'c').gsub('š', 's').gsub('ž', 'z').gsub('ć', 'c').gsub('đ', 'd')
  end

  def debalkanize!
    replace self.debalkanize
  end
  
  def strip_tags
    self.gsub(/<\/?[^>]*>/, "")
  end
  
  def shorten(count = 12)
    words = self.split
  	if words.length >= count 
      words[0..(count-1)].join(' ')
  	else 
  		self
  	end
  end
  
  def to_permalink
    separator = '-'
    
    # words to ignore, usually the same words ignored by search engines
    ignore_words = ['and', 'or']
    ignore_re    = String.new

    # building ignore regexp
    ignore_words.each{ |word|
      ignore_re << word + '\b|\b'
    }
    ignore_re = '\b' + ignore_re + '\b'

    # shorten to max 8 words
    permalink = self.shorten 8
    
    # replace apostrophes with separator
    permalink = self.gsub("'", separator)

    # delete ignore words
    permalink = self.gsub(ignore_re, '')

    # all down
    permalink = self.downcase

    # shift whitespace and preserve all alphanumeric characters
    permalink.strip.debalkanize.gsub(" ", separator).gsub(/[^a-z0-9\-]+/, "")
  end
  
end

# Remove the dreadful to_float method on big decimal objects.
# class BigDecimal; undef :to_f; end;