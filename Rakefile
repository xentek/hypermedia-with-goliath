#!/usr/bin/env rake

require 'redis'

desc "run the specs"
task :spec do
  puts `bundle exec turn -Ispec spec/*_spec.rb`
end
task :default => :spec

desc "seed redis"
task :seeds do
  redis = Redis.new(host: '0.0.0.0',
                    port: 6379,
                    db: 15,
                    thread_safe: true)

  characters = [{id: 1, character: 'Philip J. Fry', actor_id: 1},
                {id: 2, character: 'Turanga Leela', actor_id: 2},
                {id: 3, character: 'Bender Bending Rodriguez', actor_id: 3},
                {id: 4, character: 'Professor Farnsworth', actor_id: 1},
                {id: 5, character: 'Doctor John Zoidberg', actor_id: 1}]

  actors = [{id: 1, actor:'Billy West'}, {id: 2, actor:'Katey Sagal'}, {id: 3, character: 'John DiMaggio'}]

  print "seeding characters"
  characters.each do |c|
    redis.set("character:#{c[:id]}", Marshal.dump(c))
    print "."
  end
  puts "Done!"

  print "seeding actors"
  actors.each do |a|
    redis.set("actor:#{a[:id]}", Marshal.dump(a))
    print "."
  end
  puts "Done!"
end
