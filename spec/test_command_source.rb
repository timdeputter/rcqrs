class TestCommandSource
  include Rcqrs::CommandSource; 
  def eventbus; TestEventBus; end
end
