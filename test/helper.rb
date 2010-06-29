require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'tesler'

class Test::Unit::TestCase
end

# This class simulate the standard output
class Output
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end
end

