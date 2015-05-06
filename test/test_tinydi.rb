require 'minitest_helper'

class TestTinyDI < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TinyDI::VERSION
  end

  TwitterClient = Struct.new(:test)
  FakeTwitterClient = Struct.new(:test)

  WithCtorArgs = Struct.new(:store)
  ReplacementWithCtorArgs = Struct.new(:store)

  class TestSubject
    include TinyDI[
      TwitterClient => :twitter_client,
      WithCtorArgs => :with_ctor
    ]
  end

  def test_it_adds_twitter_client_method
    assert TestSubject.new.respond_to?(:twitter_client)
    assert TestSubject.new.respond_to?(:twitter_client_class=)
  end

  def test_it_exposes_twitter_client_instance
    assert_instance_of TwitterClient, TestSubject.new.twitter_client
  end

  def test_passess_arguments_to_the_contructor
    assert_equal :foo, TestSubject.new.with_ctor(:foo).store
  end

  def test_allows_overriding_default_klass_via_extend
    inst = TestSubject.new

    inst.twitter_client_class = FakeTwitterClient
    assert_instance_of FakeTwitterClient, inst.twitter_client
  end
end
