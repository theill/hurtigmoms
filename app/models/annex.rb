class Annex < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 'amazon_s3.yml'),
    :s3_permissions => 'authenticated-read',
    :url => ':s3_domain_url',
    :path => 'users/:user_id/attachments/:id/:basename.:extension',
    :bucket => 'hurtigmoms'
  
end