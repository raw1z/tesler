class String
  def to_unix
    File.join self.split("\\")
  end
end

