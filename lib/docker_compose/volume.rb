# represents a docker volume hash or string
module DockerCompose
  class Volume
    attr_reader :source, :type

    def initialize(data)
      data = to_long_form(data) if data.is_a?(String)

      @source = data[:source]
      @type = data[:type]
    end

    def bind_source_missing?
      bind? && !File.exist?(source)
    end

    def bind_source_is_directory?
      bind? && Dir.exist?(source)
    end

    private
    def bind?
      type == "bind"
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
  end
end
