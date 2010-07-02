$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tesler'

# delete destination directory
FileUtils.rm_r("dest") if File.exists?("dest")

directory 'dest' do

  # copy files into the dest dir
  copy 'src\file1'
  copy 'src\file2'
  copy 'src\subdir1\file4'

  # create a sub-directory and copy files into it
  directory 'subdir1' do
    copy 'src\file3'
    copy 'src\subdir1\file5'
    
    # a sub-directory in the sub-directory
    directory 'subdir3' do
      copy 'src\file8'

      # copy a file and rename it
      copy 'src\file9', :rename => 'renamed'
      
      # copie d'un ensemble de fichiers
      copy 'test\src\*.test'
    end
  end

  # copy an entire directory
  copy 'src\subdir2'

  # copy an entire directory and rename it
  copy 'src\subdir2', :rename => 'renamed'

  # file pattern support
  copy 'test\src\reg_*.test'
end



