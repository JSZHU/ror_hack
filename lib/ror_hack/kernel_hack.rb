module RorHack
  module KernelHack
    # 将eval中数据绑定移动到前面，样式好看一些。
    def petty_eval(bind, str)
      eval str, bind
    end

    def yml_load_config(name, default_value='66dc9e58b19ecc4ec538ea771b71b372')
      name += '.yml' unless name.end_with?('.yml')
      if File.file?(File.join(Rails.root, '/config', name))
        result = YAML.load_file(File.join(Rails.root, '/config', name))
        if result.is_a? Array
          return result
        else
          return OpenStruct.new(result)
        end
      else
        if default_value == '66dc9e58b19ecc4ec538ea771b71b372'
          YAML.load_file(File.join(Rails.root, '/config', name))
        else
          return default_value
        end
      end
    end

  end
end

module Kernel
  include RorHack::KernelHack
end

# Object need refresh included Kernel module or methods cant inherit, maybe this is a ruby bug?
Object.send(:include, Kernel)