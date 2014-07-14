class Nodecmd < ActiveRecord::Base
  attr_accessible :cmdline
  has_many :access_nodes
end
