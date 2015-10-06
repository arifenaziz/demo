class User < ActiveRecord::Base

  def self.from_omniauth(auth_hash)
    user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.uid = auth_hash['uid']
    user.name = auth_hash['info']['name']
    user.image_url = auth_hash['info']['image']
    user.token = auth_hash['credentials']['token']
    user.save!
    user
  end

  def delete_images
    images = Overlay.images
    s3 = Aws::S3::Resource.new(
            region:'us-east-1',
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'],
                                          ENV['AWS_SECRET_ACCESS_KEY']))
    bucket = s3.bucket(ENV['S3_BUCKET'])
    bucket.objects.delete(images)
  end
end
