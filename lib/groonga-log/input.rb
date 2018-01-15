# Copyright (C) 2018  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "zlib"

require "archive/zip"

module GroongaLog
  class Input
    class << self
      def open(path)
        input = new(path)
        if block_given?
          begin
            yield(input)
          ensure
            input.close unless input.closed?
          end
        else
          input
        end
      end
    end

    def initialize(path)
      @path = path
      @path = @path.to_path if @path.respond_to?(:to_path)

      case File.extname(@path).downcase
      when ".gz"
        @raw = Zlib::GzipReader.open(@path)
      when ".zip"
        @raw = Archive::Zip.new(@path, :r)
      else
        @raw = File.new(@path)
      end
    end

    def each_line(&block)
      return to_enum(__method__) unless block_given?

      case @raw
      when Archive::Zip
        @raw.each do |entry|
          next unless entry.file?
          entry.file_data.each_line(&block)
        end
      else
        @raw.each_line(&block)
      end
    end

    def close
      @raw.close
    end

    def closed?
      @raw.closed?
    end
  end
end
