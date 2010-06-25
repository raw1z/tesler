module Tesler
  module Config
    def self.output
      @output ||= STDOUT
    end

    def self.output=(output)
      @output = output
    end
  end
end
