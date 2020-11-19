require "mapr/version"
require "yaml"

module Mapr
  class Error < StandardError; end

  module_function

  CONSTANT_PREFIX = /\A\+/

  def map(schema, data)
    YAML.load(schema)
      .transform_values do |path|
        dig(data, path)
      end
  end

  def dig(data, path)
    case path
    when CONSTANT_PREFIX
      path.gsub(CONSTANT_PREFIX, "")
    else
      data.dig(*parse_path(path))
    end
  end

  def parse_path(path)
    case path
    when Array
      path
    when String
      path.split("/")
        .map(&method(:transform_path_token))
    when Integer
      [path]
    else
      raise Mapr::Error, "Path has to be a string or integer path was of type: '#{path.class}' (#{path})"
    end
  end

  def transform_path_token(path_token)
    if path_token =~ /\A\d+\Z/
      path_token.to_i
    else
      path_token
    end
  end

end
