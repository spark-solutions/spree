Dir["#{File.dirname(__FILE__)}/containers/**"].each do |f|
  load File.expand_path(f)
end

Dir["#{File.dirname(__FILE__)}/operations/**"].each do |f|
  load File.expand_path(f)
end

Dir["#{File.dirname(__FILE__)}/transactions/**"].each do |f|
  load File.expand_path(f)
end

