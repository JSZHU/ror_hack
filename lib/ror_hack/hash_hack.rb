module RorHack
  module HashHack
    def add_placeholder(key_array, value = nil)
      keys = self.keys.map(&:to_sym)
      key_array.each do |key|
        next if key.to_sym.in? keys # hash本身已经有这个键，则跳过复制。
        if value
          self[key] = value.deep_dup
        else
          self[key] = default(nil)
        end
      end
      self
    end

    # 两个hash的顺序也相等？
    def sort_eql?(hash)
      return false unless hash.is_a? Hash
      to_a == hash.to_a
    end

    # 默认不做排序,用hash本身的顺序.
    def get_last_value(&block)
      keys = self.keys
      keys = keys.sort(&block) if block
      self[keys.last]
    end

    def delete_recursively(array)
      self.except!(*array)
      each do |_k, v|
        if v.is_a? Hash
          v.delete_recursively(array)
        end
      end
      self
    end
  end
end

class Hash
  include RorHack::HashHack
end

class HashWithIndifferentAccess
  include RorHack::HashHack
end