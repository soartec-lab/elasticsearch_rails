module Elasticsearch
  module Validates
    def validate!
      errors = []

      attributes.keys.each do |attr|
        errors << attr unless properties.keys.include?(attr)
      end
      raise ArgumentError.new("#{errors.join(',')} is invalid argment!") if errors.present?
    end
  end
end