module RorHack
  # 用于定义可在类继承连上继承的实例变量。区别于了变量，兄弟类之间不会互相影响。
  module ClassLevelInheritableAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def inheritable_attributes(*args)
        @inheritable_attributes ||= [:inheritable_attributes]
        @inheritable_attributes += args
        args.each do |arg|
          class_eval <<-RUBY
          class << self; attr_accessor :#{arg} end
          RUBY
        end
        @inheritable_attributes
      end

      def inherited(subclass)
        super
        (@inheritable_attributes||[]).each do |inheritable_attribute|
          instance_var = "@#{inheritable_attribute}"
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        end
      end
    end
  end

  # 用于指定只存在于本类，而子类都不继承的方法。
  module UndefMethodsFromSons

    def self.included(base)
      base.singleton_class.class_eval do
        attr_accessor :undefined_method_names
      end
      base.undefined_method_names ||= []
      base.extend ClassMethods
    end

    module ClassMethods

      def undef_method_from_sons(*args)
        self.undefined_method_names += args.map(&:to_sym)
      end

      def inherited(subclass)
        super(subclass)
        subclass.singleton_class.class_eval do
          attr_accessor :undefined_method_names
        end
        subclass.undefined_method_names ||= []
        undefined_method_names.each do |method_name|
          # 只会删除继承来的方法。
          subclass.send(:undef_method, method_name)
        end
      end
    end
  end
end
