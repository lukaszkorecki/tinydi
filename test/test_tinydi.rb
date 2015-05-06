require 'minitest_helper'

class TestTinyDI < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TinyDI::VERSION
  end

  SimpleBlankClass = Struct.new(:test)
  SimpleReplacement = Struct.new(:test)

  WithCtorArgs = Struct.new(:store)
  ReplacementWithCtorArgs = Struct.new(:store)

  class TestSubject
    include TinyDI.expose(
      SimpleBlankClass => :simple_blank,
      WithCtorArgs => :with_ctor
    )
  end

  def test_it_adds_simple_blank_method
    assert TestSubject.new.respond_to?(:simple_blank)
    assert TestSubject.new.respond_to?(:simple_blank=)
  end

  def test_it_throws_excpetion_if_method_is_defined
    skip
    assert_raises TinyDI::MethodExistsError do
      # wuh"?
    end
  end

  def test_it_exposes_injecting_via_simple_blank_method
    assert_equal SimpleBlankClass, TestSubject.new.simple_blank.class
  end

  def test_passess_arguments_to_the_contructor
    assert_equal :foo, TestSubject.new.with_ctor(:foo).store
  end

  def test_allows_overriding_default_klass_via_extend
    inst = TestSubject.new

    inst.simple_blank = SimpleReplacement

    assert_equal SimpleReplacement, inst.simple_blank.class
  end
end
