class Cooperation < ActiveRecord::Base
  belongs_to :user
  CO_TYPE = %w(承做 承揽)  
  validates_inclusion_of :co_type, in: CO_TYPE
  validates_numericality_of :ratio, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 1.0, :message => "比例是项目承接过程中的合理比例，该数值介于0与1之间的值，请合理设置",:allow_blank => true  # 最少 2 
  belongs_to :cooperationable, polymorphic: true, inverse_of: :cooperations
end
