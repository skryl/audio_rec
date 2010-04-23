#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'

MP3DIR = "/media/share/flac_albums"
BAD_CHARS = "\"*:<>?\\|"
SYS_CHARS = Array.new(31) {|i| "#{(i+1).chr}"}.join

#Recursively iterates a directory and renames all files to valid Microsoft NTFS
#names
def rec_interate(mp3dirpath)
  mp3dir = Dir.new(mp3dirpath)
  entries = mp3dir.entries.sort
  entries.delete_if {|e| e == "." || e == ".."}

  entries.each_with_index do |entry, i|
    dir_path = mp3dir.path
    entry_path =  "#{dir_path}/#{entry}"
    if File.directory?(entry_path)
      if ((clean_path = discard_bad_chars(entry_path)) != entry_path)
        puts entry_path
        old_path = entry_path
        entry_path = clean_path
        File.rename(old_path, entry_path)
      end
      rec_interate(entry_path)
    elsif entry.include?("mp3") && ((clean_entry = discard_bad_chars(entry)) != entry)
      puts entry
      new_filename = clean_entry
      File.rename(entry_path, "#{dir_path}/#{new_filename}")
    end
  end
end

def discard_bad_chars(str) 
  str.split("").map {|c| if (BAD_CHARS.include?(c) || SYS_CHARS.include?(c)) then "" else c end}.join
end

rec_interate(MP3DIR) 
