module ApplicationHelper
  def find_departments
  	Department.all.collect { |type| [type.name, type.id] } 
  end  

  def find_plans
  	Plan.all.collect { |plan| [plan.name, plan.id] } 
  end  

  def first_start #why model 不能使用?
  	Date.new(Date.current.year,1,1)
  end

  def f2(decimal_data)
		# format("%0.2f",decimal_data) 
    number_to_currency(decimal_data, :unit=>"￥")
  end
end
