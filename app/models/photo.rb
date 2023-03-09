# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  integer        :string
#  likes_count    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord

  ####### I added this code #######
  # validates(:image, {presence => true})
  ####### End code #######

  has_many(:comments)
  has_many(:likes)

  mount_uploader :image, ImageUploader

end
