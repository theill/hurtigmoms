# encoding: utf-8

class String
  def slugify
    self.gsub(/æ/, 'ae').gsub(/ø/, 'oe').gsub(/å/, 'aa').gsub(/Æ/, 'AE').gsub(/Ø/, 'OE').gsub(/Å/, 'AA').parameterize.to_s
  end
end