require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

def download_file(file)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/ngt-1.12.2/#{file}"
  puts "Downloading #{file}..."
  dest = "vendor/#{file}"
  File.binwrite(dest, URI.open(url).read)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libngt.so")
  end

  task :mac do
    download_file("libngt.dylib")
    download_file("libngt.arm64.dylib")
  end

  task :windows do
    # not available yet
    # download_file("ngt.dll")
  end

  task all: [:linux, :mac, :windows]
end
