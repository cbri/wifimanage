class Accesskey < ActiveRecord::Base
  attr_accessible :access_key_id, :public_key, :private_key

end
