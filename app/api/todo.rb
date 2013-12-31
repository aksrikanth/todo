require 'grape'

module Todo
  class API < ::Grape::API
    format :json
    version 'v1'

    route :any, '*path' do
      error!({error: 'not_found'}, 404)
    end
  end
end
