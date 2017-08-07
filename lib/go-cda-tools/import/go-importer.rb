require 'ffi'
require 'health-data-standards'
require 'os'

module GoCDATools
  module Import
    class GoImporter
      include Singleton
      extend FFI::Library
      	if OS.linux?
          ffi_lib File.expand_path("../../../ext/libgocda-linux.so", File.dirname(__FILE__))
        end
      	if OS.mac?
      	  ffi_lib File.expand_path("../../../ext/libgocda-mac.so", File.dirname(__FILE__))
      	end
        attach_function :import_cat1, [:string], :string

        def parse_with_ffi(file)
          data = file.kind_of?(String) ? file : file.to_xml
          patient_json_string = import_cat1(data)
          if patient_json_string.start_with?("Import Failed")
            raise patient_json_string
          end
          patient = Record.new(JSON.parse(patient_json_string))
          HealthDataStandards::Import::Cat1::PatientImporter.instance.normalize_references(patient)
          patient.dedup_record!
          patient
        end

    end
  end
end
