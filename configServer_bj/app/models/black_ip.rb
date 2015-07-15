class BlackIp < ActiveRecord::Base
  attr_accessible :access_node_id, :publicip
  belongs_to :access_node
end
