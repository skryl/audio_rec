#!/usr/bin/env ruby

require 'rubygems'
require 'id3lib'
require 'fileutils'

MP3DIR = "/media/downloads/mp3"
ALBUMDIR = "/media/downloads/albums"


#Recursively iterates a directory of mp3s and organizes them by their ID3 tags
def rec_interate(mp3dirpath)
  mp3dir = Dir.new(mp3dirpath)
  entries = mp3dir.entries.sort
  entries.delete_if {|e| e == "." || e == ".."}
  
  entries.each_with_index do |entry, i|
    dir_path = mp3dir.path
    entry_path =  "#{dir_path}/#{entry}"

    if File.directory?(entry_path)
      rec_interate(entry_path)
    elsif entry.include?("mp3")
      puts "#{i} - #{entry_path}"

      tag = ID3Lib::Tag.new(entry_path)
      album = ((album = tag.album) ? album.gsub("/", " ").gsub(/[^[:print:]]/,'') : "unknown")
      new_filename = ((title = tag.title) ? title.gsub("/", " ").gsub(/[^[:print:]]/,'') + ".mp3" : entry)

      puts "TITLE: #{title}"
      puts "ALBUM: #{album}"

      File.rename(entry_path, "#{dir_path}/#{new_filename}")
      Dir.mkdir("#{ALBUMDIR}/#{album}") if !File.exists?("#{ALBUMDIR}/#{album}")
      FileUtils.move("#{dir_path}/#{new_filename}", "#{ALBUMDIR}/#{album}")
    end
  end
end

rec_interate(MP3DIR) 
