$KCODE = "U"
require 'fastercsv'

class ImportController < ApplicationController
  def postings
    s = IO.read(RAILS_ROOT + '/poster.csv')
    
    ic = Iconv.iconv('utf-8', 'iso8859-1', s)
    f = File.new(RAILS_ROOT + "/poster-utf8.csv", "w")
    f.puts ic
    f.close
    
    @rows = FasterCSV.read(RAILS_ROOT + '/poster-utf8.csv', {:col_sep => ';', :skip_blanks => true, :headers => true})
    
  end
end
