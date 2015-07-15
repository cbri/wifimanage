class Nodecmd < ActiveRecord::Base
  attr_accessible :cmdline,:task_params , :task_code
  has_many :access_nodes
end
