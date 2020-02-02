classes = Spree.constants.map(&Spree.method(:const_get)).grep(Class).map{ |c| c if c.respond_to?(:attribute_names) }.compact

classes.each do |model|
  name = model.name.gsub(/Spree\:\:/, '')

  next if name == 'Preferrence'
  next if name == 'RelationType'
  next if name == 'LegacyUser'

  attributes = model.attribute_names.map do |attr|
    next if attr == 'id'
    next if attr.match(/\_id$/)
    next if attr.match(/\_ids$/)
    attr
  end.compact.join(' ')

  system("cd ../api; bundle exec rails g serializer V2::Platform::#{name} #{attributes}")
end
