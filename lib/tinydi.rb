require 'tinydi/version'

module TinyDI
  module ClassRegistry
    attr_accessor :__injected_klass_registry
  end

  class MethodExistsError < StandardError; end
  def self.expose(mapping = {})
    @mapping = mapping
    self
  end

  def self.included(base)
    base.extend(ClassRegistry)
    mapping = @mapping

    base.instance_eval do
      base.__injected_klass_registry = {}

      mapping.each do |klass, name|
        # XXX: make thread safe!
        base.__injected_klass_registry[name] = klass

        define_method name do |*args|
          base.__injected_klass_registry.fetch(name).new(*args)
        end

        define_method "#{name}=" do |new_klass|
          base.__injected_klass_registry[name] = new_klass
        end
      end
    end

    @mapping = nil
  end
end
