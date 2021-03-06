module ActionView #:nodoc:
  class FixtureResolver < PathResolver
    attr_reader :hash

    def initialize(hash = {})
      super()
      @hash = hash
    end

  private

    def query(path, exts, formats)
      query = Regexp.escape(path)
      exts.each do |ext|
        query << '(' << ext.map {|e| e && Regexp.escape(".#{e}") }.join('|') << '|)'
      end

      templates = []
      @hash.select { |k,v| k =~ /^#{query}$/ }.each do |path, source|
        handler, format = extract_handler_and_format(path, formats)
        templates << Template.new(source, path, handler,
          :virtual_path => path, :format => format)
      end

      templates.sort_by {|t| -t.identifier.match(/^#{query}$/).captures.reject(&:blank?).size }
    end

  end
end