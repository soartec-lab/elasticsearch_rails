module Elasticsearch
  module Scheme
    def create_scheme
      object = new
      client = object.client

      body = {
        mappings: {
          "#{type}" => {
            properties: object.properties
          }
        }
      }

      client.indices.create index: index, body: body
    end

    def delete_scheme
      object = new
      client = object.client

      client.indices.delete index: [index], ignore: 404
    end

    def healthy?
      object = new
      client = object.client

      status = client.cluster.health["status"]
      status == "green"
    end

    def properties
      {
        title: { type: 'text', analyzer: "kuromoji" },
        description: { type: 'text', analyzer: "kuromoji" }
      }
    end

    def index
      Elasticsearch::Configurations.new.index
    end

    def type
      name.tableize
    end
  end
end