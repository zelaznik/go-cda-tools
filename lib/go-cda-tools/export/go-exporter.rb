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
        # attach_function :GenerateCat1, [:string, :string], :string
        #
        # def export_with_ffi(obj, mes)
        #   GenerateCat1(obj, mes)
        # end
    end
  end
end
