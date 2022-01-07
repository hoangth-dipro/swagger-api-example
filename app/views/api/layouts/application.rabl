# frozen_string_literal: true

node(:meta) do
  if @status_code
    hash = { code: @status_code }
  else
    hash = { code: options[:method] == ['GET'] ? 200 : 201 }
  end
  hash
end

node(:data) { Oj.load(yield) }
