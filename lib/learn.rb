# def foo()
#   puts "the method name is " + __method__.to_s()
#   puts self.methods
# end
 
# foo()


class A
	def initialize(name)
		@name=name
		@aas=Array.new()
	end
	def init
		@aas<<A.new('1111')
		@aas<<A.new('2222')
		@aas<<A.new('3333')
	end
	def doit
		if(@aas.length > 0)
			@aas.each do |a|
				a.doit
			end
		end
		puts @name
	end


	def doit2
		
		puts "#{@name}#{@name}"
	end

	def xx()
		if(@aas.length > 0)
			@aas.each do |a|
				a.doit2
			end
		end
	end

	def bt_start_ends(bt)
		rt=Array.new
		a=bt[0].year
		b=bt[1].year
		return rt << [bt[0],bt[1],year_annual(a)] if (a==b)
		while a < b do 
			if(a == bt[0].year) #循环中的第一年
				rt << [bt[0], Date.new(a,12,31), year_annual(a)]
			else
				rt << [Date.new(a-1,12,31), Date.new(a,12,31), year_annual(a)]
			end
			a+=1
		end
		rt << [Date.new(a-1,12,31),bt[1],year_annual(a)] if (a==b)
		return rt
	end

	def year_annual(year)
		(Date.new(year,12,31)-Date.new(year-1,12,31)).to_i
	end
    
end


a=A.new('xxxx')
a.init
a.doit
a.doit2

puts Date.new(2000,1,1)
puts a.bt_start_ends [Date.new(Date.current.year,1,1), Date.current]
puts ' '
puts a.bt_start_ends [Date.new(Date.current.year-1,1,1), Date.current]
puts ' '
puts a.bt_start_ends [Date.new(Date.current.year-2,1,1), Date.current]
puts ' '
puts a.bt_start_ends [Date.new(Date.current.year-3,6,1), Date.current]
puts ' '