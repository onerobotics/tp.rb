require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

task default: ["lib/tp/parser.rb", :test]

file "lib/tp/parser.rb" => ["generators/parser.y"] do |t|
  sh "racc -l -t -v -o lib/tp/parser.rb generators/parser.y"
end
