def foo()
  puts "the method name is " + __method__.to_s()
  puts self.methods
end
 
foo()

