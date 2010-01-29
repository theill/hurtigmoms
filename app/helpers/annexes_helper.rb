require 'net/https'
require 'uri'

module AnnexesHelper
  def format_as_plain_text(annex)
    # msg = File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt")
    msg = open(annex.authenticated_url).string
    mail = TMail::Mail.parse(msg)
    
    if mail
      "<div id=\"mail-display\">
<div class=\"headers\">
<fieldset><label>Subject:</label> #{mail.subject}</fieldset>
<fieldset><label>From:</label> #{mail.from.to_s}</fieldset>
<fieldset><label>Date:</label> #{mail.date}</fieldset>
</div>

<pre>#{mail.body}</pre></div>"
    else
      "<div id=\"mail-warning-display\"><h3>Det var ikke muligt at vise denne besked</h3>
      <p>
        Vi understøtter endnu ikke formattet på denne besked. Du bliver nødt 
        til at hente beskeden ned på din egen maskine for at se det.
      </p>
      </div>"
    end
  end
end
