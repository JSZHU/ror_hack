module RorHack
  module KernelHack
    # 将eval中数据绑定移动到前面，样式好看一些。
    def petty_eval(bind, str)
      eval str, bind
    end

    def yml_load_config(name, default_value=false)
      name += '.yml' unless name.end_with?('.yml')
      result = YAML.load(ERB.new(File.read(File.join(Rails.root, '/config', name))).result)
      if result.is_a? Array
        return result
      else
        return OpenStruct.new(result)
      end
    rescue Errno::ENOENT => e
      return default_value if default_value != false
      raise e
    end

  end
end

module Kernel
  include RorHack::KernelHack
end

# Object need refresh included Kernel module or methods cant inherit, maybe this is a ruby bug?
Object.send(:include, Kernel)
