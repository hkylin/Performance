class DepartmentsController < ApplicationController
	before_action :authenticate_user!
	def index
		@departments=current_user.departments
		@users=Array.new
		@departments.each do |x|
			x.users.each do |user|
				@users<<user
			end
		end
		
		@users.each do |x|
			puts x
		end
		@users
	end
end
