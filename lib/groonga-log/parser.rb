# Copyright (C) 2017 Yasuhiro Horimoto <horimoto@clear-code.com>
# Copyright (C) 2017 Kentaro Hayashi <hayashi@clear-code.com>
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

module GroongaLog
  class Parser
    PATTERN =
      /\A(?<year>\d{4})-(?<month>\d\d)-(?<day>\d\d)
          \ (?<hour>\d\d):(?<minute>\d\d):(?<second>\d\d)\.(?<micro_second>\d+)
          \|(?<log_level>.)
          \|(?<context_id>.+?)
          \|(?<message>.*)/x

    def parse(input)
      return to_enum(:parse, input) unless block_given?

      input.each_line do |line|
        next unless line.valid_encoding?
        m = PATTERN.match(line)

        year = Integer(m['year'])
        month = Integer(m['month'])
        day = Integer(m['day'])
        hour = Integer(m['hour'])
        minute = Integer(m['minute'])
        second = Integer(m['second'])
        micro_second = Integer(m['micro_second'])
        log_level = log_level_to_symbol(m['log_level'])
        context_id = m['context_id']
        message = m['message']
        timestamp = Time.local(year, month, day,
                               hour, minute, second, micro_second)

        record = {
          :timestamp => timestamp,
          :year => year,
          :month => month,
          :day => day,
          :hour => hour,
          :minute => minute,
          :second => second,
          :micro_second => micro_second,
          :log_level => log_level,
          :context_id => context_id,
          :message => message,
        }
        yield record
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
