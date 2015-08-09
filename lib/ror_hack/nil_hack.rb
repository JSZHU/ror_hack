module RorHack
  module NilClassHack
    def j2h(_type = nil)
      {}.with_indifferent_access
    end

  end
end

class NilClass
  include RorHack::NilClassHack
end