require "mapr/version"
require "yaml"

module Mapr
  class Error < StandardError; end

  module_function

  def map(schema, data)
    YAML.load(schema)
      .transform_values do |path|
        dig(data, path)
      end
  end

  def dig(data, path)
    data.dig(*path.split("/"))
  end

end
