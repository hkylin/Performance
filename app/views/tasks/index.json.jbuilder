json.array!(@tasks) do |task|
  json.extract! task, :id, :year, :amount, :profit
  json.url task_url(task, format: :json)
end
