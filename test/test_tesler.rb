require 'helper'

class TestTesler < Test::Unit::TestCase
  def setup
    # reinitialize tesler
    reset_config

    # assign a mock of the standar output to tesler
    @output = Output.new
    Tesler::Config.output = @output
  end

  should "copy files" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/1") if File.exists?("test/dest/1")
    
    directory 'test\dest\1' do
      copy 'test\src\file1'
      copy 'test\src\file2'
      copy 'test\src\subdir1\file4'
    
      directory 'subdir1' do
        copy 'test\src\file3'
        copy 'test\src\subdir1\file5'
        
        directory 'subdir3' do
          copy 'test\src\file1'
        end
      end

      copy 'test\src\file2', :directory => 'subdir4'
    end

    assert File.exists?("test/dest/1/file1")
    assert File.exists?("test/dest/1/file2")
    assert File.exists?("test/dest/1/file4")
    assert File.exists?("test/dest/1/subdir1/file3")
    assert File.exists?("test/dest/1/subdir1/file5")
    assert File.exists?("test/dest/1/subdir1/subdir3/file1")
    assert File.exists?("test/dest/1/subdir4/file2")
  end

  should "copy entire directories" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/2") if File.exists?("test/dest/2")

    directory 'test\dest\2' do
      copy 'test\src\subdir2'
    end
    
    assert File.exists?("test/dest/2/subdir2")
  end

  should "support the renaming of the files and directories which are copied" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/3") if File.exists?("test/dest/3")

    directory 'test\dest\3' do
      directory 'subdir1' do
        directory 'subdir3' do
          copy 'test\src\file1', :rename => 'file1_renamed'
        end
      end
    
      copy 'test\src\subdir2', :rename => 'subdir2_renamed'
    end
    
    assert File.exists?("test/dest/3/subdir1/subdir3/file1_renamed")
    assert File.exists?("test/dest/3/subdir2_renamed")
  end

  should "support regular expressions on the filenames" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/4") if File.exists?("test/dest/4")

    directory 'test\dest\4' do
      directory 'subdir1' do
        directory 'subdir3' do
          copy 'test\src\*.test'
        end
      end

      copy 'test\src\reg_*.test'
      copy 'test\src\reg_*.test', :directory => 'subdir2'
    end

    assert File.exists?("test/dest/4/subdir1/subdir3/noreg_1.test")
    assert File.exists?("test/dest/4/subdir1/subdir3/noreg_2.test")
    assert File.exists?("test/dest/4/subdir1/subdir3/reg_1.test")
    assert File.exists?("test/dest/4/subdir1/subdir3/reg_2.test")
    assert File.exists?("test/dest/4/subdir1/subdir3/reg_3.test")
    assert File.exists?("test/dest/4/reg_1.test") 
    assert File.exists?("test/dest/4/reg_2.test") 
    assert File.exists?("test/dest/4/reg_3.test") 
    assert File.exists?("test/dest/4/subdir2/reg_1.test") 
    assert File.exists?("test/dest/4/subdir2/reg_2.test") 
    assert File.exists?("test/dest/4/subdir2/reg_3.test") 
  end

  should "log its actions" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/5") if File.exists?("test/dest/5")

    directory 'test\dest\5' do
      copy 'test\src\file1'
      copy 'test\src\file2'
      copy 'test\src\subdir1\file4'
    
      directory 'subdir1' do
        copy 'test\src\file3'
        copy 'test\src\subdir1\file5'
        
        directory 'subdir3' do
          copy 'test\src\file1'
          copy 'test\src\file2', :rename => 'file2_renamed'
          copy 'test\src\*.test'
        end
      end
      
      copy 'test\src\subdir2'
      copy 'test\src\subdir2', :rename => 'subdir2_renamed'
      copy 'test\src\reg_*.test'
      copy 'test\src\file2', :directory => 'subdir4'
    end

    messages = @output.messages.map { |m| m.strip }
    assert_match  /(create|exists)\ttest\/dest\/5/, messages[0]
    assert_equal  "copy\ttest/src/file1\ttest/dest/5/file1", messages[1]
    assert_equal  "copy\ttest/src/file2\ttest/dest/5/file2", messages[2]
    assert_equal  "copy\ttest/src/subdir1/file4\ttest/dest/5/file4", messages[3]
    assert_match  /(create|exists)\ttest\/dest\/5\/subdir1/, messages[4]
    assert_equal  "copy\ttest/src/file3\ttest/dest/5/subdir1/file3", messages[5]
    assert_equal  "copy\ttest/src/subdir1/file5\ttest/dest/5/subdir1/file5", messages[6]
    assert_match  /(create|exists)\ttest\/dest\/5\/subdir1\/subdir3/, messages[7]
    assert_equal  "copy\ttest/src/file1\ttest/dest/5/subdir1/subdir3/file1", messages[8]
    assert_equal  "copy\ttest/src/file2\ttest/dest/5/subdir1/subdir3/file2_renamed", messages[9]
    assert_equal  "copy\ttest/src/noreg_1.test\ttest/dest/5/subdir1/subdir3/noreg_1.test", messages[10]
    assert_equal  "copy\ttest/src/noreg_2.test\ttest/dest/5/subdir1/subdir3/noreg_2.test", messages[11]
    assert_equal  "copy\ttest/src/reg_1.test\ttest/dest/5/subdir1/subdir3/reg_1.test", messages[12]
    assert_equal  "copy\ttest/src/reg_2.test\ttest/dest/5/subdir1/subdir3/reg_2.test", messages[13]
    assert_equal  "copy\ttest/src/reg_3.test\ttest/dest/5/subdir1/subdir3/reg_3.test", messages[14]
    assert_equal  "copy\ttest/src/subdir2\ttest/dest/5/subdir2", messages[15]
    assert_equal  "copy\ttest/src/subdir2\ttest/dest/5/subdir2_renamed", messages[16]
    assert_equal  "copy\ttest/src/reg_1.test\ttest/dest/5/reg_1.test", messages[17]
    assert_equal  "copy\ttest/src/reg_2.test\ttest/dest/5/reg_2.test", messages[18]
    assert_equal  "copy\ttest/src/reg_3.test\ttest/dest/5/reg_3.test", messages[19]
    assert_equal  "copy\ttest/src/file2\ttest/dest/5/subdir4/file2", messages[20]
  end

  should "copy files" do
    assert File.exists?("test/dest")
    assert File.exists?("test/dest/file1")
    assert File.exists?("test/dest/file2")
    assert File.exists?("test/dest/file4")
    assert File.exists?("test/dest/subdir1")
    assert File.exists?("test/dest/subdir1/file3")
    assert File.exists?("test/dest/subdir1/file5")
    assert File.exists?("test/dest/subdir1/subdir3")
    assert File.exists?("test/dest/subdir1/subdir3/file8")
    assert File.exists?("test/dest/subdir1/subdir3/renamed")
    assert File.exists?("test/dest/subdir2")
    assert File.exists?("test/dest/renamed") 

    assert File.exists?("test/dest/6")
    assert File.exists?("test/dest/6/file1")
    assert File.exists?("test/dest/6/file2")
    assert File.exists?("test/dest/6/file4")
    assert File.exists?("test/dest/6/subdir1")
    assert File.exists?("test/dest/6/subdir1/file3")
    assert File.exists?("test/dest/6/subdir1/file5")
    assert File.exists?("test/dest/6/subdir1/subdir3")
    assert File.exists?("test/dest/6/subdir1/subdir3/file1")
    assert File.exists?("test/dest/6/subdir1/subdir3/file2_renamed")
    assert File.exists?("test/dest/6/subdir2")
    assert File.exists?("test/dest/6/subdir2_renamed") 
    assert File.exists?("test/dest/6/subdir1/subdir3/noreg_1.test")
    assert File.exists?("test/dest/6/subdir1/subdir3/noreg_2.test")
    assert File.exists?("test/dest/6/subdir1/subdir3/reg_1.test")
    assert File.exists?("test/dest/6/subdir1/subdir3/reg_2.test")
    assert File.exists?("test/dest/6/subdir1/subdir3/reg_3.test")
    assert File.exists?("test/dest/6/reg_1.test") 
    assert File.exists?("test/dest/6/reg_2.test") 
    assert File.exists?("test/dest/6/reg_3.test") 
    
    messages = @output.messages.map { |m| m.strip }
    assert_match messages[0],  /(create|exists)\ttest\/dest/
    assert_equal messages[1],  "copy\ttest/dest/file1"
    assert_equal messages[2],  "copy\ttest/dest/file2"
    assert_equal messages[3],  "copy\ttest/dest/file4"
    assert_match messages[4],  /(create|exists)\ttest\/dest\/subdir1/
    assert_equal messages[5],  "copy\ttest/dest/subdir1/file3"
    assert_equal messages[6],  "copy\ttest/dest/subdir1/file5"
    assert_match messages[7],  /(create|exists)\ttest\/dest\/subdir1\/subdir3/
    assert_equal messages[8],  "copy\ttest/dest/subdir1/subdir3/file8"
    assert_equal messages[9],  "copy\ttest/dest/subdir1/subdir3/renamed"
    assert_equal messages[10], "copy\ttest/dest/subdir2"
    assert_equal messages[11], "copy\ttest/dest/renamed"
  end

  should "be able to run in test mode" do
   # We delete the destination if it exists
   FileUtils.rm_r("test/dest/7") if File.exists?("test/dest/7")
    
    # when running in test mode, the files are not copied but the logger displays the results
    run_in_test_mode
    source_directory 'test\src'

    directory 'test\dest\7' do
      copy 'file1'
      copy 'file2'
      copy 'subdir1\file4'
    
      directory 'subdir1' do
        copy 'file3'
        copy 'subdir1\file5'
        
        directory 'subdir3' do
          copy 'file1'
          copy 'file2', :rename => 'file2_renamed'
          copy '*.test'
        end
      end
    
      copy 'subdir2'
      copy 'subdir2', :rename => 'subdir2_renamed'
      copy 'reg_*.test'
    end

    assert !File.exists?("test/dest/7")
    assert !File.exists?("test/dest/7/file1")
    assert !File.exists?("test/dest/7/file2")
    assert !File.exists?("test/dest/7/file4")
    assert !File.exists?("test/dest/7/subdir1")
    assert !File.exists?("test/dest/7/subdir1/file3")
    assert !File.exists?("test/dest/7/subdir1/file5")
    assert !File.exists?("test/dest/7/subdir1/subdir3")
    assert !File.exists?("test/dest/7/subdir1/subdir3/file1")
    assert !File.exists?("test/dest/7/subdir1/subdir3/file2_renamed")
    assert !File.exists?("test/dest/7/subdir2")
    assert !File.exists?("test/dest/7/subdir2_renamed") 
    assert !File.exists?("test/dest/7/subdir1/subdir3/noreg_1.test")
    assert !File.exists?("test/dest/7/subdir1/subdir3/noreg_2.test")
    assert !File.exists?("test/dest/7/subdir1/subdir3/reg_1.test")
    assert !File.exists?("test/dest/7/subdir1/subdir3/reg_2.test")
    assert !File.exists?("test/dest/7/subdir1/subdir3/reg_3.test")
    assert !File.exists?("test/dest/7/reg_1.test") 
    assert !File.exists?("test/dest/7/reg_2.test") 
    assert !File.exists?("test/dest/7/reg_3.test") 
    
    messages = @output.messages.map { |m| m.strip }
    assert_match  /(create|exists)\ttest\/dest\/7/, messages[0]
    assert_equal  "copy\ttest/src/file1\ttest/dest/7/file1", messages[1]
    assert_equal  "copy\ttest/src/file2\ttest/dest/7/file2", messages[2]
    assert_equal  "copy\ttest/src/subdir1/file4\ttest/dest/7/file4", messages[3]
    assert_match  /(create|exists)\ttest\/dest\/7\/subdir1/, messages[4]
    assert_equal  "copy\ttest/src/file3\ttest/dest/7/subdir1/file3", messages[5]
    assert_equal  "copy\ttest/src/subdir1/file5\ttest/dest/7/subdir1/file5", messages[6]
    assert_match  /(create|exists)\ttest\/dest\/7\/subdir1\/subdir3/, messages[7]
    assert_equal  "copy\ttest/src/file1\ttest/dest/7/subdir1/subdir3/file1", messages[8]
    assert_equal  "copy\ttest/src/file2\ttest/dest/7/subdir1/subdir3/file2_renamed", messages[9]
    assert_equal  "copy\ttest/src/noreg_1.test\ttest/dest/7/subdir1/subdir3/noreg_1.test", messages[10]
    assert_equal  "copy\ttest/src/noreg_2.test\ttest/dest/7/subdir1/subdir3/noreg_2.test", messages[11]
    assert_equal  "copy\ttest/src/reg_1.test\ttest/dest/7/subdir1/subdir3/reg_1.test", messages[12]
    assert_equal  "copy\ttest/src/reg_2.test\ttest/dest/7/subdir1/subdir3/reg_2.test", messages[13]
    assert_equal  "copy\ttest/src/reg_3.test\ttest/dest/7/subdir1/subdir3/reg_3.test", messages[14]
    assert_equal  "copy\ttest/src/subdir2\ttest/dest/7/subdir2", messages[15]
    assert_equal  "copy\ttest/src/subdir2\ttest/dest/7/subdir2_renamed", messages[16]
    assert_equal  "copy\ttest/src/reg_1.test\ttest/dest/7/reg_1.test", messages[17]
    assert_equal  "copy\ttest/src/reg_2.test\ttest/dest/7/reg_2.test", messages[18]
    assert_equal  "copy\ttest/src/reg_3.test\ttest/dest/7/reg_3.test", messages[19]
  end

  should "log when it can't find a source file" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/8") if File.exists?("test/dest/8")
   
    source_directory 'test\src'

    directory 'test\dest\8'  do
      copy 'unknown_file'
    end
    
    assert File.exists?("test/dest/8")
    messages = @output.messages.map { |m| m.strip }
    assert_match  /(create|exists)\ttest\/dest\/8/, messages[0]
    assert_equal "not found\ttest/src/unknown_file", messages[1]
  end

  should "detect and replace environment variables" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/9") if File.exists?("test/dest/9")

    # create a new environment variable
    ENV['TESLER_TEST'] = File.dirname(__FILE__)

    directory '%TESLER_TEST%\dest\9'  do
      copy '%TESLER_TEST%\src\file1'
      copy '%TESLER_TEST%\src\*.test'
    end
    
    assert File.exists?("test/dest/9")
    assert File.exists?("test/dest/9/file1")
    assert File.exists?("test/dest/9/noreg_1.test")
    assert File.exists?("test/dest/9/noreg_2.test")
    assert File.exists?("test/dest/9/reg_1.test")
    assert File.exists?("test/dest/9/reg_2.test")
    assert File.exists?("test/dest/9/reg_3.test")
  end

  should "log when it can't find a source file's directory (regular expressions case only)" do
    # We delete the destination if it exists
    FileUtils.rm_r("test/dest/10") if File.exists?("test/dest/10")
   
    source_directory 'unknown\src'

    directory 'test\dest\10'  do
      copy '*.file'
    end
    
    assert File.exists?("test/dest/10")
    messages = @output.messages.map { |m| m.strip }
    assert_match  /(create|exists)\ttest\/dest\/10/, messages[0]
    assert_equal "not found\tunknown/src", messages[1]
  end
end
