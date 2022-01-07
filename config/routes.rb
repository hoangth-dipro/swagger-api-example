Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount GrapeSwaggerRails::Engine => '/api/swagger' if api_doc?

  mount API::Root => '/'
end
