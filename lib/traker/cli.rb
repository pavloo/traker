# frozen_string_literal: true

module Traker
  # Traker's CLI interfase
  class CLI
    SUBTEXT = <<HELP
  Possible commands are:
     list:  lists rake tasks known to Traker (shows list of pending tasks by default)
  See 'traker COMMAND --help' for more information on a specific command.
HELP
    SUBCOMMANDS = {
      list: 'list'
    }.freeze

    def initialize
      @options = {}
      @global = OptionParser.new do |opts|
        opts.banner = 'Usage: traker [options] [subcommand] [options]'
        opts.on('-v', '--version', 'Run verbosely') do |v|
          @options[:version] = v
        end
        opts.separator ''
        opts.separator SUBTEXT
      end

      @subcommand_options = {}
      @subcommands = {
        SUBCOMMANDS[:list] => OptionParser.new do |opts|
          opts.banner = 'Usage: list [options]'
          opts.on('-a', '--all', 'list all tasks') do |v|
            subcommand_options[:all] = v
          end
        end
      }
    end

    def run(argv)
      @global.order!
      if @options[:version]
        puts Traker::VERSION
        exit
      end

      subcommand = argv.shift
      @subcommands[subcommand]&.order!

      service = Traker::Service.new

      case subcommand
      when SUBCOMMANDS[:list]
        if @subcommand_options[:all]
          print service.tasks.join("\n")
        else
          print service.pending_tasks.join("\n")
        end
      end
    end
  end
end
