#!/usr/bin/env ruby
# encoding: UTF-8

# Ubuntu does not accept arguments to ruby when called using env. To get warnings to show up the -w options is
# required. That can be set in the RUBYOPT environment variable.
# export RUBYOPT=-w

$VERBOSE = true

$: << File.join(File.dirname(__FILE__), "../lib")
$: << File.join(File.dirname(__FILE__), "../ext")

require 'test/unit'
require 'date'
require 'bigdecimal'
require 'oj'

$ruby = RUBY_DESCRIPTION.split(' ')[0]
$ruby = 'ree' if 'ruby' == $ruby && RUBY_DESCRIPTION.include?('Ruby Enterprise Edition')

class Jam
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def eql?(o)
    self.class == o.class && @x == o.x && @y == o.y
  end
  alias == eql?

end# Jam

class Jeez < Jam
  def initialize(x, y)
    super
  end

  def to_json()
    %{{"json_class":"#{self.class}","x":#{@x},"y":#{@y}}}
  end

  def self.json_create(h)
    self.new(h['x'], h['y'])
  end
end# Jeez

class Orange < Jam
  def initialize(x, y)
    super
  end

  def as_json()
    { :json_class => self.class,
      :x => @x,
      :y => @y }
  end

  def self.json_create(h)
    self.new(h['x'], h['y'])
  end
end

class Range
  def to_hash()
    { 'begin' => self.begin, 'end' => self.end, 'exclude_end' => self.exclude_end? }
  end
end # Range

class FileJuice < ::Test::Unit::TestCase

  def test_nil
    dump_and_load(nil, false)
  end

  def test_true
    dump_and_load(true, false)
  end

  def test_false
    dump_and_load(false, false)
  end

  def test_fixnum
    dump_and_load(0, false)
    dump_and_load(12345, false)
    dump_and_load(-54321, false)
    dump_and_load(1, false)
  end

  def test_float
    dump_and_load(0.0, false)
    dump_and_load(12345.6789, false)
    dump_and_load(70.35, false)
    dump_and_load(-54321.012, false)
    dump_and_load(2.48e16, false)
    dump_and_load(2.48e100 * 1.0e10, false)
    dump_and_load(-2.48e100 * 1.0e10, false)
    dump_and_load(1/0.0, false)
  end
  
  def test_string
    dump_and_load('', false)
    dump_and_load('abc', false)
    dump_and_load("abc\ndef", false)
    dump_and_load("a\u0041", false)
    assert_equal("a\u0000a", dump_and_load("a\u0000a", false))
  end

  def test_string_object
    dump_and_load('abc', false)
    dump_and_load(':abc', false)
  end

  def test_array
    dump_and_load([], false)
    dump_and_load([true, false], false)
    dump_and_load(['a', 1, nil], false)
    dump_and_load([[nil]], false)
    dump_and_load([[nil], 58], false)
  end

  # Symbol
  def test_symbol_object
    Oj.default_options = { :mode => :object }
    #dump_and_load(''.to_sym, false)
    dump_and_load(:abc, false)
    dump_and_load(':xyz'.to_sym, false)
  end

  # Time
  def test_time_object
    t = Time.now()
    Oj.default_options = { :mode => :object }
    dump_and_load(t, false)
  end
  def test_time_object_early
    t = Time.xmlschema("1954-01-05T00:00:00.123456")
    Oj.default_options = { :mode => :object }
    dump_and_load(t, false)
  end

  # Hash
  def test_hash
    Oj.default_options = { :mode => :strict }
    dump_and_load({}, false)
    dump_and_load({ 'true' => true, 'false' => false}, false)
    dump_and_load({ 'true' => true, 'array' => [], 'hash' => { }}, false)
  end

  # Object with to_json()
  def test_json_object_compat
    Oj.default_options = { :mode => :compat, :use_to_json => true }
    obj = Jeez.new(true, 58)
    json = Oj.dump(obj, :indent => 2)
    assert(%{{"json_class":"Jeez","x":true,"y":58}
} == json ||
           %{{"json_class":"Jeez","y":58,"x":true}
} == json)
    dump_and_load(obj, false)
    Oj.default_options = { :mode => :compat, :use_to_json => false }
  end

  def test_as_json_object_compat_hash
    Oj.default_options = { :mode => :compat }
    obj = Orange.new(true, 58)
    json = Oj.dump(obj, :indent => 2)
    assert(!json.nil?)
    dump_and_load(obj, false)
  end

  # Range
  def test_range_object
    unless RUBY_VERSION.start_with?('1.8')
      Oj.default_options = { :mode => :object }
      json = Oj.dump(1..7, :mode => :object, :indent => 0)
      if 'rubinius' == $ruby
        assert(%{{"^O":"Range","begin":1,"end":7,"exclude_end?":false}} == json)
      elsif 'jruby' == $ruby
        assert(%{{"^O":"Range","begin":1,"end":7,"exclude_end?":false}} == json)
      else
        assert_equal(%{{"^u":["Range",1,7,false]}}, json)
      end
      dump_and_load(1..7, false)
      dump_and_load(1..1, false)
      dump_and_load(1...7, false)
    end
  end

  # BigNum
  def test_bignum_object
    Oj.default_options = { :mode => :compat }
    dump_and_load(7 ** 55, false)
  end

  # BigDecimal
  def test_bigdecimal_strict
    mode = Oj.default_options[:mode]
    Oj.default_options = {:mode => :strict}
    dump_and_load(BigDecimal.new('3.14159265358979323846'), false)
    Oj.default_options = {:mode => mode}
  end

  def test_bigdecimal_null
    mode = Oj.default_options[:mode]
    Oj.default_options = {:mode => :null}
    dump_and_load(BigDecimal.new('3.14159265358979323846'), false)
    Oj.default_options = {:mode => mode}
  end

  def test_bigdecimal_object
    mode = Oj.default_options[:mode]
    Oj.default_options = {:mode => :object}
    dump_and_load(BigDecimal.new('3.14159265358979323846'), false)
  end

  # Date
  def test_date_object
    Oj.default_options = { :mode => :object }
    dump_and_load(Date.new(2012, 6, 19), false)
  end

  # DateTime
  def test_datetime_object
    Oj.default_options = { :mode => :object }
    dump_and_load(DateTime.new(2012, 6, 19), false)
  end

  def dump_and_load(obj, trace=false)
    filename = 'file_test.json'
    File.open(filename, "w") { |f|
      Oj.to_stream(f, obj, :indent => 2)
    }
    puts "\n*** file: '#{File.read(filename)}'" if trace
    loaded = Oj.load_file(filename)
    assert_equal(obj, loaded)
    loaded
  end

end
