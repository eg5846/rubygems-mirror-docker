#!/usr/bin/env ruby

require 'benchmark'
require 'net/http'
require 'json'
require 'find'

CTOSRV = "xxxxxxxxxxxx.myfritz.net"
CTOPORT = 8080
CTOURL = "/content.cto"
DSTDIR = "/mirror/rubygems.org"
CTOFILE = "#{DSTDIR}/content.cto"

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
      relpath = entry[DSTDIR.length..-1]
      content[relpath] = {
        "size" => stat.size,
        "mtime" => stat.mtime.to_i 
      }
    end
  end
  content
end

def delta_newfiles(remote, local)
  dnewfiles = Hash.new
  remote.each do |k, v|
    if local.has_key?(k)
      dnewfiles[k] = v if (v["size"] != local[k]["size"]) or (v["mtime"] != local[k]["mtime"])
    else
      dnewfiles[k] = v
    end
  end
  dnewfiles
end

def delta_rmfiles(remote, local)
  drmfiles = Hash.new
  local.each do |k, v|
    drmfiles[k] = v unless remote.has_key?(k) 
  end
  drmfiles
end

def prepare_path(absname)
  dirs = absname.split('/')
  path = "" 
  dirs[0..-2].each do |d|
    path += "/#{d}"
    Dir.mkdir(path) unless Dir.exists?(path)
  end
end

def fetch_file(url, mtime)
  Net::HTTP.start(CTOSRV, CTOPORT) do |http|
    resp = http.get(url)
    absname = "#{DSTDIR}/#{url}"
    prepare_path(absname) 
    open(absname, "wb") do |file|
      file.write(resp.body)
    end
    File.utime(File.atime(absname), Time.at(mtime), absname)
  end
end

# Fetch cto file
log_with_time("fetching cto file") do
  Net::HTTP.start(CTOSRV, CTOPORT) do |http|
    resp = http.get(CTOURL)
    open(CTOFILE, "wb") do |file|
      file.write(resp.body)
    end
  end
end

# Parse cto file
remote_content = log_with_time("parsing cto file") do
  File.open(CTOFILE, "r") { |f| JSON.load(f) } 
end
# Debug
#puts "remote_content"
#remote_content.each { |k, v| puts "[#{k}]\t#{v}" }

# Scan dstdir
local_content = log_with_time("scanning dstdir #{DSTDIR}") { scandir(DSTDIR)}
# Debug
#puts "local_content"
#local_content.each { |k, v| puts "[#{k}]\t#{v}" }

# Search for files to fetch and fech
dnewfiles = log_with_time("searching files to fetch") { delta_newfiles(remote_content, local_content) }
filecount = dnewfiles.length
log_with_time("fetching #{filecount} files") do
  counter = filecount
  dnewfiles.each do |k, v|
    log_with_time("fetching #{k} (to-fetch=#{counter}/#{filecount})") { fetch_file(k, v["mtime"]) }
    counter -= 1
  end
end

# Search for files to remove and remove
drmfiles = log_with_time("searching files to remove") { delta_rmfiles(remote_content, local_content) }
filecount = drmfiles.length
log_with_time("removing #{filecount} files from dstdir #{DSTDIR}") do
  counter = filecount
  drmfiles.keys.each do |k|
    rmfile = "#{DSTDIR}#{k}"
    log_with_time("removing #{rmfile} (to-remove=#{counter}/#{filecount})") { File.unlink(rmfile) }
    counter -= 1
  end
end

exit(0)

