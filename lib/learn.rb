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
end

a=A.new('xxxx')
a.init
a.doit
a.doit2