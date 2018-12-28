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

  def self.create(attributes = nil)
    object = new
    client = object.client
    index = object.index
    type = name.tableize

    client.index index: index, type: type, body: attributes
  end

  def self.scheme_create
    object = new
    client = object.client
    index = object.index
    type = object.type

    body = {
      mappings: {
        "#{type}" => {
          properties: {
            title: {
              type: 'text',
              analyzer: "kuromoji"
            },
            description: {
              type: 'text',
              analyzer: "kuromoji"
            }
          }
        }
      }
    }
    
    client.indices.create index: index, body: body
  end
end

