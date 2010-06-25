module Tesler
  class Copier
    include Tesler::Commands::Run

    def  initialize(directory_name)
      @directory_name = directory_name
      set_directory(@directory_name)
    end

    def copy(file_name, options={})
      if File.directory? file_name.to_unix
        copy_dir(file_name.to_unix, options)
      else
        copy_file(file_name.to_unix, options)
      end
    end

    def directory(directory_name, &block)
      copier = Copier.new("#{@directory_name}/#{directory_name}")
      copier.instance_eval(&block)
    end

    def self.directory(directory_name, &block)
      copier = Copier.new(directory_name)
      copier.instance_eval(&block)
    end
  end
end

