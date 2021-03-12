require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

def download_file(file, sha256)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/ngt-1.12.2/#{file}"
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
    download_file("libngt.so", "37cb5edfff759ef09835eb9e6bb33f7d9651bd9f30496c8da9a3f41e3b610cd6")
  end

  task :mac do
    download_file("libngt.dylib", "cdb736c1faf549d008b54fd816aedbe27201aa8a8e6a788d1b1f2fd2afa99e1f")
    download_file("libngt.arm64.dylib", "70d2ab693bf985a4fc6ffe5fc562470842b12c832713f4a56bf1c850b27a0252")
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
