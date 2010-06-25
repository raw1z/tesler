module Tesler
  module Commands
    module Base
      def self.get_name(file_name, options)
        option_rename = options.delete(:rename)
        return file_name if option_rename.nil?
        "#{File.dirname(file_name)}/#{option_rename}"
      end
    end
  end
end
