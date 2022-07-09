#!/bin/ruby
# rename multiple files
# using EDITOR

# show how to use the script
def usage
  puts "usage: #{__FILE__} [file] [file] ...
ex:\n    #{__FILE__} *\t to select all files from cwd"
end

# check if any files given
ARGV.empty? and (usage;exit 2)

# init the old filename array
files = ARGV
old_fn = []

# create tmp file
tmp_fn = "#{Time.now.nsec}_tmp_rename"
tmp = File.new(tmp_fn, "w+") or (puts "couldn't open file for writing...";exit 9)

# append fn to tmp file and to the array
files.each do |f|
  tmp.puts f
  old_fn << f
end
tmp.close

# exec editor to modify fn
system("$EDITOR #{tmp_fn}")

# load new names
tmp = File.new(tmp_fn, "r") or (puts "couldn't open file for reading...";exit 7)
new_fn = []
tmp.each do |f|
  new_fn << f.chomp
end

# change filename
if old_fn.length != new_fn.length then (puts "not the same amount of files"; tmp.close; File.delete(tmp); exit 6) end  
new_fn.each_index do |i|
  if old_fn[i] != new_fn[i]
    File.rename(old_fn[i], new_fn[i])
  end
end

# cleanup tmp file
tmp.close
File.delete(tmp_fn)
