class Contact < ActiveRecord::Base
  attr_accessible :access_node_id, :merchant, :name, :phonenum, :telephonenum,:email,:weixin

  validates :access_node_id, presence: true
end
