require 'io/console'
puts
puts 'Download Heroku Projects to local application'
puts
puts '1. Staging'
puts '2. Production'
puts
puts '(any other key to quit)'
puts

mode = STDIN.getch.to_i

if [1,2].include? mode
  puts 'WARNING: This will overwrite Projects in the local database!'
  puts 'Are you sure? (y/n)'
  puts
  confirm = STDIN.getch.upcase
  if confirm == 'Y'
    puts 'Deleting local data....'
    puts `psql -d website2019_development -c 'delete from projects'`
    puts 'Fetching database connection string....'
    target_db = `heroku config:get DATABASE_URL -a barrimason#{mode==1 ? '-staging' : ''}`.strip
    puts 'Downloading data....'
    puts `psql #{target_db} -c 'copy (select * from projects) to STDOUT' | psql -d website2019_development -c 'copy projects from STDIN'`
    puts 'Updating ID sequence....'
    puts `psql -d website2019_development -c "select setval('projects_id_seq', max(id)) from projects"`
    puts 'Done.'
  end
end

