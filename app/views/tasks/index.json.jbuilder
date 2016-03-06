json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :task_type, :amount, :profit, :description
  json.url task_url(task, format: :json)
end
