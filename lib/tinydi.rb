require 'tinydi/version'

module TinyDI
  class InvalidMappingError < StandardError; end

  # Set mapping used for injecting methods and classes
  def self.inject(mapping = {})
    @mapping = validate_mapping(mapping)
    self
  end

  def self.included(base)
    # Copy the ivar value and scrub it
    mapping = @mapping.dup
    remove_instance_variable(:@mapping)

    # each instance of the class will have this ivar
    registry_name = '@__exposeed_klass_registry'

    base.instance_eval do
      # For each class <-> name mapping define
      # - method for building instance of a class
      # - method for overriding class bound to a method name
      #
      # So for this mapping Foo => :foo we will define following methods:
      # - foo(*args) which calls Foo.new(*args)
      # - foo=(klass) which overrides Foo
      mapping.each do |klass, name|
        define_method name do |*args|
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

  private

  def self.validate_mapping(mapping)
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

    mapping
  end
end
