# Represents the whole architecture of Exercism (every possible service)
# loaded from a single large Docker Compose file
module DockerCompose
  class Architecture
    def initialize(file_path)
      @compose_data = YAML.load_file(file_path).with_indifferent_access
    end

    def services
      @services ||= compose_data[:services].to_h do |name, data|
        [name, Service.new(name, data)]
      end
    end

    def volumes
      compose_data[:volumes]
    end

    def version
      compose_data[:version]
    end

    private
    attr_reader :compose_data
  end
end
