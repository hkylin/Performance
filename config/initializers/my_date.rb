class Date
	def self.first_quarter
	  [Date.new(Date.current.year,1,1), Date.new(Date.current.year,4,1)]
	end
	def self.second_quarter
	  [Date.new(Date.current.year,4,1), Date.new(Date.current.year,7,1)]
	end
	def self.third_quarter
	  [Date.new(Date.current.year,7,1), Date.new(Date.current.year,10,1)]
	end
	def self.fourth_quarter
	  [Date.new(Date.current.year,10,1), Date.new(Date.current.year+1,1,1)]
	end
	def self.one_year
	  [Date.new(Date.current.year,10,1), Date.new(Date.current.year+1,1,1)]
	end
end