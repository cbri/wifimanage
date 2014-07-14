class Address < ActiveRecord::Base
  attr_accessible :access_node_id, :city, :detail, :district, :province

  validates :access_node_id, presence: true
end
