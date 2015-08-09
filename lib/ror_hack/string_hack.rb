module RorHack
  module StringHack

    def center_truncate(head= 4, tail= 3)
      head = (head + 3 + tail)
      return self unless self.length > head + tail
      self.truncate(head, omission: "...#{self.last(tail)}")
    end

    def j2h(type = Object::HashWithIndifferentAccess)
      temp = JSON.parse(presence || '{}')
      if type == Object::HashWithIndifferentAccess
        if temp.is_a? Array
          hash = { temp: temp }.with_indifferent_access
          temp = hash[:temp]
        else
          temp = temp.with_indifferent_access
        end
      end
      temp
    end

    def lstyle
      "%#{strip}%"
    end

    def llstyle
      "#{strip}%"
    end

    def rlstyle
      "%#{strip}"
    end

    def zero2nil
      if strip == '0'
        nil
      else
        self
      end
    end
  end

end

class String
  include RorHack::StringHack
end