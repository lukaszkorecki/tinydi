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

    base.instance_eval do
      # For each class <-> name mapping define
      # - method for building instance of a class
      # - method for overriding class bound to a method name
      #
      # So for this mapping Foo => :foo we will define following methods:
      # - foo(*args) which calls Foo.new(*args)
      # - foo=(klass) which overrides Foo
      mapping.each do |klass, name|
        sanitized_klass = klass.to_s.gsub(/\W/, '_')

        cache_name = "@__exposed_klass_cache_#{sanitized_klass}_#{name}"

        base.class_eval(<<-EOF, __FILE__, __LINE__ + 1
        def #{name}(*args)
          (#{cache_name} || #{klass}).new(*args)
        end

        def #{name}_class=(new_class)
          #{cache_name} = new_class
        end
        EOF
        )
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
