class Relationship < ActiveRecord::Base
	belongs_to :father, class_name: 'Person'
    belongs_to :son, class_name: 'Person'

    validates :father_id, presence: true
    validates :son_id, presence: true
end