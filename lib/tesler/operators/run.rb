require 'fileutils'

module Tesler
  module Operators
    # This class defines the effective copy operations
    module Run
      def set_directory(directory_name)
        Tesler::Operators::Logger.set_directory(directory_name)
        FileUtils.mkdir_p @directory_name
      end

      def copy_file(file_name, options)
        self.as(Tesler::Config.operator).copy_dir(file_name, options)
      end

      def copy_dir(file_name, options)
        # we add the destination in the options for the logger because it can't find it itself
        Tesler::Operators::Logger.copy_dir(file_name, options.merge({:destination => @directory_name}))
        
        # recursive copy
        FileUtils.cp_r file_name, "#{destination_name(file_name, options)}"
      end
    end
  end
end

