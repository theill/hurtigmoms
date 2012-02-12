# encoding: utf-8

require 'net/https'
require 'uri'

module AnnexesHelper
  def render_annex(annex)
    if ['application/pdf', 'application/x-pdf'].include?(annex.attachment_content_type) || annex.attachment_file_name.ends_with?('.pdf')
  		format_as_pdf(annex)
  	elsif @annex.attachment_content_type == 'text/html' || annex.attachment_file_name.ends_with?('.html')
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
  
  def format_as(content, format)
    if format == 'mail'
      m = TMail::Mail.parse(content)
      mail_part = m.parts.find { |a| a.content_type == 'text/html' }
      if mail_part
        mail_part.body
      else
        "<pre>#{m.body}</pre>"
      end
    else
      content
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
    "<img src=\"#{annex.authenticated_url}\" />"
  end
  
  def format_as_mail(annex)
    # mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/harvest.txt")) rescue nil
    mail = TMail::Mail.parse(read_content(annex)) rescue nil
    
    if mail
      "<div id=\"mail-display\">
<div class=\"headers\">
<fieldset><label>Subject:</label> #{mail.subject}</fieldset>
<fieldset><label>From:</label> #{mail.from.to_s}</fieldset>
<fieldset><label>Date:</label> #{mail.date}</fieldset>
</div>

<iframe width=\"100%\" height=\"480\" src=\"#{preview_fiscal_year_transaction_annex_path(current_user.active_fiscal_year, annex.transaction, annex, :as => 'mail')}\"></iframe>
</div>"
    else
      "<div id=\"mail-warning-display\"><h3>Det var ikke muligt at vise denne vedhæftning</h3>
      <p>
        Vi understøtter endnu ikke formattet. Du bliver nødt til at hente vedhæftningen ned på din egen maskine for at se den.
      </p>
      </div>"
    end
  end
end