class Task < ActiveRecord::Base
	belongs_to :taskable, polymorphic: true
	validates_presence_of :year,:message => "不能为空,任务年份，例如2016"
	# TODO year 输入检测
	validates_numericality_of :amount ,:message => "规模字段不为数字"
	validates_numericality_of :profit ,:message => "规模字段不为数字"
end
