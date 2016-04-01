class Date
	def self.since_this_year
	  [Date.new(Date.current.year,1,1), Date.current]	
	end

	def self.contain
		[Date.new(2000,1,1), Date.new(2200,1,1)]	
	end

	def self.year_days
		Date.new(Date.current.year+1,1,1) - Date.new(Date.current.year,1,1)
	end

	def self.one_year
	  [Date.new(Date.current.year,1,1), Date.new(Date.current.year+1,1,1)]
	end

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

	def self.January     
		[Date.new(Date.current.year,1,1), Date.new(Date.current.year,2,1)]
	end    
	def self.February
		[Date.new(Date.current.year,2,1), Date.new(Date.current.year,3,1)]
	end
	def self.March
		[Date.new(Date.current.year,3,1), Date.new(Date.current.year,4,1)]
	end
	def self.April
		[Date.new(Date.current.year,4,1), Date.new(Date.current.year,5,1)]
	end
	def self.May
		[Date.new(Date.current.year,5,1), Date.new(Date.current.year,6,1)]
	end
	def self.June
		[Date.new(Date.current.year,6,1), Date.new(Date.current.year,7,1)]
	end
	def self.July
		[Date.new(Date.current.year,7,1), Date.new(Date.current.year,8,1)]
	end
	def self.August
		[Date.new(Date.current.year,8,1), Date.new(Date.current.year,9,1)]
	end
	def self.September
		[Date.new(Date.current.year,9,1), Date.new(Date.current.year,10,1)]
	end
	def self.October
		[Date.new(Date.current.year,10,1), Date.new(Date.current.year,11,1)]
	end
	def self.November
		[Date.new(Date.current.year,11,1), Date.new(Date.current.year,12,1)]
	end
	def self.December
		[Date.new(Date.current.year,12,1), Date.new(Date.current.year+1,1,1)]
	end
end