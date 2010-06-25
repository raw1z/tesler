require 'fileutils'

module Tesler
  module Commands
    module Run
      extend Tesler::Commands::Base

      def set_directory(directory_name)
        Tesler::Commands::Logger.set_directory(directory_name)
        
        # create the directory if it doesn't exist
        FileUtils.mkdir_p @directory_name
      end

      def copy_file(file_name, options)
        copy_dir(file_name, options)
      end

      def copy_dir(file_name, options)
        # even if the rename option is set, we send the old filename and the rename option to the logger. It will rename the file itself.
        dest_file_name = "#{@directory_name}/#{File.basename(file_name)}"
        Tesler::Commands::Logger.copy_dir(dest_file_name, options)

        # change the destination filename if needed
        if options[:rename]
          dest_file_name = "#{@directory_name}/#{options[:rename]}"
        end
        
        # recursive copy
        FileUtils.cp_r file_name, dest_file_name
      end
    end
  end
end

