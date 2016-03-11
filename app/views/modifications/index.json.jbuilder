json.array!(@modifications) do |modification|
  json.extract! modification, :id, :project_id, :start_date, :end_date, :management_fee, :rate, :fee, :notes
  json.url modification_url(modification, format: :json)
end
