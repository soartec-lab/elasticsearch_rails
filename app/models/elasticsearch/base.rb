class Elasticsearch::Base
  extend Elasticsearch::Scheme
  extend Elasticsearch::Quering
  extend Elasticsearch::Persistence
  include Elasticsearch::Validates

  attr_reader :attributes, :client, :index

  def initialize(attributes = nil)
    @attributes = attributes

    @configrations = Elasticsearch::Configurations.new
    @client = Elasticsearch::Client.new url: @configrations.connection_url
  end
end

