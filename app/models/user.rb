# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many(:photos)
  has_many(:follow_requests)

  def own_photos
    my_id = self.id

    matching_photos = Photo.where({ :owner_id => my_id })

    return matching_photos
  end

  def sent_follow_requests
    my_id = self.id

    matching_follow_requests = FollowRequest.where({ :sender_id => my_id })

    return matching_follow_requests
  end

  def received_follow_requests
    my_id = self.id

    matching_follow_requests = FollowRequest.where({ :recipient_id => my_id })

    return matching_follow_requests
  end

  def accepted_sent_follow_requests
    my_sent_follow_requests = self.sent_follow_requests

    matching_follow_requests = my_sent_follow_requests.where({ :status => "accepted" })

    return matching_follow_requests
  end

  def accepted_received_follow_requests
    my_received_follow_requests = self.received_follow_requests

    matching_follow_requests = my_received_follow_requests.where({ :status => "accepted" })

    return matching_follow_requests
  end

  def followers
    my_accepted_received_follow_requests = self.accepted_received_follow_requests
    
    array_of_user_ids = Array.new

    my_accepted_received_follow_requests.each do |a_follow_request|
      array_of_user_ids.push(a_follow_request.sender_id)
    end

    matching_users = User.where({ :id => array_of_user_ids })

    return matching_users
  end

  def leaders
    my_accepted_sent_follow_requests = self.accepted_sent_follow_requests
    
    array_of_user_ids = Array.new

    my_accepted_sent_follow_requests.each do |a_follow_request|
      array_of_user_ids.push(a_follow_request.recipient_id)
    end

    matching_users = User.where({ :id => array_of_user_ids })

    return matching_users
  end

  def feed
    array_of_photo_ids = Array.new

    my_leaders = self.leaders
    
    my_leaders.each do |a_user|
      leader_own_photos = a_user.own_photos

      leader_own_photos.each do |a_photo|
        array_of_photo_ids.push(a_photo.id)
      end
    end

    matching_photos = Photo.where({ :id => array_of_photo_ids })

    return matching_photos
  end

  
end
