require 'trollop'

module SimpleDeploy
  module CLI

    class Destroy
      include Shared

      def destroy
        @opts = Trollop::options do
          version SimpleDeploy::VERSION
          banner <<-EOS

Destroy a stack.

simple_deploy destroy -n STACK_NAME -e ENVIRONMENT

EOS
          opt :help, "Display Help"
          opt :environment, "Set the target environment", :type => :string
          opt :log_level, "Log level:  debug, info, warn, error", :type    => :string,
                                                                  :default => 'info'
          opt :name, "Stack name(s) of stack to deploy", :type => :string
          opt :read_from_env, "Read credentials and region from environment variables"
        end

        valid_options? :provided => @opts,
                       :required => [:environment, :name, :read_from_env]

        config_arg = @opts[:read_from_env] ? :read_from_env : @opts[:environment]
        SimpleDeploy.create_config config_arg
        SimpleDeploy.logger @opts[:log_level]
        stack = Stack.new :name        => @opts[:name],
                          :environment => @opts[:environment]

        exit 1 unless stack.destroy
      end

      def command_summary
        'Destroy a stack'
      end

    end

  end
end
