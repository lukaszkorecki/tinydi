require 'tinydi/version'

module TinyDI
  module ClassRegistry
    attr_accessor :__injected_klass_registry
  end

  class MethodExistsError < StandardError; end
  class InvalidMappingError < StandardError; end
  def self.inject(mapping = {})
    mapping.each do |klass, name|
      unless klass.is_a?(Class)
        fail InvalidMappingError,
             "Expected class, got: #{klass}: #{klass.class}"
      end

      unless name.is_a?(Symbol)
        fail InvalidMappingError,
             "Excpeted symbol, got #{name}: #{name.class}"
      end
    end

    @mapping = mapping
    self
  end

  def self.included(base)
    mapping = @mapping
    remove_instance_variable(:@mapping)

    base.extend(ClassRegistry)

    registry_name = '@__injected_klass_registry'

    base.instance_eval do
      mapping.each do |klass, name|
        define_method "build_#{name}" do |*args|
          reg = instance_variable_get(registry_name)
          reg = instance_variable_set(registry_name, {}) unless reg.is_a?(Hash)
          reg[name] ||= klass

          instance_variable_get(registry_name).fetch(name).new(*args)
        end

        define_method "#{name}_class=" do |new_klass|
          reg = instance_variable_get(registry_name)
          reg ||= {}
          reg[name] = new_klass

          instance_variable_set(registry_name, reg)
          new_klass
        end
      end
    end
  end
end
