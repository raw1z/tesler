module Tesler
  module Operators
    module Base
      def destination_name(file_name, options)
        base_name = options[:rename]
        base_name = File.basename(file_name) if base_name.nil?
        destination = "#{@directory_name}/#{base_name}"

        # if the directory option is set, create the sub-directory if necessary
        if options[:directory]
          FileUtils.mkdir_p "#{@directory_name}/#{options[:directory]}"
          destination = "#{@directory_name}/#{options[:directory]}/#{base_name}"
        end

        destination
      end
    end
  end
end
