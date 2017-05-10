require 'ffi'
require 'health-data-standards'

module GoCDATools
  module Export
    class GoExporter
      include Singleton
      extend FFI::Library
        ffi_lib File.expand_path("../../../ext/libgocda-mac.so", File.dirname(__FILE__))
        attach_function :generateCat1, [:string, :int, :int, :string], :string
		attach_function :loadMeasuresAndValueSets, [:string, :string], :void

        def export_with_ffi(patient, start_date, end_date, qrda_version)
          generateCat1(patient, start_date.to_i, end_date.to_i, qrda_version)
        end
        def load_measures_and_value_sets(measures, value_sets)
          loadMeasuresAndValueSets(measures, value_sets)
        end
    end
  end
end
