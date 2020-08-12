# represents a docker volume hash or string
module DockerCompose
  class Volume
    def initialize(data)
      @data = data
      @data = to_long_form(@data) if @data.is_a?(String)
    end

    def source
      @data[:source]
    end

    def type
      @data[:type]
    end

    # WARN: This is incomplete: it only handles binds
    def to_long_form(data)
      pieces = data.split(":")
      source, target, mode = pieces
      type = "bind" if pieces.length > 1

      result = {
        source: source,
        target: target,
        type: type
      }.with_indifferent_access
      result[:read_only] = true if mode == "ro"
      result
    end

    def bind?
      type == "bind"
    end

    def relative_bind?
      bind? && source.start_with?(".")
    end

    def bind_source_missing?
      # puts "looking for #{source}: #{File.exist?(source)}" if source
      relative_bind? && !File.exist?(source)
    end
  end
end
