class Evigilo < Sinatra::Base
  configure :development, :test, :production do
    set(:config_directory, "config/initializers")

    set(:username, (ENV['HTTP_USERNAME'] || 'test'))
    set(:password, (ENV['HTTP_PASSWORD'] || 'test'))
  end

  configure :development, :test do
    dbconfig = YAML.load(File.read(File.join(File.dirname(__FILE__), 'config/database.yml')))
    RACK_ENV ||= ENV["RACK_ENV"] || "development"
    ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]
    set :show_exceptions, true
  end

  configure :production do
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
  end
end
