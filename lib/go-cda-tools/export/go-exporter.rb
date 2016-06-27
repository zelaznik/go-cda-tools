require 'ffi'
require 'health-data-standards'

module GoCDATools
  module Export
    class GoExporter
      include Singleton
      # extend FFI::Library
        # ffi_lib File.expand_path("../../../ext/libgocda.so", File.dirname(__FILE__))
        # attach_function :generateCat1, [:string, :string], :string
        #
        # def export_with_ffi(obj, mes)
        #   generateCat1(obj, mes)
        # end

    end
  end
end
