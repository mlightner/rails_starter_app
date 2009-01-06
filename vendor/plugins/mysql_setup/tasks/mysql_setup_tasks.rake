require 'erb'
require 'ruby-debug'

dbinfo = YAML::load(ERB.new(IO.read("#{RAILS_ROOT}/config/database.yml")).result)

class Mysql

  attr_accessor :mysqlstring

  def initialize(string = "mysql -u root mysql")
    @mysqlstring = string
  end

  def do(command)
    command.gsub!(/[\;\s\r\n]+$/, '')
    puts "Executing: #{command}"
    command.gsub!(/\"/, '\"')
    res = `#{mysqlstring} -e "#{command};" 2>&1`
  end

end

$conn = Mysql.new

namespace :mysql_setup do

  task :validate_config => :environment do
    raise "No username" unless dbinfo['development']['username'] =~ /\w/
    raise "No password" unless dbinfo['development']['password'] =~ /\w/
    raise "No database" unless dbinfo['development']['database'] =~ /\w/
  end

  desc "Setup MySQL user for this app"
  task :user => :environment do
    dbs = ActiveRecord::Base.configurations.each_value.collect { |c| c['database'] }
    setup_user_for_databases(ActiveRecord::Base.configurations[RAILS_ENV]['username'],ActiveRecord::Base.configurations[RAILS_ENV]['password'], dbs)
  end

  desc "Setup MySQL databases for this app"
  task :databases => :environment do
    ActiveRecord::Base.configurations.each_value do |config|
      setup_database(config['database'])
    end
  end

  desc "Setup databases and user for this application."
  task :full => [ 'mysql_setup:validate_config', 'mysql_setup:databases', 'mysql_setup:user' ]

  def setup_database(name)
    $conn.do("DROP DATABASE IF EXISTS #{name}")
    $conn.do("CREATE DATABASE #{name}")
  end

  def setup_user_for_databases(username, password, *databases)
    databases.flatten.each do |db|
      $conn.do "DELETE from user WHERE user='#{username}'"
      $conn.do "DELETE from db WHERE user='#{username}'"
      $conn.do "GRANT ALL ON '#{db}'.* TO '#{username}'@'%' IDENTIFIED BY '#{password}'"
    end
    $conn.do "FLUSH PRIVILEGES;"
  end

end
