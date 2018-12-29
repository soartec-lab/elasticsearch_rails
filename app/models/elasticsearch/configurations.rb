class Elasticsearch::Configurations
  attr_reader :connection_url, :index

  def initialize
    config = Rails.application.config.elasticsearch
    @connection_url = "#{config["host"]}:#{config["port"]}"
    @index = config["index"]
  end
end
