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

        attach_function :loadMeasuresAndValueSets, [:string, :string], :void
        attach_function :generateCat1, [:string, :int, :int, :string, :int], :string
        attach_function :generateCat3, [:string, :string, :int, :int, :int, :string], :string

        def load_measures_and_value_sets(measures, value_sets)
          loadMeasuresAndValueSets(measures, value_sets)
        end

        def export_with_ffi(patient, start_date, end_date, qrda_version, cms_compatibility)
          cms_compatible_flag = cms_compatibility ? 1 : 0
          generateCat1(patient, start_date.to_i, end_date.to_i, qrda_version, cms_compatible_flag)
        end

        def export_cat3_with_ffi(measures, measure_results, effective_date, start_date, end_date, qrda_version)
          generateCat3(measures, measure_results, effective_date.to_i, start_date.to_i, end_date.to_i, qrda_version)
        end
    end
  end
end
