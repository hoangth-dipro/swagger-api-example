# frozen_string_literal: true

module API
  class Root < Grape::API
    prefix         :api
    format         :json
    default_format :json
    formatter      :json, Grape::Formatter::Rabl

    HEADERS = { 'Authorization' => { description: 'Authenticate access token', required: true } }.freeze

    require 'grape_logging'
    unless Rails.env.test?
      logger.formatter = GrapeLogging::Formatters::Default.new
      use GrapeLogging::Middleware::RequestLogger, logger: logger
    end

    helpers do
      def authenticate
        error 'AuthorizationHeaderMissing', 'Authorization Header is not provided.', 401, true, 'error' unless headers['Authorization']
        access_token = find_access_token
        error 'AccessTokenMissing', 'access_token is not provided.', 401, true, 'error' if access_token.blank?
      end

      def find_access_token
        headers['Authorization']
      end
    end

    mount V1

    if api_doc?
      add_swagger_documentation(
        info: {
          title: Rails.application.class.module_parent_name.underscore.dasherize,
        },
      )
    end
  end
end
