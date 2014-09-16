class Address < ActiveRecord::Base
  attr_accessible :access_node_id, :city, :detail, :district, :province
  belongs_to :access_node

  validates :access_node_id, presence: true
end
