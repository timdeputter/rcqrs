module Kernel
  
  def mockup()
    Rickomock.new
  end
  
  def any expectedType = BasicObject
    AnyArgumentMatcher.new expectedType
  end
end

class Rickomock
  
  def initialize
    @calls = Hash.new
  end
  
  def method_missing(m, *args, &block)
      if @calls.has_key? m
        @calls[m].addCall(args)
      else
        @calls[m] = MethodCall.new args
      end
      if block != nil
        block.call
      end
  end

  def hasReceivedMessage(method,count,args)
    if @calls.has_key? method
        return @calls[method].HasInvocationsWith(count, args)
    end
    count == 0
  end
  
  def realInvocationMessage
    if @calls.empty?
      return "no invocation at all"
    else
      result = String.new
      @calls.each do |methodname, method_call|
        result << (methodname.to_s + " " + method_call.invocation_message)
      end
      return result
    end
  end

  
  def message method
    Verification.new method, self
  end  
end

class AnyArgumentMatcher
  
  def initialize expectedType
    @expectedType = expectedType
  end
  
  def ==(other)
    other.is_a? @expectedType
  end
  
  def to_s
    if @expectedType == BasicObject
      return "any Argument"
    else
      return "any Argument of type: " + @expectedType.to_s
    end
  end
  
end

class Verification
  def initialize method, mock
    @method,@mock = method,mock
    @count = 1
  end
  
  def with(*args)
    @args = args
    self 
  end
  
  def times(count)
    @count = count
    self
  end
  
  def once
    times(1)
  end
  
  def never
    times(0)
  end
  
  def should_be_received
    unless @mock.hasReceivedMessage(@method,@count,@args)
      raise InvocationExpectationError.new buildErrorMessage
    end
  end
  
  def buildErrorMessage
    "Expected to receive '" + @method.to_s + "' " + invocationCountMessage + " with " + expectedArguments + " but received " + @mock.realInvocationMessage
  end
  
  def invocationCountMessage
    if @count == 1
      return "once"
    end
    return @count.to_s + " times"
  end
  
  def expectedArguments
    if @args == nil
      return " no arguments"      
    else
      result = "("
      @args.each do |arg|
        result << (arg.to_s + ":" + arg.class.to_s + ", ")
      end
      result = result[0..-3]
      result << ")"
    end
  end
end


class MethodCall
  
  def initialize arguments
    @callCount = 1
    @args = [arguments]
  end
  
  def addCall arguments
    @callCount += 1
    @args << arguments   
  end
  
  def HasInvocationsWith(count,args)
    has = @callCount == count
    if args != nil
      @args.each do |arguments|
        has &= checkArgs(args,arguments)
      end
    end
    has
  end
  
  def checkArgs(expectedArguments,actualArguments)
    if(expectedArguments.length != actualArguments.length)
      return false
    end
    sameArguments = true
    expectedArguments.length.times do |i|
      sameArguments &= (expectedArguments[i] == actualArguments[i])
    end
    sameArguments
  end

  
  def invocation_message
    result = "called " + @callCount.to_s + " with arguments: "
    @args.each do |arguments|
      result << "("
      arguments.each do |arg|
        result << (arg.to_s + ":" + arg.class.to_s + ", ")
      end
      result = result[0..-3]
      result << ")"
    end
    result
  end
end

class InvocationExpectationError < StandardError
  
end

