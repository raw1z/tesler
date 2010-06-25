def directory(directory_name, &block)
  Tesler::Copier.directory(directory_name.to_unix, &block)
end

def run_in_test_mode
  eval <<-EOV
    module Tesler
      class Copier
        include Tesler::Commands::Logger
      end
    end
  EOV
end

