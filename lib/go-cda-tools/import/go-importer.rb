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

          # FIXME: This is here because QME has a bug where patients don't calculate accurately if birthdate is exactly 0 (01/01/1970)
          #        The plan is to remove this once Cypress integrates CQL and no longer relies on QME for calculation
          patient.birthdate += 1 if patient.birthdate == 0

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
          # A hash that contains original referenceId ("exported_ref") and mapping to a generated id
          refs = {}
          record.entries.each do |entry|
            entry.references.each do |ref|
              # If an original referenceId has already been mapped to a generated id, don't create a new id
              refs[ref.exported_ref] = BSON::ObjectId.new unless refs.include?(ref.exported_ref)
              # Set the referenceId to the id that has been generated
              ref.referenced_id = refs[ref.exported_ref]
            end
          end
          refs
        end

        def update_entry_references(record, refs)
          record.entries.each do |entry|
              # If an entry is referenced, the id needs to be updated to match the id that was generated for the reference
              if refs.include?(entry.cda_identifier.extension)
                entry._id = refs[entry.cda_identifier.extension]
                # Since the original cda_identifier is no longer relevant, remove
                entry.cda_identifier = nil
              else
                # If an entry is not referenced, use the cda_identifier as the id
                entry._id = entry.cda_identifier._id
              end
          end
        end

    end
  end
end
