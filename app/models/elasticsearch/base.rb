class Elasticsearch::Base
  attr_reader :client, :index

  def initialize
    config = Rails.application.config.elasticsearch
    connection_url = "#{config["host"]}:#{config["port"]}"
    @index = config["index"]
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


end