module RorHack
  module ObjectHack

    def current_namespace(str)
      "#{self.parent_name}::#{str.to_s.camelize}"
    end

    def current_class_namespace(str)
      "#{self.class.parent_name}::#{str.to_s.camelize}"
    end

    def exist_and_eql?(other)
      self && (self == other)
    end

    # 实例变量获取，如果不存在，则设为某个值
    def instance_variable_fetch(name, value = nil)
      instance_variable_get("@#{ name }").tap do |i|
        return i unless i.is?(nil)
      end
      block_given? && my_value = yield
      value && my_value = value
      instance_variable_set("@#{ name }", my_value)
    end

    def is?(other)
      self == other
    end

    def is_not?(other)
      !is?(other)
    end

    # 可能想给has_one传递参数，用此可以设定对象的属性，来获取一些特殊关联。
    def passport_block(object, variable, value)
      new = false
      unless object.instance_variable_defined?("@#{variable}")
        object.instance_variable_set("@#{variable}", nil)
        new = true
      end
      tmp_value = object.instance_variable_get("@#{variable}")
      begin
        object.instance_variable_set("@#{variable}", value)
        yield
      ensure
        object.instance_variable_set("@#{variable}", tmp_value)
        object.remove_instance_variable("@#{variable}") if new
      end
    end

    def is_not_a?(arg)
      !self.is_a?(arg)
    end

    def not_in?(arg)
      !self.in?(arg)
    end

    def p2n
      result = presence
      result = 0 if result.nil?
      result
    end

    def p2s
      result = presence
      result = '' if result.nil?
      result
    end

    def p2h
      result = presence
      result = {} if result.nil?
      result
    end

    def p2a
      result = presence
      result = [] if result.nil?
      result
    end

    def p2ros
      result = presence
      result = OpenStruct.new if result.nil?
    end
  end
end

class Object
  include RorHack::ObjectHack
end