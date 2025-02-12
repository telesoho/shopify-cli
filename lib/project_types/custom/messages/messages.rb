# frozen_string_literal: true

module Custom
  module Messages
    MESSAGES = {
      custom: {
        help: <<~HELP,
          Suite of commands for developing CUSTOM apps . See {{command:%1$s app custom <command> --help}} for usage of each command.
            Usage: {{command:%1$s app custom [ %2$s ]}}
        HELP
        forms: {
          create: {
            error: {
              invalid_app_name: "App name cannot contain 'Shopify'",
              invalid_app_type: "Invalid app type %s",
            },
            app_name: "App name",
            callback_url: "Callback URL",
            app_type: {
              select: "What type of app are you building?",
              select_public: "Public: An app built for a wide merchant audience.",
              select_custom: "Custom: An app custom built for a single client.",
              selected: "App type {{green:%s}}",
            },
          },
        },
      },
    }.freeze
  end
end
