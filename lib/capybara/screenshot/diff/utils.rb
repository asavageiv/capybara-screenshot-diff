# frozen_string_literal: true

module Capybara
  module Screenshot
    module Diff
      module Utils
        def self.detect_available_drivers
          result = []
          begin
            result << :vips if defined?(Vips) || require("vips")
          rescue LoadError
            # vips not present
            Object.send(:remove_const, :Vips) if defined?(Vips)
          end
          begin
            result << :chunky_png if defined?(ChunkyPNG) || require("chunky_png")
          rescue LoadError
            # chunky_png not present
            Object.send(:remove_const, :ChunkyPNG) if defined?(ChunkyPNG)
          end
          result
        end

        def self.find_driver_class_for(driver)
          driver = AVAILABLE_DRIVERS.first if driver == :auto

          LOADED_DRIVERS[driver] ||=
            case driver
            when :chunky_png
              require "capybara/screenshot/diff/drivers/chunky_png_driver"
              Drivers::ChunkyPNGDriver
            when :vips
              require "capybara/screenshot/diff/drivers/vips_driver"
              Drivers::VipsDriver
            else
              fail "Wrong adapter #{driver.inspect}. Available adapters: #{AVAILABLE_DRIVERS.inspect}"
            end
        end
      end
    end
  end
end
