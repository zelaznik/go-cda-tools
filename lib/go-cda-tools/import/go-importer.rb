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
          # When imported from go, conditions that are unresolved need to have a stop_time added
          update_conditions(patient)
          # When imported from go, entry ids need to be updated to reflected references
          update_entry_references(patient, resolve_references(patient))
          patient.dedup_record!
          patient
        end

        def update_conditions(record)
          record.conditions.each do |condition|
            if condition.status_code['HL7 ActStatus'] && condition.status_code['HL7 ActStatus'][0] == ''
              condition.status_code['HL7 ActStatus'][0] = nil
            end
            condition[:end_time] = nil if condition[:end_time].nil?
          end
        end

        def resolve_references(record)
          refs = {}
          record.entries.each do |entry|
            entry.references.each do |ref|
              refs[ref.exported_ref] = BSON::ObjectId.new
              ref.referenced_id = refs[ref.exported_ref].to_s
            end
          end
          refs
        end

        def update_entry_references(record, refs)
          record.entries.each do |entry|
            entry._id = if refs.include?(entry.cda_identifier.extension)
                          refs[entry.cda_identifier.extension]
                        else
                          entry.cda_identifier._id
                        end
          end
        end

    end
  end
end
