#!/usr/bin/env ruby
# encoding: UTF-8

# Ubuntu does not accept arguments to ruby when called using env. To get warnings to show up the -w options is
# required. That can be set in the RUBYOPT environment variable.
# export RUBYOPT=-w

$VERBOSE = true

$: << File.join(File.dirname(__FILE__), "../lib")
$: << File.join(File.dirname(__FILE__), "../ext")

require 'oj'

module One
  module Two
    module Three
      class Empty

        def initialize()
        end

        def eql?(o)
          self.class == o.class
        end
        alias == eql?

        def to_hash()
          {'json_class' => "#{self.class.name}"}
        end

        def to_json(*a)
          %{{"json_class":"#{self.class.name}"}}
        end

        def self.json_create(h)
          self.new()
        end
      end # Empty
    end # Three
  end # Two
end # One

$obj = {
  'a' => 'Alpha', # string
  'b' => true,    # boolean
  'c' => 12345,   # number
  'd' => [ true, [false, [-123456789, nil], 3.9676, ['Something else.', false], nil]], # mix it up array
  'e' => { 'zero' => nil, 'one' => 1, 'two' => 2, 'three' => [3], 'four' => [0, 1, 2, 3, 4] }, # hash
  'f' => nil,     # nil
  'g' => One::Two::Three::Empty.new(),
  'h' => { 'a' => { 'b' => { 'c' => { 'd' => {'e' => { 'f' => { 'g' => nil }}}}}}}, # deep hash, not that deep
  'i' => [[[[[[[nil]]]]]]]  # deep array, again, not that deep
}

$obj = [$obj]*10000

Oj.default_options = { :indent => 2, :mode => :compat }

$json = Oj.dump($obj, :mode => :compat)

$result = nil
100.times { |i|
  print(".") if (0 == i % 10)
  $result = Oj.compat_load($json)
}


