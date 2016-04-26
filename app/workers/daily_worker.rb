class DailyWorker  #参考http://www.jianshu.com/p/80d481292c3c
	include Sidekiq::Worker
	include Sidetiq::Schedulable
	recurrence do
		# 每晚12点   
		daily 
		# minutely(15)
	end
	def perform
	  jh=Department.find_by_name('金融合作事业部')
	  logger.info "#{jh}  执行计算  更新计算参数"
	  jh.back_calc
	  logger.info "#{jh.income_current}  执行计算  更新计算参数"
	  jh.save

	  Plan.all.each do |p|
	  	p.back_calc
	  	p.save
	  end
	end
end