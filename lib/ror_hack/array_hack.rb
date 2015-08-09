module RorHack
  module ArrayHack
    def multi_group_by(*keys)
      group_by_block = lambda do |array, ks|
        key = ks.shift
        return array unless key
        if key.is_a? Proc
          hash = array.group_by(&key)
        else
          hash = array.group_by { |i| i[key] }
        end
        if ks.present?
          hash.keys.each do |k|
            hash[k] = group_by_block.call hash[k], ks.dup
          end
        end
        return hash
      end
      group_by_block.call self, keys
    end

    def include_any?(*args)
      args.any? { |i| i.in? self }
    end

    def include_all?(*args)
      args.all? { |i| i.in? self }
    end

    def all_blank?
      self.all?(&:blank?)
    end

    def any_blank?
      self.any?(&:blank?)
    end

    def all_present?
      self.all?(&:present?)
    end

    def any_present?
      self.any?(&:present?)
    end

    def right_strip_nil
      self.reverse!
      left_strip_nil
      reverse
    end

    # 清空左边为nil的所有元素.
    def left_strip_nil
      while first.nil?
        delete_at(0)
        break if size == 0
      end
      self
    end

    def strip_nil
      left_strip_nil.right_strip_nil
    end

    def right_push(num, ele = nil)
      push(ele) while size < num
      self
    end

    def left_push(num, ele = nil)
      unshift(ele) while size < num
      self
    end
  end
end

class Array
  include RorHack::ArrayHack
end