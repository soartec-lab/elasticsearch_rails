config = YAML.load_file(Rails.root.join('config', 'elasticsearch.yml'))
Rails.application.config.elasticsearch = config[Rails.env]