class Log < ActiveRecord::Base
  attr_accessible :dev_id, :time,:user,:client_mac,:log_type,:log_value
end
