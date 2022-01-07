# frozen_string_literal: true

module API
  class V1 < Grape::API
    version :v1, using: :path

    # Catch validation errors of parameters
    rescue_from Grape::Exceptions::ValidationErrors do |err|
      extend API::Root.helpers

      type = 'ParameterValidationErrors'
      code = 400
      message = err.as_json.map { |e| { e[:params][0] => e[:messages][0] } }[0]

      error!({ meta: { error_type: type, code: code, error_messages: message } }, code)
    end

    rescue_from ActiveRecord::RecordInvalid do |err|
      extend API::Root.helpers

      type    = err.class
      code    = 400
      message = err.record.errors.messages
      message = message.each { |k, v| message[k] = v[0] }

      error!({ meta: { error_type: type, code: code, error_messages: message } }, code)
    end

    rescue_from ActiveRecord::RecordNotFound do |err|
      extend API::Root.helpers

      type    = err.class
      code    = 404
      message = 'not_found'

      error!({ meta: { error_type: type, code: code, error_message: message } }, code)
    end

    rescue_from :all do |err|
      extend API::Root.helpers

      endpoint = env['api.endpoint']

      type  = err.class
      param = endpoint.params.delete_if { |key, _value| key.in?(['password']) }
      data  = {
        error_type:    type,
        error_message: [err.message] + err.backtrace[0..20],
        params:        param,
        request_uri:   env['REQUEST_URI'],
      }

      code    = 500
      message = data[:error_message]

      error!({ meta: { error_type: type, code: code, error_message: message } }, code)
    end

    helpers do
      include ApplicationHelper

      def error(type = 'InternalServerError', message = I18n.t('errors.messages.unknown'), code = 500, logger_flag = true, logger_level = 'fatal') # rubocop:disable Metrics/ParameterLists, Style/OptionalBooleanParameter, Lint/UnusedMethodArgument
        error!({ meta: { error_type: type, code: code, error_messages: Array(message) } }, http_response_code(code))
      end

      def http_response_code(code)
        code == 204 ? 200 : code
      end
    end

    mount API::V1::User
  end
end
