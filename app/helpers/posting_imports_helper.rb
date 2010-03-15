module PostingImportsHelper
  
  def match_header_to_column(header)
    case header.downcase
    when 'bogført', 'dato'
      'created_at'
    when 'tekst', 'note'
      'note'
    when 'beløb'
      'amount'
    end
  end
end