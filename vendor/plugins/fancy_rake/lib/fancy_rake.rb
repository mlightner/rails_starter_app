module FancyRake

  class Base
    include Singleton

    def map
      @map ||= {}
    end

    def subtask_dir
      @subtask_dir ||= File.dirname(__FILE__) + '/../subtasks'
    end

    def subtasks
      @subtasks ||= Dir.entries(subtask_dir).grep(/\w\.rb/i).collect { |t| t.to_s.gsub(/\.rb/i, '') }
    end

    def run_subtask_for_prefix(prefix, arg)
      #raise "No valid subtask found for function #{prefix.to_s}" unless subtask = self.map[prefix.to_s]
      return false unless subtask = self.map[prefix.to_s]
      raise "Subtask not found." unless File.exist?("#{subtask_dir}/#{subtask}.rb")
      $arg = arg
      puts "Running #{subtask_dir}/#{subtask}.rb"
      load "#{subtask_dir}/#{subtask}.rb"      
    end
  end

  class <<self
    def method_missing(method, *args, &block)
      FancyRake::Base.instance.send(method.to_sym, *args, &block)
    end
  end

  module TaskHelpers
    def local_run(cmd)
      puts " [localhost] executing: #{cmd}"
      system(cmd)
    end

    def set_subtask_handler(subtask, *prefixes)
      raise "No valid subtask with the name: #{subtask.to_s}" unless FancyRake.subtasks.include?(subtask.to_s)
      prefixes.push(subtask.to_sym).flatten.compact.uniq.collect { |p| p.to_s }.each do |prefix|
        FancyRake.map[prefix] = subtask.to_s
      end
    end
  end
end
