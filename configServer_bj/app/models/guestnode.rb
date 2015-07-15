class Guestnode < ActiveRecord::Base
  attr_accessible :access_node_id, :guest_id
  validates :access_node_id, presence: true
end
