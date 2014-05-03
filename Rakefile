# ex: syntax=ruby si ts=4 sw=4 et

require 'rake/clean'
require 'yaml'

outputs = []
outputs << 'modules'

task :default => :build

directory 'modules' do
	sh 'librarian-puppet install --verbose'
end

task :build => outputs

CLEAN.include(outputs)
CLOBBER.include(File.readlines('.gitignore').map(&:chomp))
