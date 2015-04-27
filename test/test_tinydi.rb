require 'minitest_helper'

class TestTinyDI < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TinyDI::VERSION
  end

  class InjectIng; end

  class WithStoreMeth
    def store
      :fail
    end
  end

  WithCTorArgs = Struct.new(:store)
  SomeOther = Struct.new(:store)

  class TestSubject
    include TinyDI.expose(
      InjectIng => :injected,
      WithCTorArgs => :ctor
    )
  end

  def test_it_adds_injected_method
    assert TestSubject.new.respond_to?(:injected)
  end

  def test_it_throws_excpetion_if_method_is_defined
    assert_raises TinyDI::MethodExistsError do
      WithStoreMeth.new.extend TinyDI.expose(InjectIng => :store)
    end
  end

  def test_it_exposes_injecting_via_injected_method
    assert_equal InjectIng, TestSubject.new.injected.class
  end

  def test_passess_arguments_to_the_contructor
    assert_equal :foo, TestSubject.new.ctor(:foo).store
  end

  def test_allows_overriding_default_klass_via_extend
    inst = TestSubject.new

    require 'pry'; binding.pry
    inst.injected = SomeOther

    assert_equal SomeOther, inst.injected.new.class
  end
end
