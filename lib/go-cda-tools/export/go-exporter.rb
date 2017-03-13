require 'ffi'
require 'health-data-standards'

module GoCDATools
  module Export
    class GoExporter
      include Singleton
      extend FFI::Library
        if OS.linux?
          ffi_lib File.expand_path("../../../ext/libgocda-linux.so", File.dirname(__FILE__))
        end

        if OS.mac?
          ffi_lib File.expand_path("../../../ext/libgocda-mac.so", File.dirname(__FILE__))
        end

        attach_function :generateCat1, [:string, :string, :string, :int, :int, :string], :string

        def export_with_ffi(patient, measures, value_sets, start_date, end_date, qrda_version)
          generateCat1(patient, measures, value_sets, start_date.to_i, end_date.to_i, qrda_version)
        end
    end
  end
end
