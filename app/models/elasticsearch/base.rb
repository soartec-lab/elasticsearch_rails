class Elasticsearch::Base
  extend Elasticsearch::Scheme
  extend Elasticsearch::Quering
  extend Elasticsearch::Persistence
  include Elasticsearch::Validates

  attr_reader :attributes, :client, :index, :type

  def initialize(attributes = nil)
    @attributes = attributes
    @type = self.class.name.tableize

    @configrations = Elasticsearch::Configurations.new    
    @index = @configrations.index
    @client = Elasticsearch::Client.new url: @configrations.connection_url
  end
end

