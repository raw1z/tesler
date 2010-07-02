module Tesler
  # This the class which receives the DSL commands.
  class Copier
    include Tesler::Operators::Base
    include Tesler::Operators::Logger
    include Tesler::Operators::Run

    def  initialize(directory_name)
      @directory_name = directory_name
      self.as(Tesler::Config.operator).set_directory(@directory_name)
    end

    # Method called by the DSL method 'copy'
    def copy(file_name, options={})
      filename = file_name.tesler
      if not Tesler::Config.source_directory.blank?
        filename = "#{Tesler::Config.source_directory}/#{filename}"
      end
      
      # if the file's name contains a star, then it is considered as a regular expression
      if filename.include? "*"
        regexp_copy(filename, options)

      # the file's name is not a regular expression, so we copy it directly
      else
        direct_copy(filename, options)
      end
    end

    # This method create a sub-directory
    def directory(directory_name, &block)
      copier = Copier.new("#{@directory_name}/#{directory_name}")
      copier.instance_eval(&block)
    end

    # Method called by the DSL method 'directory'
    def self.directory(directory_name, &block)
      copier = Copier.new(directory_name)
      copier.instance_eval(&block)
    end

    private
    
    # Analyses a regular expression and generate the list of file to copy
    def regexp_copy(filename, options)
      dirname = File.dirname(filename)
      basename = File.basename(filename)
      
      # generation of the ruby regexp corresponding to the file regexp
      r = Regexp.new('^' + basename.gsub(/\./, '\.').gsub(/\*/, '(.*)') + '$')

      # check if the directory exists
      if not File.exists?(dirname)
        Tesler::Config.output.puts "\tnot found\t#{dirname}"
        return
      end
      
      Dir.entries(dirname).each do |entry|
        next if %(. ..).include?(entry)

        # when were processing regular expressions, the :rename option is ignored
        options.delete(:rename)
        direct_copy("#{dirname}/#{entry}", options) if entry =~ r
      end
    end

    # This method checks if we're working whith a file or a directory and perform the corresponding copy operation
    def direct_copy(filename, options)
      if File.directory? filename
        self.as(Tesler::Config.operator).copy_dir(filename, options)

      elsif File.exists? filename
        self.as(Tesler::Config.operator).copy_file(filename, options)

      else
        Tesler::Config.output.puts "\tnot found\t#{filename}"
      end
    end
  end
end

