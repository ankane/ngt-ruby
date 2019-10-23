require "mkmf"

abort "Missing stdc++" unless have_library("stdc++")

$CXXFLAGS << " -std=c++11 -fPIC"

vendor_path = File.expand_path("../../vendor/NGT/lib/NGT", __dir__)

# comment out cmake directives
defines = "#{vendor_path}/defines.h"
contents = File.read("#{defines}.in")
File.write(defines, contents.gsub("#cmake", "// #cmake"))

create_makefile("ngt", vendor_path)
