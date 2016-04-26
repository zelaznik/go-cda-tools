require 'ffi'
require 'health-data-standards'

module GoCDATools
  module Export
    class GoExporter
      include Singleton
      extend FFI::Library
        ffi_lib File.expand_path("../../../ext/libgocda.so", File.dirname(__FILE__))
        attach_function :generateCat1, [:string, :string, :string, :int64,:int64], :string

        def export_with_ffi(obj, mes,valuesets,startDate,endDate)
          generateCat1(obj, mes,valuesets,startDate,endDate)
        end

    end
  end
end
