class Task < ActiveRecord::Base
  attr_accessible :dev_id, :result, :status, :task_code, :task_id, :task_params
end
