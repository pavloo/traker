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
      @main = OptionParser.new do |opts|
        opts.banner = 'Usage: traker [options] [subcommand] [options]'
        opts.on('-v', '--version', 'Run verbosely')
        opts.separator ''
        opts.separator SUBTEXT
      end

      @subcommands = {
        SUBCOMMANDS[:list] => OptionParser.new do |opts|
          opts.banner = 'Usage: list [options]'
          opts.on('-a', '--all', 'list all tasks')
        end
      }
    end

    def run(argv)
      options = {}
      @main.order!(argv, into: options)
      if options[:version]
        puts Traker::VERSION
        return
      end

      subcommand = argv.shift
      subcommand_options = {}
      @subcommands[subcommand]&.order!(argv, into: subcommand_options)

      service = Traker::Service.new

      case subcommand
      when SUBCOMMANDS[:list]
        if subcommand_options[:all]
          print service.tasks.join("\n")
        else
          print service.pending_tasks.join("\n")
        end
      end
    end
  end
end
