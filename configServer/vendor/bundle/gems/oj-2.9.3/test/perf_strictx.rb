#!/usr/bin/env ruby -wW1
# encoding: UTF-8

$: << '.'
$: << File.join(File.dirname(__FILE__), "../lib")
$: << File.join(File.dirname(__FILE__), "../ext")

require 'stringio'
require 'optparse'
require 'perf'
require 'oj'

$verbose = false
$indent = 0
$iter = 20000
$with_bignum = false
$with_nums = true
$size = 0

opts = OptionParser.new
opts.on("-v", "verbose")                                    { $verbose = true }
opts.on("-c", "--count [Int]", Integer, "iterations")       { |i| $iter = i }
opts.on("-i", "--indent [Int]", Integer, "indentation")     { |i| $indent = i }
opts.on("-s", "--size [Int]", Integer, "size (~Kbytes)")    { |i| $size = i }
opts.on("-b", "with bignum")                                { $with_bignum = true }
opts.on("-n", "without numbers")                            { $with_nums = false }
opts.on("-h", "--help", "Show this display")                { puts opts; Process.exit!(0) }
files = opts.parse(ARGV)

if $with_nums
  $obj = {
    'a' => 'Alpha', # string
    'b' => true,    # boolean
    'c' => 12345,   # number
    'd' => [ true, [false, [-123456789, nil], 3.9676, ['Something else.', false], nil]], # mix it up array
    'e' => { 'zero' => nil, 'one' => 1, 'two' => 2, 'three' => [3], 'four' => [0, 1, 2, 3, 4] }, # hash
    'f' => nil,     # nil
    'h' => { 'a' => { 'b' => { 'c' => { 'd' => {'e' => { 'f' => { 'g' => nil }}}}}}}, # deep hash, not that deep
    'i' => [[[[[[[nil]]]]]]]  # deep array, again, not that deep
  }
  $obj['g'] = 12345678901234567890123456789 if $with_bignum
else
  $obj = {
    'a' => 'Alpha',
    'b' => true,
    'c' => '12345',
    'd' => [ true, [false, ['12345', nil], '3.967', ['something', false], nil]],
    'e' => { 'zero' => '0', 'one' => '1', 'two' => '2' },
    'f' => nil,
    'h' => { 'a' => { 'b' => { 'c' => { 'd' => {'e' => { 'f' => { 'g' => nil }}}}}}}, # deep hash, not that deep
    'i' => [[[[[[[nil]]]]]]]  # deep array, again, not that deep
  }
end

Oj.default_options = { :indent => $indent, :mode => :strict }

if 0 < $size
  o = $obj
  $obj = []
  (4 * $size).times do
    $obj << o
  end
end

$json = Oj.dump($obj)
$obj_json = Oj.dump($obj, :mode => :object)
#puts "*** size: #{$obj_json.size}"
$failed = {} # key is same as String used in tests later

def capture_error(tag, orig, load_key, dump_key, &blk)
  begin
    obj = blk.call(orig)
    raise "#{tag} #{dump_key} and #{load_key} did not return the same object as the original." unless orig == obj
  rescue Exception => e
    $failed[tag] = "#{e.class}: #{e.message}"
  end
end

# Verify that all packages dump and load correctly and return the same Object as the original.
capture_error('Oj:strict-str', $obj, 'load', 'dump') { |o| Oj.strict_load(Oj.dump(o, :mode => :strict)) }
capture_error('Oj:strict', $obj, 'load', 'dump') { |o| Oj.strict_load(StringIO.new(Oj.dump(o, :mode => :strict))) }

puts '-' * 80
puts "Strict Parse Performance"
perf = Perf.new()
perf.add('Oj:strict-str', 'strict_load-str') { Oj.strict_load($json) }
perf.add('Oj:strict-io', 'strict_load') { Oj.strict_load(StringIO.new($json)) }
perf.run($iter)

puts
puts '-' * 80
puts

unless $failed.empty?
  puts "The following packages were not included for the reason listed"
  $failed.each { |tag,msg| puts "***** #{tag}: #{msg}" }
end
