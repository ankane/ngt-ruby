require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

def download_file(file, sha256)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/ngt-1.13.5/#{file}"
  puts "Downloading #{file}..."
  contents = URI.open(url).read

  computed_sha256 = Digest::SHA256.hexdigest(contents)
  raise "Bad hash: #{computed_sha256}" if computed_sha256 != sha256

  dest = "vendor/#{file}"
  File.binwrite(dest, contents)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libngt.so", "7e842e0fba48192494fce5e70f2e134c50e9a69d1f8a9f55d6ffa65102c009ea")
  end

  task :mac do
    download_file("libngt.dylib", "fcbdf4247bb7f5c1010980feacc8dcbad24edd2eb4e607032154e0b767721a83")
    download_file("libngt.arm64.dylib", "c4c18e6e8b54eb19eb414a63a7f682e8a2440827cd57317ed9ee63e6ff11cd7c")
  end

  task :windows do
    # not available yet
    # download_file("ngt.dll")
  end

  task all: [:linux, :mac, :windows]

  task :platform do
    if Gem.win_platform?
      Rake::Task["vendor:windows"].invoke
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      Rake::Task["vendor:mac"].invoke
    else
      Rake::Task["vendor:linux"].invoke
    end
  end
end
