#!/usr/bin/env ruby

$shell = ENV["MY_SHELL"]
comp_line = ENV["COMP_LINE"]

def excluded_files(filename)
  excluded_list = {'jc' => 1, 'jc.rb' => 1}
#  p excluded_list.has_key?(filename)
  return ! excluded_list.has_key?(filename)
end

#recrusive call
def push_items_to_map(map, items)
  map[items[0]] = {} if (! map.has_key? items[0]) && items[0]
  push_items_to_map(map[items[0]], items[1..items.size]) if items[1..0]
end

def list_cmd()
  Dir.chdir($shell)
  pwd = Dir.pwd
  cmd_list = []
  Dir.foreach(pwd){|entry|
#     cmd_list.push entry.gsub("-", " ") if File.executable?(entry) && File.file?(entry) && excluded_files(entry)
     cmd_list.push entry if File.executable?(entry) && File.file?(entry) && excluded_files(entry)
  }
  cmd_list.sort!
  cmd_map = {}
  cmd_list.each { |e|
    words = e.split("-")
    push_items_to_map(cmd_map, words)
  }
  return cmd_map
end

# list command from previous list
def list(cmd, cmds)
  words = cmd.split(' ')
  map = cmds
  candidate = map.keys
  words[1..words.size].each { |word| 
    if map[word]
      map = map[word] 
      candidate = map.keys
    else
      #match with precommend
      candidate = []
      map.keys.each { |key|
        candidate.push(key) if word.eql? key[0..word.length-1]
      }
      break
    end
  } if words.size > 1
  return candidate
end

#run direct test
comp_line = "jc" if ! comp_line
cmds = list_cmd
puts list(comp_line, cmds).join("\n")

=begin
# mock test
m = {}
push_items_to_map(m, "a b c d".split(' '))
push_items_to_map(m, "a b d e".split(' '))
p m
=end
