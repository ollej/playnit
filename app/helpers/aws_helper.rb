require 'base64'
require 'json'
require 'digest/sha1'

module AwsHelper
  def aws_access_key_id
    ENV['AWS_ACCESS_KEY_ID']
  end

  def aws_secret_access_key
    ENV['AWS_SECRET_ACCESS_KEY']
  end

  def aws_bucket
    ENV['AWS_BUCKET']
  end

  def aws_upload_path
    "uploads"
  end

  def aws_acl
    "public-read"
  end

  def aws_endpoint
    "https://#{aws_bucket}.s3-eu-west-1.amazonaws.com:443"
  end

  def aws_policy
    conditions = [
      ["starts-with", "$utf8", ""],
      ["starts-with", "$key", aws_upload_path],
      ["starts-with", "$filename", ""],
      ["starts-with", "$name", ""],
      ["starts-with", "$authenticity_token", ""],
      ["starts-with", "$success_action_status", ""],
      { "bucket" => aws_bucket },
      { "acl" => aws_acl }
    ]

    policy = {
      'expiration' => (Time.now.utc + 3600 * 3).iso8601,
      'conditions' => conditions
    }

    Base64.encode64(JSON.dump(policy)).gsub("\n","")
  end

  def aws_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        aws_secret_access_key, aws_policy
      )
    ).gsub("\n","")
  end
end
