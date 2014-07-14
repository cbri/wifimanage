class Contact < ActiveRecord::Base
  attr_accessible :access_node_id, :created_at, :email, :merchant, :name, :node_mac, :phonenum, :telephonenum, :updated_at, :weixin
end
