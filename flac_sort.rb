#!/usr/bin/env ruby

require 'rubygems'
require 'flacinfo'
require 'fileutils'
require 'pp'

MP3DIR = "/media/share/flac"
ALBUMDIR = "/media/share/flac_albums"


#Recursively iterates a directory of FLACs and organizes them by their FLAC tags
def rec_interate(mp3dirpath)
  mp3dir = Dir.new(mp3dirpath)
  entries = mp3dir.entries.sort
  entries.delete_if {|e| e == "." || e == ".."}

  entries.each_with_index do |entry, i|
    dir_path = mp3dir.path
    entry_path =  "#{dir_path}/#{entry}"
    if File.directory?(entry_path)
      rec_interate(entry_path)
    elsif entry.include?("flac")
      puts "#{i} - #{entry_path}"
      tags = FlacInfo.new(entry_path).tags
      album = ((album = (tags["album"] || tags["ALBUM"])) ? album.gsub("/", " ").gsub(/[^[:print:]]/,'') : "unknown")
      new_filename = ((title = (tags["title"] || tags["TITLE"])) ? title.gsub("/", " ").gsub(/[^[:print:]]/,'') + ".flac" : entry)

      puts "TITLE: #{title}"
      puts "ALBUM: #{album}"

      File.rename(entry_path, "#{dir_path}/#{new_filename}")
      Dir.mkdir("#{ALBUMDIR}/#{album}") if !File.exists?("#{ALBUMDIR}/#{album}")
      FileUtils.move("#{dir_path}/#{new_filename}", "#{ALBUMDIR}/#{album}")
    end
  end
end

rec_interate(MP3DIR) 
