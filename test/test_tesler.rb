require 'helper'

class Output
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end
end

class TestTesler < Test::Unit::TestCase
  def setup
    FileUtils.rm_r("dest") if File.exists?("dest")

    @output = Output.new
    Tesler::Config.output = @output

    directory 'test\dest' do
      copy 'test\src\file1'
      copy 'test\src\file2'
      copy 'test\src\subdir1\file4'
    
      directory 'subdir1' do
        copy 'test\src\file3'
        copy 'test\src\subdir1\file5'
        
        directory 'subdir3' do
          copy 'test\src\file8'
          copy 'test\src\file9', :rename => 'renamed'
        end
      end
    
      copy 'test\src\subdir2'
      copy 'test\src\subdir2', :rename => 'renamed'
    end
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
end
