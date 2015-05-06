# vi: ft=ruby
require 'benchmark'
require 'benchmark/ips'

require './lib/tinydi'

class Util
  def foo
    :foo
  end
end

class WithDi
  include TinyDI.inject(Util => :util)
end

class PlainOld
  attr_writer :util
  alias_method :util_class=, :util=

  def util
    (@util_class || Util).new
  end
end

Benchmark.ips do |x|
  x.report('tinydi') do
    10_000.times do
      inst = WithDi.new
      inst.util.foo
      inst.util_class = Util
      inst.util.foo
    end
  end

  x.report('class') do
    10_000.times do
      inst = PlainOld.new
      inst.util.foo
      inst.util_class = Util
      inst.util.foo
    end
  end

  x.report('tinydi - no override') do
    10_000.times do
      inst = WithDi.new
      inst.util.foo
    end
  end

  x.report('class - no override') do
    10_000.times do
      inst = PlainOld.new
      inst.util.foo
    end
  end

  x.compare!
end
