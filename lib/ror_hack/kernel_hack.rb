module RorHack
  module KernelHack
    # 将eval中数据绑定移动到前面，样式好看一些。
    def petty_eval(bind, str)
      eval str, bind
    end
  end
end

module Kernel
  include RorHack::KernelHack
end