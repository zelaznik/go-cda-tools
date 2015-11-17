require 'minitest_helper'

class GoImporterTest < Minitest::Test
  def test_import
    patient = GoCDATools::Import::GoImporter.instance.parse_with_ffi('test/fixtures/qrda/cat1_good.xml')

    #demographics
    assert_equal patient.first, "Norman"
    assert_equal patient.last, "Flores"
    assert_equal patient.birthdate, 599616000
    assert_equal patient.gender, "M"
    assert_equal patient.race["code"], "1002-5"
    assert_equal patient.race["code_set"], "CDC Race and Ethnicity"
    assert_equal patient.ethnicity["code"], "2186-5"
    assert_equal patient.ethnicity["code_set"], "CDC Race and Ethnicity"

    #encounters
    assert_equal patient.encounters.length, 3
    encounter = patient.encounters[0]
    assert encounter.codes['CPT'].include?("99201")
    assert_equal encounter.start_time, 1288569600
    assert_equal encounter.end_time, 1288569600

    #diagnoses
    assert_equal patient.conditions.length, 1
    diagnosis = patient.conditions[0]
    assert diagnosis.codes['SNOMED-CT'].include?("282291009")
    assert_equal diagnosis.start_time, 1285891200
    assert_equal diagnosis.end_time, 1285891200
  end
end
