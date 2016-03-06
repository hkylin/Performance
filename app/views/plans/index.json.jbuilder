json.array!(@plans) do |plan|
  json.extract! plan, :id, :number, :name, :this_amount, :year_amount, :start_date, :end_date, :management_fee, :investment_manager, :a_class, :b_class, :department_id, :rate, :fee, :notes
  json.url plan_url(plan, format: :json)
end
