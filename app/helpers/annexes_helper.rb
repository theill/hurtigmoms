require 'net/https'
require 'uri'

module AnnexesHelper
  def render_annex(annex)
    if ['application/pdf', 'application/x-pdf'].include?(annex.attachment_content_type)
  		format_as_pdf(annex)
  	elsif @annex.attachment_content_type == 'text/html'
  		format_as_html(annex)
		elsif ['image/jpg', 'image/png', 'image/gif'].include?(@annex.attachment_content_type)
		  format_as_image(annex)
		else
  		format_as_mail(annex)
  	end
  end
  
  def read_content(annex)
    msg = open(annex.authenticated_url)
    if msg.class == StringIO
      msg.string
    elsif msg.class == Tempfile
      msg.read
    else
      nil
    end
  end

  private
  
  def format_as_pdf(annex)
    "<iframe width=\"100%\" height=\"480\" src=\"#{annex.google_viewer_url}\"></iframe>"
  end
  
  def format_as_html(annex)
    "<iframe width=\"100%\" height=\"480\" src=\"#{preview_fiscal_year_transaction_annex_path(current_user.active_fiscal_year, annex.transaction, annex)}\"></iframe>"
  end
  
  def format_as_image(annex)
    "<img src=\"" + annex.authenticated_url + "\" />"
  end
  
  def format_as_mail(annex)
    # msg = File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt")
    mail = TMail::Mail.parse(read_content(annex)) rescue nil
    
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