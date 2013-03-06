require 'json'
require 'hyrise'


query(File.read(ARGV[0]), URI("http://192.168.31.39:5001/"))
