module Rcqrs

  class BaseCommand
    include ActiveModel::Validations
        
    def initialize(attributes = {})
      attributes.each do |name, value|
        instance_variable_set("@" + name.to_s, value)
      end
    end
    
    def errormessages
      errormessages = Array.new
      errors.each do |attribute, message|
        errormessages << message
      end
      errormessages
    end  
  
  end

end