require 'pdf/reader'

class PdfTextReceiver
  attr_accessor :content
 
  def initialize
    @content = []
  end
 
  # Called when page parsing starts
  def begin_page(arg = nil)
    @content << ""
  end
 
  # record text that is drawn on the page
  def show_text(string, *params)
    @content << string
  end
  
  # there's a few text callbacks, so make sure we process them all
  alias :super_show_text :show_text
  alias :move_to_next_line_and_show_text :show_text
  alias :set_spacing_next_line_show_text :show_text
 
  # this final text callback takes slightly different arguments
  def show_text_with_positioning(*params)
    params = params.first
    params.each { |str| show_text(str) if str.kind_of?(String)}
  end
end

class PdfParser < TextParser
  attr_accessor :pdf
  attr_accessor :receiver
  
  def initialize(pdf)
    @receiver = PdfTextReceiver.new
    @pdf = PDF::Reader.file(pdf, @receiver)
  end
  
  def parse
    amount, currency = guess_amount(@receiver.content.join)
    
    { :amount => amount, :currency => currency }
  end
end