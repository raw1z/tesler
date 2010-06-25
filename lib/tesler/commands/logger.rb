module Tesler
  module Commands
    module Logger
      extend Tesler::Commands::Base
      extend self

      def set_directory(directory_name)
        if File.exists? directory_name
          Tesler::Config.output.puts "\texists\t#{directory_name}"
        else
          Tesler::Config.output.puts "\tcreate\t#{directory_name}"
        end
      end

      def copy_file(file_name, options)
        if @directory_name
          # When included itself in the copier
          base_name = options[:rename]
          base_name = File.basename(file_name) if base_name.nil?
          Tesler::Config.output.puts "\tcopy\t#{@directory_name}/#{base_name}"
        else
          # When used by another module included in the copier
          output = file_name
          if options[:rename]
            output = "#{File.dirname(file_name)}/#{options[:rename]}"
          end
          
          Tesler::Config.output.puts "\tcopy\t#{output}"
        end
      end

      def copy_dir(file_name, options)
        copy_file(file_name, options)
      end
    end
  end
end

