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
    assert_equal patient.conditions.length, 3

    firstDiagnosis = patient.conditions[0]
    assert firstDiagnosis.codes['SNOMED-CT'].include?("195080001")
    assert_equal firstDiagnosis.description, "Diagnosis, Active: Atrial Fibrillation/Flutter"
    assert_equal firstDiagnosis.start_time, 1332720000
    assert_equal firstDiagnosis.end_time, 0

    secondDiagnosis = patient.conditions[1]
    assert secondDiagnosis.codes['SNOMED-CT'].include?("237244005")
    assert_equal secondDiagnosis.description, "Diagnosis, Active: Pregnancy Dx"
    assert_equal secondDiagnosis.start_time, 1362096000
    assert_equal secondDiagnosis.end_time, 1382227200

    thirdDiagnosis = patient.conditions[2]
    assert thirdDiagnosis.codes['SNOMED-CT'].include?("46635009")
    assert_equal thirdDiagnosis.description, "Diagnosis, Active: Diabetes"
    assert_equal thirdDiagnosis.start_time, 1361836800
    assert_equal thirdDiagnosis.end_time, 0
  end
end
