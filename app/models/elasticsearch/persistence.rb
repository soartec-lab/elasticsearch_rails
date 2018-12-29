module Elasticsearch
  module Persistence
    # using
    # Elasticsearch::Base.create!(title: 'title1', description: 'description1')
    # => true
    #
    # Elasticsearch::Base.create!(title: 'title1')
    # => true
    #
    # Elasticsearch::Base.create!(invalid_title: 'title1')
    # => ArgumentError: invalid_title is invalid argment!
    def create!(attributes = nil)
      object = new(attributes)
      object.validate!

      client = object.client
      index = object.index
      type = object.type

      result = client.create index: index, type: type, body: attributes
      result["result"] == "created" ? true : raise
    end
  end
end