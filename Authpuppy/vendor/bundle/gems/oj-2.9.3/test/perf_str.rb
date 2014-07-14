#!/usr/bin/env ruby -wW1

$: << '.'
$: << '../lib'
$: << '../ext'

if __FILE__ == $0
  if (i = ARGV.index('-I'))
    x,path = ARGV.slice!(i, 2)
    $: << path
  end
end

require 'optparse'
require 'ox'
require 'oj'
require 'perf'

$indent = 0
$iter = 1000

opts = OptionParser.new

opts.on("-i", "--iterations [Int]", Integer, "iterations")  { |i| $iter = i }
opts.on("-h", "--help", "Show this display")                { puts opts; Process.exit!(0) }
files = opts.parse(ARGV)

$obj = "x" * 50_000

Oj.default_options = { :mode => :strict, :indent => $indent }

puts '-' * 80
puts "Dump Performance"
perf = Perf.new()
perf.add('Oj', 'dump') { Oj.dump($obj) }
perf.add('Ox', 'dump') { Ox.dump($obj, :indent => $indent, :circular => $circular) }
perf.add('Marshal', 'dump') { Marshal.dump($obj) }
perf.run($iter)
