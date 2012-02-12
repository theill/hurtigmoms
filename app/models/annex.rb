# encoding: utf-8

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
  
  def authenticated_url(expires_in = 30.seconds)
    # AWS::S3::S3Object.url_for(attachment.path, attachment.bucket_name, :expires_in => expires_in, :use_ssl => attachment.s3_protocol == 'https')
    bucket = AWS::S3::Bucket.new(attachment.bucket_name)
    s3object = AWS::S3::S3Object.new(bucket, attachment.path)
    s3object.url_for(:read, :expires => expires_in, :use_ssl => attachment.s3_protocol == 'https')
  end

  def google_viewer_url
    "http://docs.google.com/viewer?url=#{CGI::escape(self.authenticated_url)}&embedded=true"
  end
  
end