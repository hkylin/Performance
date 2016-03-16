module HomesHelper
	def f2(decimal_data)
		logger.info "------decimal_data: #{decimal_data}-------"
		format("%0.2f",decimal_data) 
	end
	def first_quarter
	  [Date.new(Date.current.year,1,1), Date.new(Date.current.year,4,1)]
	end
	def second_quarter
	  [Date.new(Date.current.year,4,1), Date.new(Date.current.year,7,1)]
	end
	def third_quarter
	  [Date.new(Date.current.year,7,1), Date.new(Date.current.year,10,1)]
	end
	def fourth_quarter
	  [Date.new(Date.current.year,10,1), Date.new(Date.current.year+1,1,1)]
	end
	def one_year
	  [Date.new(Date.current.year,10,1), Date.new(Date.current.year+1,1,1)]
	end

	def wan(scale)
		(scale/10000).to_s+"万"	
	end

end
