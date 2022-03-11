require "semantic/semantic"

module ShopifyCLI
  module Services
    module App
      module Create
        class CustomService < BaseService
          attr_reader :context, :name, :organization_id, :store_domain, :type, :verbose

          def initialize(name:, organization_id:, store_domain:, type:, verbose:, context:)
            @name = name
            @organization_id = organization_id
            @store_domain = store_domain
            @type = type
            @verbose = verbose
            @context = context
            super()
          end

          def call
            form = form_data({
              name: name,
              organization_id: organization_id,
              shop_domain: store_domain,
              type: type,
              verbose: verbose,
            })

            raise ShopifyCLI::AbortSilent if form.nil?

            ShopifyCLI::Project.write(
              context,
              project_type: "custom",
              organization_id: form.organization_id,
            )

            api_client = if ShopifyCLI::Environment.acceptance_test?
              {
                "apiKey" => "public_api_key",
                "apiSecretKeys" => [
                  {
                    "secret" => "api_secret_key",
                  },
                ],
              }
            else
              ShopifyCLI::Tasks::CreateApiClient.call(
                context,
                org_id: form.organization_id,
                title: form.name,
                type: form.type,
              )
            end

            ShopifyCLI::Resources::EnvFile.new(
              api_key: api_client["apiKey"],
              secret: api_client["apiSecretKeys"].first["secret"],
              shop: form.shop_domain,
              scopes: "write_products,write_customers,write_draft_orders",
            ).write(context)

            partners_url = ShopifyCLI::PartnersAPI.partners_url_for(form.organization_id, api_client["id"])

            context.puts(context.message("apps.create.info.created", form.name, partners_url))
            context.puts(context.message("apps.create.info.serve", form.name, ShopifyCLI::TOOL_NAME))
            unless ShopifyCLI::Shopifolk.acting_as_shopify_organization?
              context.puts(context.message("apps.create.info.install", partners_url, form.name))
            end
          end

          private

          def form_data(form_options)
            if ShopifyCLI::Environment.acceptance_test?
              Struct.new(:name, :organization_id, :type, :shop_domain, keyword_init: true).new(
                name: form_options[:name],
                organization_id: form_options[:organization_id] || "123",
                shop_domain: form_options[:shop_domain] || "test.shopify.io",
                type: form_options[:type] || "public",
              )
            else
              Custom::Forms::Create.ask(context, [], form_options)
            end
          end

          def build(name)
          end
        end
      end
    end
  end
end
