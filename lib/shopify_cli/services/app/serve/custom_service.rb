module ShopifyCLI
  module Services
    module App
      module Serve
        class CustomService < BaseService
          attr_accessor :host, :port, :context

          def initialize(host:, port:, context:)
            @host = host
            @port = port
            @context = context
            super()
          end

          def call
            project = ShopifyCLI::Project.current
            url = host || ShopifyCLI::Tunnel.start(context, port: port)
            raise ShopifyCLI::Abort,
              context.message("core.app.serve.error.host_must_be_https") if url.match(/^https/i).nil?
            project.env.update(context, :host, url)
            callback_url = project.config["callback_url"] ? project.config["callback_url"] : "/auth/callback"
            ShopifyCLI::Tasks::UpdateDashboardURLS.call(
              context,
              url: url,
              callback_url: callback_url,
            )

            if project.env.shop
              project_url = "#{project.env.host}/auth?shop=#{project.env.shop}"
              context.puts("\n" + context.message("core.app.serve.open_info", project_url) + "\n")
            end

            # CLI::UI::Frame.open(context.message("core.app.serve.running_server")) do
            #   env = project.env.to_h
            #   env["PORT"] = port.to_s
            #   context.system("npm run dev", env: env)
            # end
          end
        end
      end
    end
  end
end
