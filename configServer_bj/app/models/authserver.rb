class Authserver < ActiveRecord::Base
  attr_accessible :access_node_id, :ipaddr, :node_mac
  belongs_to :access_node

  validates :access_node_id,:ipaddr,:node_mac, presence: true
end
