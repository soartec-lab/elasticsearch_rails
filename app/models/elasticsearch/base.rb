class Elasticsearch::Base
  def initialize
    config = Rails.application.config.elasticsearch
    connection_url = "#{config["host"]}:#{config["port"]}"
    @client = Elasticsearch::Client.new url: connection_url
  end
end
