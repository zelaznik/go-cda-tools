require 'ffi'
require 'health-data-standards'
require 'pry'

module GoCDATools
  module Import
    class GoImporter
      include Singleton
      extend FFI::Library
        ffi_lib File.expand_path("../../../ext/libgoimport.so", File.dirname(__FILE__))
        attach_function :read_patient, [:string], :string

        def parse_with_ffi(path)
          patient_json_string = read_patient(path)
          patient = Record.new(JSON.parse(patient_json_string))
          patient
        end

    end
  end
end
