require 'aws/s3'

AWS.config({
  :access_key_id => 'your_access_key_id',
  :secret_access_key => 'your_secret_access_key',
  :max_retries => 2,
})%   