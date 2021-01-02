module Muvi2Generic

  def self.hello
    "Hello"
  end

  def self.short_pathname(filename)
    filename.relative_path_from(Rails.root).to_s
  end
end