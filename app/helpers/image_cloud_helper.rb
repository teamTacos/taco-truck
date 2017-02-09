require 'cloudinary'

module ImageCloudHelper
  def self.remove_images_by_id(images)
    id_groups = collect_ids(images)
    id_groups.each do |ids|
      Cloudinary::Api.delete_resources(ids, auth)
    end
  end

  private

  def self.collect_ids(images)
    id_array = images.collect{|u| u.cloudinary_id}
    id_array.each_slice(100)
  end

  def self.auth
    #TODO Lets get these in the env variables.
    {
        cloud_name: "dfavubcrx",
        api_key: "832385562517142",
        api_secret: "NKqWz7EfV92b56DCzzx_JjN6NDc"
    }
  end
end