module Tesler
  module Operators
    module Base
      def destination_name(file_name, options)
        base_name = options[:rename]
        base_name = File.basename(file_name) if base_name.nil?
        "#{@directory_name}/#{base_name}"
      end
    end
  end
end
