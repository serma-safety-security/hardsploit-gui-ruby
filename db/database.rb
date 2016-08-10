ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.expand_path(File.dirname(__FILE__)) + '/development.sqlite3'
)
