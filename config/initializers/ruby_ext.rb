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

class Date
  # Returns length in months not including last month
  # ex. start = 1 jan, stop = 1 feb #=> length_in_months = 1
  #
  def self.length_in_months(start, stop)
    stop.year == start.year ? stop.month - start.month : stop.month + (stop.year - start.year) * 12 - start.month
  end
  
  # Returns length in months not including last month
  # ex. start = 1 jan, stop = 1 feb => length_in_months = 2
  #
  def self.length_in_months_including_last(start, stop)
    self.length_in_months(start, stop) + 1
  end
  
  # Returns yearly reference number
  # ex. enrollment_date = 2011, cancel_date = 2012 #=> year_reference = "1112"
  #
  def self.year_reference(enrollment_date, cancel_date)
    #enrollment doesn't end in the same year
    if enrollment_date.year < cancel_date.year
      return enrollment_date.year.to_s[2,3] + cancel_date.year.to_s[2,3]
    else #enrollment ends in the same year
      if cancel_date.month <= 6
        return (enrollment_date.year - 1).to_s[2,3] + cancel_date.year.to_s[2,3]
      else
        return enrollment_date.year.to_s[2,3] + (cancel_date.year + 1).to_s[2,3]
      end
    end
  end
end

# Remove the dreadful to_float method on big decimal objects.
# class BigDecimal; undef :to_f; end;