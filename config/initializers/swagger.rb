def api_doc?
  defined?(GrapeSwaggerRails)
end

return unless api_doc?

options = GrapeSwaggerRails.options

options.app_name           = 'Demo Swagger API'
options.url                = '/api/swagger_doc.json'
options.doc_expansion      = :list
options.hide_url_input     = true
options.hide_api_key_input = true
options.before_action_proc = proc do
  options.app_url = "#{request.scheme.downcase}://#{request.host_with_port}"
end
