module RorHack
  module ModuleHack
    # 创建类对象的实例变量。
    def singleton_attr_accessor(*args)
      singleton_class.class_eval do
        attr_accessor(*args)
      end
    end
  end
end

class Module
  include RorHack::ModuleHack
end