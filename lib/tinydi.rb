require 'tinydi/version'

module TinyDI
  class MethodExistsError < StandardError; end
  def self.expose(mapping = {})
    @mapping = mapping
    self
  end

  def self.included(base)
    @mapping.each do |klass, name|
      if base.instance_methods(false).include? name.intern
        fail MethodExistsError,
             "Method: #{name} is already defined on instance of #{base}"
      else
        setter_name = "#{name}="
        klass_cache_var = "@___klass_#{name}"

        base.send :define_method, setter_name do |new_klass|
          instance_variable_set klass_cache_var, new_klass
        end

        base.send :define_method, name do |*args|
          instance_variable_get klass_cache_var || klass.new(*args)
        end

      end
    end
  end
end
