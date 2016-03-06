class Task < ActiveRecord::Base
	belongs_to :taskable,polymorphic: true
	TASK_TYPE = %w(规模 管理费 收益)  #scale management_fee profit

	validates_inclusion_of :task_type, in: TASK_TYPE
end
