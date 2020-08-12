require 'bundler/setup'
require 'yaml'

require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"
require "active_support/core_ext/object/deep_dup"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module DockerCompose
  def self.build_stack
    architecture = Architecture.new("./docker-compose-full.yml")
    stack = Stack.new(YAML.load_file("./stack.yml"), using: architecture)
    stack.write_docker_compose
  end
end
