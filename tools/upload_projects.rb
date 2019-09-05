require 'io/console'
puts
puts 'Upload local Projects to Heroku application'
puts
puts '1. Staging'
puts '2. Production'
puts
puts '(any other key to quit)'
puts

mode = STDIN.getch.to_i

if [1,2].include? mode
  puts 'WARNING: This will overwrite Projects in the target database!'
  puts 'Are you sure? (y/n)'
  puts
  confirm = STDIN.getch.upcase
  if confirm == 'Y'
    puts 'Fetching database connection string....'
    target_db = `heroku config:get DATABASE_URL -a barrimason#{mode==1 ? '-staging' : ''}`.strip
    puts 'Deleting target....'
    puts `psql #{target_db} -c 'delete from projects'`
    puts 'Uploading local data....'
    puts `psql -d website2019_development -c 'copy (select * from projects) to STDOUT' | psql #{target_db} -c 'copy projects from STDIN'`
    puts 'Updating ID sequence....'
    puts `psql #{target_db} -c "select setval('projects_id_seq', max(id)) from projects"`
    puts 'Done.'
  end
end

