module Elasticsearch
  module Quering
    # using
    # Elasticsearch::Base.find('kQiD9WcB0q1F0jm0anRr')
    # => {"title"=>"title1", "description"=>"description1"}
    # Elasticsearch::Base.find('invalid_id')
    # => Elasticsearch::Transport::Transport::Errors::NotFound: [404]
    def find(id)
      object = new
      client = object.client
      index = object.index
      type = object.type

      result = client.get index: index, type: type, id: id
      result.dig("_source", "attributes")
    end

    def count
      object = new
      client = object.client

      client.count["count"]
    end

    # using
    # Elasticsearch::Base.match(title: "title1")
    # => {"title"=>"title1", "description"=>"description1"}
    # Elasticsearch::Base.match(title: 'invalid_title')
    # => []

    def match(attributes = nil)
      object = new(attributes)
      object.validate!

      client = object.client
      index = object.index
      type = object.type
      body = { query: { match: attributes } }

      result = client.search index: index, type: type, body: body
      result.dig("hits", "hits").map { |hit| hit["_source"] }
    end
  end
end