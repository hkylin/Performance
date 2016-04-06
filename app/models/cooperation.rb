class Cooperation < ActiveRecord::Base
  belongs_to :user
  CO_TYPE = %w(承揽 承做)  
  validates_inclusion_of :CO_type, in: CO_TYPE
  belongs_to :cooperationable, polymorphic: true, inverse_of: :cooperations
end
