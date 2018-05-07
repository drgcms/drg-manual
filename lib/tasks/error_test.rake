class TestCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :text,  type: String
  validates :text,   presence: true 
end

namespace :error do
  desc "Simulate error in mongoid 7.0.0"
  task :simulate => :environment do
    test = TestCollection.new(
      text: 'text'
    )
    test.save
  end
end