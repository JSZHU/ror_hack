module RorHack

  module ActiveRecordBaseSingletonClassHack

    def in_and_ref(table)
      includes(table).references(table.to_s.pluralize)
    end

    [:save, :create, :update].each do |type|
      define_method "assign_on_#{type}" do |column, value, options = {}|
        options = options.with_indifferent_access
        send "before_#{type}" do
          block = lambda do
            tmp_value = if value.is_a? Proc
                          instance_eval(&value)
                        else
                          value
                        end
            send("#{column}=", tmp_value)
          end
          if options.key?(:if)
            if options[:if].is_a? Proc
              block.call if instance_eval(&options[:if])
            else
              block.call if options[:if]
            end
            next
          end
          if options.key?(:unless)
            if options[:unless].is_a? Proc
              block.call unless instance_eval(&options[:unless])
            else
              block.call unless options[:if]
            end
            next
          end
          block.call
        end
      end
    end

    # 序列化属性.
    def serialize_hack(attr_name, class_name = Object, options = {})
      serialize(attr_name, class_name)

      if class_name == Array && options.with_indifferent_access['delete_blank_string']
        before_save do
          new_array = send(attr_name)
          new_array.delete_if do |item|
            item.is_a?(String) && item.blank?
          end
          send(attr_name.to_s + '=', new_array)
        end
      end
    end

    def ming(str, _options = {})
      human_attribute_name(str, options = {})
    end
  end

  module ActiveRecordBaseHack

    # 返回某个枚举字段的英文对应的locales名称。
    def method_missing(method, *args, &block)
      method_name = method.to_s
      naked_name  = method_name.remove('_chinese_desc')
      if method_name.end_with?('_chinese_desc') && respond_to?(naked_name)
        return self.class.ming("#{ naked_name }.#{ self.send naked_name }")
      end
      super
    end
  end

end

class ActiveRecord::Base
  extend RorHack::ActiveRecordBaseSingletonClassHack
  include RorHack::ActiveRecordBaseHack
end
