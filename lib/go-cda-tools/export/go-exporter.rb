require 'ffi'
require 'health-data-standards'

module GoCDATools
  module Export
    class GoExporter
      include Singleton
      extend FFI::Library
        ffi_lib File.expand_path("../../../ext/libgocda.so", File.dirname(__FILE__))
        attach_function :generate_cat1, [:string], :string

        def export_with_ffi(obj)
          generate_cat1(obj)
        end

    end
  end
end
