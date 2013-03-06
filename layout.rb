require 'json'
require 'hyrise'


if ARGV.size > 2
  core = ARGV[2].to_i
  port = ARGV[3].to_i
else
  core = 7
  port = 5000
end

op = build_layout_op(ARGV[0], ARGV[1], core)

query(op.to_json, URI("http://192.168.31.39:#{port}/"))
