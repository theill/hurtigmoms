module AnnexesHelper
  def format_as_plain_text(annex)
    mail = TMail::Mail.parse(annex.authenticated_url)
    # mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt"))
    
    unless mail || mail.body.empty?
      "<div id=\"mail-display\"><fieldset><label>Subject:</label> #{mail.subject}</fieldset>
<fieldset><label>From:</label> #{mail.from.to_s}</fieldset>
<fieldset><label>Date:</label> #{mail.date}</fieldset>

<pre>#{mail.body}</pre></div>"
    else
      "<div id=\"mail-display\">This mail could not be parsed.</div>"
    end
  end
end
