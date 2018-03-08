# Copyright (C) 2017  Yasuhiro Horimoto <horimoto@clear-code.com>
# Copyright (C) 2017  Kentaro Hayashi <hayashi@clear-code.com>
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

require "groonga-log/entry"
require "groonga-log/input"

module GroongaLog
  class Parser
    PATTERN =
      /\A(?<year>\d{4})-(?<month>\d\d)-(?<day>\d\d)
          \ (?<hour>\d\d):(?<minute>\d\d):(?<second>\d\d)\.(?<micro_second>\d+)
          \|(?<log_level>.)
          \|(?:(?<pid>\d+):)?
          \ (?<message>[^\r\n]*)/x
    PATH_TIMESTAMP_PATTERN = /(\d{4})-(\d{2})-(\d{2})-
                              (\d{2})-(\d{2})-(\d{2})-(\d{6})
                              (?:\.(?:gz|zip))?\z/xi

    class << self
      def target_line?(line)
        if line.respond_to?(:valid_encoding?)
          return false unless line.valid_encoding?
        end

        return false unless PATTERN.match(line)

        true
      end

      def sort_paths(paths)
        paths.sort_by do |path|
          match_data = PATH_TIMESTAMP_PATTERN.match(File.basename(path))
          if match_data
            values = match_data.to_a[1..-1].collect(&:to_i)
            Time.local(*values)
          else
            Time.now
          end
        end
      end
    end

    attr_reader :current_path
    def initialize
      @current_path = nil
    end

    def parse(input)
      return to_enum(:parse, input) unless block_given?

      input.each_line do |line|
        if line.respond_to?(:valid_encoding?)
          next unless line.valid_encoding?
        end

        m = PATTERN.match(line)
        next if m.nil?

        entry = Entry.new

        year = Integer(m["year"], 10)
        month = Integer(m["month"], 10)
        day = Integer(m["day"], 10)
        hour = Integer(m["hour"], 10)
        minute = Integer(m["minute"], 10)
        second = Integer(m["second"], 10)
        micro_second = Integer(m["micro_second"], 10)
        entry.timestamp = Time.local(year, month, day,
                                     hour, minute, second, micro_second)
        entry.log_level = log_level_to_symbol(m["log_level"])
        entry.pid = Integer(m["pid"], 10) if m["pid"]
        entry.message = m["message"]
        yield entry
      end
    end

    def parse_paths(paths, &block)
      return to_enum(__method__, paths) unless block_given?

      target_paths = self.class.sort_paths(paths)
      target_paths.each do |path|
        Input.open(path) do |log|
          @current_path = path
          begin
            parse(log, &block)
          ensure
            @current_path = nil
          end
        end
      end
    end

    private
    def log_level_to_symbol(level_text)
      case level_text
      when "E"
        :emergency
      when "A"
        :alert
      when "C"
        :critical
      when "e"
        :error
      when "w"
        :warning
      when "n"
        :notice
      when "i"
        :information
      when "d"
        :debug
      when "-"
        :dump
      end
    end
  end
end
