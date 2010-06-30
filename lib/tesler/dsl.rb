# sets a directory where to copy files. If this directory doesn't exist, it is created
def directory(directory_name, &block)
  Tesler::Copier.directory(directory_name.tesler, &block)
end

# sets the directory where the file that we are copying, are taken from
def source_directory(directory_name)
  Tesler::Config.source_directory = directory_name
end

# reinitializes the configuration
def reset_config
  Tesler::Config.reset
end

# in test mode, tesler only logs its actions without effectively copying the files
def run_in_test_mode
  Tesler::Config.operator = Tesler::Operators::Logger
end

