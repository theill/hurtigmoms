require 'aws/s3'

class Annex < ActiveRecord::Base
  belongs_to :transaction
  
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 'amazon_s3.yml'),
    :s3_permissions => 'authenticated-read',
    :url => ':s3_domain_url',
    :path => 'users/:user_id/attachments/:id/:basename.:extension',
    :s3_headers => { :content_disposition => 'attachment' }
  
  def authenticated_url(expires_in = 10.seconds)
    AWS::S3::S3Object.url_for(attachment.path, attachment.bucket_name, :expires_in => expires_in, :use_ssl => attachment.s3_protocol == 'https')
  end

end