# Represents the stack we wish to build as configued from the stack.yml file
module DockerCompose
  class Stack
    REQUIRED_SERVICES = 'setup'.freeze

    def initialize(stack, using:)
      @architecture = using
      @stack = stack.with_indifferent_access
      @data = { version: architecture.version }.with_indifferent_access
    end

    def write_docker_compose
      prepare

      puts "Writing new docker-compose.yml with #{data[:services].length} services."
      File.open("docker-compose.yml", "w") { |f| f.write data.to_hash.to_yaml }
    end

    private
    attr_reader :architecture, :stack, :data

    def enabled_services
      list = stack[:enabled].map { |name| resolve_group(name) }.flatten
      list.prepend(*REQUIRED_SERVICES)
      list.uniq
    end

    def resolve_group(name)
      if stack[:groups].key?(name)
        stack[:groups][name].map(&method(:resolve_group))
      else
        [name, resolve_dependencies(name)]
      end
    end

    def resolve_dependencies(name)
      service_for(name).dependencies
    end

    def configuration_for(name)
      config = stack[:configure][name] || {}
      config = configuration_for_tooling(config, name) if tooling_name?(name)
      config
    end

    def configuration_for_tooling(config, name)
      directory_exists = File.directory?("../#{name}")

      config = config.clone

      config[:image] = "exercism/#{name}" if tooling_name?(name)
      config[:build] = { :context => "../#{name}", :dockerfile => "Dockerfile"} if directory_exists && config[:build]
      config[:volumes] = ["../#{name}:#{tooling_volume_target(name)}"] if directory_exists
      config
    end

    def tooling_volume_target(name)
      dir = name.gsub(/(.+?)-(test-runner|analyzer|representer)$/, '\2')
      "/opt/#{dir}"
    end

    def prepare
      data["services"] = {}
      enabled_services.map(&method(:add_service))
    end

    def add_service(name)
      service = service_for(name)
      service.override(configuration_for(name))

      data[:services][name] = service.data
    end

    def service_for(name)
      name = "generic-tooling" if tooling_name?(name)
      service = architecture.services[name]
      Service.new(service.name, service.data)
    end

    def tooling_name?(name)
      name.end_with?("test-runner", "analyzer", "representer")
    end
  end
end
