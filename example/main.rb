$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tesler'

# on supprime le repertoire de destination
FileUtils.rm_r("dest") if File.exists?("dest")

directory 'dest' do

  # copie de fichiers dans le dossier de destination
  copy 'src\file1'
  copy 'src\file2'
  copy 'src\subdir1\file4'

  # creation d'un sous-dossier dans le dossier de destination
  directory 'subdir1' do
    copy 'src\file3'
    copy 'src\subdir1\file5'

    # copie avec un chemin absolu
    copy 'c:\temp'
    
    # sous-dossier dans le sous-dossier
    directory 'subdir3' do
      copy 'src\file8'

      # copie d'un fichier en le renommant
      copy 'src\file9', :rename => 'renamed'
      
      # copie d'un ensemble de fichiers
      copy 'test\src\*.test'
    end
  end

  # copie d'un dossier entier
  copy 'src\subdir2'

  # copie d'un dossier entier en le renommant
  copy 'src\subdir2', :rename => 'renamed'

  # copie d'un ensemble de fichiers
  copy 'test\src\reg_*.test'
end



