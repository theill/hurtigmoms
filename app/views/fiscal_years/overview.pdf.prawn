items = []
@transactions.each do |transaction|
	items << formatted_pdf_line(transaction)
	transaction.linked.map do |related_payment_transaction|
		items << formatted_related_pdf_line(related_payment_transaction)
	end
end

pdf.repeat :all do
	pdf.text "#{@fiscal_year.user.company}", :at => pdf.bounds.top_left, :size => 8
	pdf.text "Side #{pdf.page_number} af #{pdf.page_count}", :align => :right, :valign => :bottom, :size => 8
end

pdf.table items, :border_style => :underline_header,
  :row_colors => ["ffffff", "f9f9f9"],
  :headers => ["Dato", "Bilag", "Note", "Indtægt", "Udgift"],
	:font_size => 8,
	:padding => 2,
  :align => { 0 => :left, 1 => :left, 2 => :left, 3 => :right, 4 => :right }