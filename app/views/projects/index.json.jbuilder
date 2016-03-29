json.array!(@projects) do |project|
  json.extract! project, :id, :plan_id, :name, :this_amount, :year_amount, :start_date, :end_date, :management_fee, :investment_manager, :a_class, :b_class, :department_id, :rate, :fee, :notes
  json.url project_url(project, format: :json)
end
