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
    assert_equal patient.encounters.length, 4
    encounter = patient.encounters[0]
    assert_equal encounter.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal encounter.cda_identifier['extension'], "50d3a288da5fe6e14000016c"
    assert encounter.codes['CPT'].include?("99201")
    assert_equal encounter.start_time, 1288569600
    assert_equal encounter.end_time, 1288569600

    encounter_order = patient.encounters[3]
    assert_equal encounter_order.cda_identifier['root'], "50f84c1b7042f9877500025e"
    assert encounter_order.codes['CPT'].include?("90815")
    assert encounter_order.codes['SNOMED-CT'].include?("76168009")
    assert encounter_order.codes['ICD-9-CM'].include?("94.49")
    assert encounter_order.codes['ICD-10-PCS'].include?("GZHZZZZ")
    assert_equal encounter_order.start_time, 1135555200
    assert_equal encounter_order.end_time, 1135555200

    #diagnoses
    assert_equal patient.conditions.length, 4

    firstDiagnosis = patient.conditions[0]
    assert_equal firstDiagnosis.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal firstDiagnosis.cda_identifier['extension'], "54c1142869702d2cd2520100"
    assert firstDiagnosis.codes['SNOMED-CT'].include?("195080001")
    assert_equal firstDiagnosis.description, "Diagnosis, Active: Atrial Fibrillation/Flutter"
    assert_equal firstDiagnosis.start_time, 1332720000
    assert_equal firstDiagnosis.end_time, 0

    secondDiagnosis = patient.conditions[1]
    assert_equal secondDiagnosis.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal secondDiagnosis.cda_identifier['extension'], "54c1142969702d2cd2cd0200"
    assert secondDiagnosis.codes['SNOMED-CT'].include?("237244005")
    assert_equal secondDiagnosis.description, "Diagnosis, Active: Pregnancy Dx"
    assert_equal secondDiagnosis.start_time, 1362096000
    assert_equal secondDiagnosis.end_time, 1382227200

    thirdDiagnosis = patient.conditions[2]
    assert_equal thirdDiagnosis.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal thirdDiagnosis.cda_identifier['extension'], "54c1142869702d2cd2760100"
    assert thirdDiagnosis.codes['SNOMED-CT'].include?("46635009")
    assert_equal thirdDiagnosis.description, "Diagnosis, Active: Diabetes"
    assert_equal thirdDiagnosis.start_time, 1361836800
    assert_equal thirdDiagnosis.end_time, 0

    #lab results
    assert_equal patient.results.length, 2

    firstResult = patient.results[0]
    assert firstResult.codes['LOINC'].include?("11268-0")
    assert_equal firstResult.description, "Laboratory Test, Result: Group A Streptococcus Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1012)"
    assert_equal firstResult.start_time, 674611200

    secondResult = patient.results[1]
    assert secondResult.codes['SNOMED-CT'].include?("8879006")
    assert_equal secondResult.description, "Laboratory Test, Order: Laboratory Tests for Hypertension (Code List: 2.16.840.1.113883.3.600.1482)"
    assert_equal secondResult.start_time, 674611200

  end
end
