#!/usr/bin/env ruby

require 'rubygems'
require 'id3lib'

MP3DIR = "/media/downloads/albums"
LIST_OUT = "/home/rut216/albumlist"


$dist = {}

#Recursively iterates through a directory of mp3s and outputs a list of all
#albums and the number of entries in each
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
      tag = ID3Lib::Tag.new(entry_path)
      album = ((album = tag.album) ? album.gsub("/", " ").gsub(/[^[:print:]]/,'') : "unknown")
      artist = ((artist = tag.artist) ? artist.gsub("/", " ").gsub(/[^[:print:]]/,'') : "unknown")
      key = "#{artist} - #{album}"
      $dist[key] = (($dist[key] || 0) + 1) 
    end
  end
end

rec_interate(MP3DIR) 

dist_sort = $dist.sort {|a,b| a[1] <=> b[1]}
list = File.open(LIST_OUT, "w")

dist_sort.each do |album, count|
  list << "#{album} - #{count}\n"
end
