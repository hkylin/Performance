class Cooperation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project_modification
end
