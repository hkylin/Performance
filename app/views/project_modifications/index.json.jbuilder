json.array!(@project_modifications) do |project_modification|
  json.extract! project_modification, :id, :project_id, :start_date, :end_date, :management_fee, :rate, :fee, :notes
  json.url project_modification_url(project_modification, format: :json)
end
