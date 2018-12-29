class Elasticsearch::Base
  attr_reader :attributes, :client, :index, :type

  def initialize(attributes = nil)
    config = Rails.application.config.elasticsearch
    connection_url = "#{config["host"]}:#{config["port"]}"
    @attributes = attributes
    @index = config["index"]
    @type = self.class.name.tableize
    @client = Elasticsearch::Client.new url: connection_url
  end

  def healthy?
    status = client.cluster.health["status"]
    status == "green"
  end

  def properties
    {
      title: { type: 'text', analyzer: "kuromoji" },
      description: { type: 'text', analyzer: "kuromoji" }
    }
  end

  def validate!
    errors = []

    attributes.keys.each do |attr|
      errors << attr unless properties.keys.include?(attr)
    end
    raise ArgumentError.new("#{errors.join(',')} is invalid argment!") if errors.present?
  end

  # using
  # Elasticsearch::Base.create!(title: 'title1', description: 'description1')
  # => true
  #
  # Elasticsearch::Base.create!(title: 'title1')
  # => true
  #
  # Elasticsearch::Base.create!(invalid_title: 'title1')
  # => ArgumentError: invalid_title is invalid argment!
  def self.create!(attributes = nil)
    object = new(attributes)
    object.validate!

    client = object.client
    index = object.index
    type = object.type

    result = client.create index: index, type: type, body: attributes
    result["result"] == "created" ? true : raise
  end

  # using
  # Elasticsearch::Base.find('kQiD9WcB0q1F0jm0anRr')
  # => {"title"=>"title1", "description"=>"description1"}
  # Elasticsearch::Base.find('invalid_id')
  # => Elasticsearch::Transport::Transport::Errors::NotFound: [404]
  def self.find(id)
    object = new
    client = object.client
    index = object.index
    type = object.type

    result = client.get index: index, type: type, id: id
    result.dig("_source", "attributes")
  end

  def self.count
    object = new
    client = object.client

    client.count["count"]
  end

  # using
  # Elasticsearch::Base.match(title: "title1")
  # => {"title"=>"title1", "description"=>"description1"}
  # Elasticsearch::Base.match(title: 'invalid_title')
  # => []

  def self.match(attributes = nil)
    object = new(attributes)
    object.validate!

    client = object.client
    index = object.index
    type = object.type
    body = { query: { match: attributes } }

    result = client.search index: index, type: type, body: body
    result.dig("hits", "hits").map { |hit| hit["_source"] }
  end

  def self.create_scheme
    object = new
    client = object.client
    index = object.index
    type = object.type

    body = {
      mappings: {
        "#{type}" => {
          properties: object.properties
        }
      }
    }

    client.indices.create index: index, body: body
  end

  def self.delete_scheme
    object = new
    client = object.client
    index = object.index

    client.indices.delete index: [index], ignore: 404
  end
end

