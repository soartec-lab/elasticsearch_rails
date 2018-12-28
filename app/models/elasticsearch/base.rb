class Elasticsearch::Base
  attr_reader :client, :index, :type

  def initialize
    config = Rails.application.config.elasticsearch
    connection_url = "#{config["host"]}:#{config["port"]}"
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

  def self.create(attributes = nil)
    object = new
    client = object.client
    index = object.index
    type = name.tableize

    client.index index: index, type: type, body: attributes
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

