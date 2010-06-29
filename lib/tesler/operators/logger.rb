module Tesler
  module Operators
    # This module only logs the actions
    module Logger
      extend self

      def set_directory(directory_name)
        if File.exists? directory_name
          Tesler::Config.output.puts "\texists\t#{directory_name}"
        else
          Tesler::Config.output.puts "\tcreate\t#{directory_name}"
        end
      end

      def copy_file(file_name, options)
        self.as(Tesler::Config.operator).copy_dir(file_name, options)
      end

      def copy_dir(file_name, options)
        Tesler::Config.output.puts "\tcopy\t#{file_name}\t#{destination_name(file_name, options)}"
      end

      def self.destination_name(file_name, options)
        base_name = options[:rename]
        base_name = File.basename(file_name) if base_name.nil?
        destination = "#{options[:destination]}/#{base_name}"

        # if the directory option is set, create the sub-directory if necessary
        if options[:directory]
          FileUtils.mkdir_p "#{options[:destination]}/#{options[:directory]}"
          destination = "#{options[:destination]}/#{options[:directory]}/#{base_name}"
        end

        destination
      end
    end
  end
end

