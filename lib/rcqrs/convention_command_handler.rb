module Rcqrs

  class ConventionCommandHandler < Rcqrs::BaseCommandHandler
    
    def execute command
      account = repository.load(command.aggregate,command.aggregate_id)
      methodname = get_method_name_from_command command
      if(command.data.empty?)
        account.send(methodname)      
      else
        account.send(methodname, command.data)
      end
      repository.save(account)
    end
    
    def get_method_name_from_command command
      words = command.class.name.split(%r{[A-Z]})
      first_letters = command.class.name.scan(%r{[A-Z]})
      result = String.new
      words.shift
      0.upto(words.size-2) do |i|
        result << first_letters[i].downcase + words[i] + "_"  
      end
      result[0..-2]
    end
    
  end

end