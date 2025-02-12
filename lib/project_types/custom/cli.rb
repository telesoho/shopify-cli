# frozen_string_literal: true
module Custom
  class Project < ShopifyCLI::ProjectType
    require Project.project_filepath("messages/messages")
    register_messages(Custom::Messages::MESSAGES)
  end

  # define/autoload project specific Tasks
  module Tasks
  end

  # define/autoload project specific Forms
  module Forms
    autoload :Create, Project.project_filepath("forms/create")
  end
end
