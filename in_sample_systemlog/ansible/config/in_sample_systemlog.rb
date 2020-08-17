#
# sample_systemlog
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#


require 'fluent/plugin/input'
require 'fluent/config/error'

module Fluent::Plugin
  class SampleSystemLog < Input
    Fluent::Plugin.register_input('sample_systemlog', self)

    helpers :thread

    BIN_NUM = 10

    config_param :size, :integer, default: 1
    config_param :rate, :integer, default: 1
    config_param :sample, default: [{"message" => "system log sample"}] do |val|
      begin
      rescue JSON::ParserError => ex
        raise Fluent::ConfigError, "#{ex.class}: #{ex.message}"
      end

      sample = parsed.is_a?(Array) ? parsed : [parsed]
      sample.each_with_index do |e, i|
        raise Fluent::ConfigError, "#{i}th element of sample system log, #{e}, is not a hash" unless e.is_a?(Hash)
      end
      sample
    end

    def configure(conf)
      super
      @sample_index = 0
    end

    def multi_workers_ready?
      true
    end

    def start
      super

      thread_create(:sample_systemlog_input, &method(:run))
    end

    def run
      batch_num = (@rate / BIN_NUM).to_i
      residual_num = (@rate % BIN_NUM)
      while thread_current_running?
        current_time = Time.now.to_i
        BIN_NUM.times do
          break unless (thread_current_running? && Time.now.to_i <= current_time)
          wait(0.1) { emit_systemlog(batch_num) }
        end
        emit_systemlog(residual_num) if thread_current_running?
        while thread_current_running? && Time.now.to_i <= current_time
          sleep 0.01
        end
      end
    end

    def emit_systemlog(num)
      begin
        if @size > 1
          num.times do
            log.error(Array.new(@size) { [generate] })
          end
        else
          num.times { log.error(generate) }
        end
      rescue => _
        # Nothing to do.
      end
    end

    def generate
      d = @sample[@sample_index]
      unless d
        @sample_index = 0
        d = @sample[@sample_index]
      end
      @sample_index += 1
      d
    end

    def wait(time)
      start_time = Time.now
      yield
      sleep_time = time - (Time.now - start_time)
      sleep sleep_time if sleep_time > 0
    end
  end
end
