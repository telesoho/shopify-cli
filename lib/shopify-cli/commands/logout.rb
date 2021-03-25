require "shopify_cli"

module ShopifyCli
  module Commands
    class Logout < ShopifyCli::Command
      def call(*)
        ShopifyCli::IdentityAuth.delete_tokens_and_keys
        ShopifyCli::DB.del(:shop) if ShopifyCli::DB.exists?(:shop)
        @ctx.puts(@ctx.message("core.logout.success"))
      end

      def self.help
        ShopifyCli::Context.message("core.logout.help", ShopifyCli::TOOL_NAME)
      end
    end
  end
end
