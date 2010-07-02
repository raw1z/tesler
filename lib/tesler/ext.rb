# define an extension for the Object class
class Object
  # stolen from activesupport.
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

# define an extension for the String class
class String
  # actions :
  # * replace the Windows directory separtor (\) by the unix separator (/)
  # * replace tokens matching the format %TOKEN% by an environment variable
  def tesler
    # replace separators
    s = File.join self.split("\\")

    # environment variables
    env_vars = self.scan(/%([a-zA-Z_]+)%/).map { |array| array.first }
    env_vars.each do |var|
      s.gsub!(Regexp.new("%#{var}%"), ENV[var])
    end

    File.join s.split("\\")
  end

  
end

