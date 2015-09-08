module MCollective
  module Facts
    # Command factsource for Puppet Labs Facter
    class Command_facts<Base
      def load_facts_from_source
        begin
          require 'yaml'
          require 'timeout'
        rescue LoadError=> ex
          raise LoadError, "Could not load facts. Missing library: #{ex.message}"
        end

        fact_command = Config.instance.pluginconf.fetch("command", nil) || raise("plugin.command is not defined")
        fact_timeout = Config.instance.pluginconf.fetch("command.timeout", nil).to_i || 10
        Log.debug("Loading facts using #{fact_command} with timeout #{fact_timeout}")

        facts = {}
    
        time = Time.now.to_i 
        begin
          Timeout::timeout(fact_timeout) {
            facts = `"#{fact_command}"`
            raise("#{fact_command} execution failed") if $?.exitstatus != 0
          }
          facts = YAML.load(facts)
        rescue Timeout::Error => ex
          Log.error("Execution for command #{fact_command} takes more than #{fact_timeout} seconds")
        rescue Exception => ex
          Log.error("Could not load facts from fact source: #{ex.message}")
        end
        time = (Time.now.to_i - time)

        Log.info("Loaded #{facts.keys.size} facts using #{fact_command} in #{time} seconds")
        facts
      end
    end
  end
end
