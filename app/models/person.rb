class Person < ActiveRecord::Base	
    has_many :son_relationships, class_name: "Relationship",
                                    foreign_key: 'father_id',
                                    dependent: :destroy
    has_one :father_relationships, class_name: "Relationship",
                                  foreign_key: 'son_id',
                                  dependent: :destroy                                  

    has_many :sons, through: :son_relationships, source: :son                               
    has_one :father, through: :father_relationships, source: :father

end
