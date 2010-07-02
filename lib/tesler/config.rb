module Tesler
  # This module contains all the configuration variables used by tesler
  module Config

    # Get the standard output. The output is an object who must respond to the 'puts' method. By default it is set to STDOUT
    def self.output
      @output ||= STDOUT
    end

    # Set the standard output.
    def self.output=(output)
      @output = output
    end

    # Get the source directory. It is the directory where all the files that we are copying , are taken from.
    def self.source_directory
      @source_directory ||= ''
    end

    # Set the source directory
    def self.source_directory=(directory_name)
      @source_directory = directory_name.tesler
    end

    # get the module which performs the copy operations
    def self.operator
      @operator ||= Tesler::Operators::Run
    end

    # define the module which performs the copy operations
    def self.operator=(op)
      @operator = op
    end

    # Reinitializes the configuration
    def self.reset
      @output = nil
      @source_directory = nil
      @operator = nil
    end
  end
end
