module RorHack
  class LookupStack
    def initialize(bindings = [])
      @bindings = bindings
    end

    def method_missing(m, *args)

      # 在绑定的列表中迭代，一旦可以执行这个变量或方法的，返回执行的结果。
      @bindings.each do |bind|

        # 假设为方法
        begin
          method = eval("method(%s)" % m.inspect, bind)
        rescue NameError
        else
          return method.call(*args)
        end

        # 假设为变量
        begin
          value = eval(m.to_s, bind)
          return value
        rescue NameError
        end
      end
      raise NoMethodError
    end

    def push_binding(bind)
      @bindings.push bind
    end

    def push_instance(obj)
      @bindings.push obj.instance_eval { binding }
    end

    def run_proc(p, *args)
      instance_exec(*args, &p)
    end
  end

  module ProcHack
    def call_with_binding(bind, *args)
      LookupStack.new(Array(bind)).run_proc(self, *args)
    end
  end

end

class Proc
  include RorHack::ProcHack
end