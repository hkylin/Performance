class Cooperation < ActiveRecord::Base
  belongs_to :user
  belongs_to :cooperationable, polymorphic: true
end
