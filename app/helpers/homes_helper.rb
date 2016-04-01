module HomesHelper
	def f2(decimal_data)
		logger.info "------decimal_data: #{decimal_data}-------"
		format("%0.2f",decimal_data) 
	end

	def wan(scale)
		(scale/10000).to_s+"万"	
	end
end
