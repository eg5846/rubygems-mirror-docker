#!/usr/bin/env ruby

require "benchmark"
require "find"
require "json"

# Settings
SRCDIR = "/mirror/rubygems.org"
CTOTMPFILE = "#{SRCDIR}/.content.cto"
CTOFILE = "#{SRCDIR}/content.cto"

def log_with_time(description)
  begin
    puts "#{Time.now} Start   '#{description}' ..."
    result = nil
    time = Benchmark.measure { result = yield }
    puts "#{Time.now} Finshed '#{description}', time elapsed: %.4fs" % time.real
    result
  rescue Exception => e
    puts "#{Time.now} FAILED  '#{description}': #{e.message}"
    raise
  end
end

def scandir(path)
  content = Hash.new
  Find.find(path) do |entry|
    if File.file?(entry)
      stat = File.stat(entry)
      relpath = entry[SRCDIR.length..-1]
      content[relpath] = {
        "size" => stat.size,
        "mtime" => stat.mtime.to_i 
      }
    end
  end
  content
end

File.unlink(CTOFILE) if File.exists?(CTOFILE)

content = log_with_time("scanning directory #{SRCDIR}") { scandir(SRCDIR)  }
# Debug
#content.each { |k, v| puts "[#{k}]\t#{v}" }

log_with_time("writing file #{CTOFILE}") do
  File.open(CTOTMPFILE, 'w') { |file| file.write(JSON.pretty_generate(content)) }
  File.rename(CTOTMPFILE, CTOFILE)
end
