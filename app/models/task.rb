class Task < ActiveRecord::Base
	belongs_to :taskable, polymorphic: true
	TASK_TYPE = %w(规模 管理费)  #scale management_fee profit

	validates_inclusion_of :task_type, in: TASK_TYPE
	validates_presence_of :start_date, :end_date, :task_type,:message => "不能为空"
	validates_length_of :name, :minimum => 4, :message => "名称最少4个字节" # 最少 2 
	validates_numericality_of :amount ,:message => "规模字段不为数字"

end
