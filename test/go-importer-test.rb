require 'minitest_helper'

class GoImporterTest < Minitest::Test
  def test_import
    patient = GoCDATools::Import::GoImporter.instance.parse_with_ffi('test/fixtures/qrda/cat1_good.xml')

    #demographics
    assert_equal patient.first, "Norman"
    assert_equal patient.last, "Flores"
    assert_equal patient.birthdate, 599646600
    assert_equal patient.gender, "M"
    assert_equal patient.race["code"], "1002-5"
    assert_equal patient.race["code_system"], "CDC Race and Ethnicity"
    assert_equal patient.ethnicity["code"], "2186-5"
    assert_equal patient.ethnicity["code_system"], "CDC Race and Ethnicity"

    #encounters
    assert_equal patient.encounters.length, 6
    encounter = patient.encounters[0]
    assert_equal encounter.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal encounter.cda_identifier['extension'], "50d3a288da5fe6e14000016c"
    assert encounter.codes['CPT'].include?("99201")
    assert_equal encounter.start_time, 1288612800
    assert_equal encounter.end_time, 1288616400

    encounter_order = patient.encounters[3]
    assert_equal encounter_order.cda_identifier['root'], "50f84c1b7042f9877500025e"
    assert encounter_order.codes['CPT'].include?("90815")
    assert encounter_order.codes['SNOMED-CT'].include?("76168009")
    assert encounter_order.codes['ICD-9-CM'].include?("94.49")
    assert encounter_order.codes['ICD-10-PCS'].include?("GZHZZZZ")
    assert_equal encounter_order.start_time, 1135608034
    assert_equal encounter_order.end_time, 1135608034

    #diagnoses
    assert_equal patient.conditions.length, 8

    firstDiagnosis = patient.conditions[0]
    assert_equal firstDiagnosis.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal firstDiagnosis.cda_identifier['extension'], "54c1142869702d2cd2520100"
    assert firstDiagnosis.codes['SNOMED-CT'].include?("195080001")
    assert_equal firstDiagnosis.description, "Diagnosis, Active: Atrial Fibrillation/Flutter"
    assert_equal firstDiagnosis.start_time, 1332775800
    assert_equal firstDiagnosis.end_time, nil

    secondDiagnosis = patient.conditions[1]
    assert_equal secondDiagnosis.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal secondDiagnosis.cda_identifier['extension'], "54c1142969702d2cd2cd0200"
    assert secondDiagnosis.codes['SNOMED-CT'].include?("237244005")
    assert_equal secondDiagnosis.description, "Diagnosis, Active: Pregnancy Dx"
    assert_equal secondDiagnosis.start_time, 1362150000
    assert_equal secondDiagnosis.end_time, 1382284800

    thirdDiagnosis = patient.conditions[2]
    assert_equal thirdDiagnosis.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal thirdDiagnosis.cda_identifier['extension'], "54c1142869702d2cd2760100"
    assert thirdDiagnosis.codes['SNOMED-CT'].include?("46635009")
    assert_equal thirdDiagnosis.description, "Diagnosis, Active: Diabetes"
    assert_equal thirdDiagnosis.start_time, 1361890800
    assert_equal thirdDiagnosis.end_time, nil

    diagnosisInactive = patient.conditions[3]
    assert_equal diagnosisInactive.cda_identifier['root'], "50f84c1d7042f98775000352"
    assert_equal diagnosisInactive.start_time, 1092658739
    assert_equal diagnosisInactive.end_time, 1092686969
    assert diagnosisInactive.codes["SNOMED-CT"].include?("76795007")
    assert diagnosisInactive.codes["ICD-9-CM"].include?("V02.61")
    assert diagnosisInactive.codes["ICD-10-CM"].include?("Z22.51")
    assert diagnosisInactive.status_code["SNOMED-CT"].include?("73425007")

    #lab results
    assert_equal patient.results.length, 3

    firstResult = patient.results[0]
    assert firstResult.codes['LOINC'].include?("11268-0")
    assert_equal firstResult.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal firstResult.cda_identifier['extension'], "50d3a288da5fe6e1400002a9"
    assert_equal firstResult.description, "Laboratory Test, Result: Group A Streptococcus Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1012)"
    assert_equal firstResult.start_time, 674670276
    assert_equal firstResult.oid, "2.16.840.1.113883.3.560.1.12"

    secondResult = patient.results[1]
    assert secondResult.codes['SNOMED-CT'].include?("8879006")
    assert secondResult.codes['CPT'].include?("80069")
    assert_equal secondResult.cda_identifier['root'], "50f84c1d7042f9877500039e"
    assert_equal secondResult.description, "Laboratory Test, Order: Laboratory Tests for Hypertension (Code List: 2.16.840.1.113883.3.600.1482)"
    assert_equal secondResult.start_time, 674670276
    assert_equal secondResult.end_time, 674670276
    assert_equal secondResult.oid, "2.16.840.1.113883.3.560.1.50"

    thirdResult = patient.results[2]
    assert thirdResult.codes['LOINC'].include?("7905-3")
    assert_equal thirdResult.cda_identifier['root'], "50f84c1d7042f98775000353"
    assert_equal thirdResult.description, "Laboratory Test, Performed: HBsAg (Code List: 2.16.840.1.113883.3.67.1.101.1.279)"
    assert_equal thirdResult.interpretation["code"], "N"
    assert_equal thirdResult.interpretation["code_system"], "HITSP C80 Observation Status"
    assert_equal thirdResult.oid, "2.16.840.1.113883.3.560.1.5"
    assert_equal thirdResult.reason["code"], "105480006"
    assert_equal thirdResult.reason["code_system"], "SNOMED-CT"
    assert_equal thirdResult.referenceRange, "M 13-18 g/dl; F 12-16 g/dl"
    assert_equal thirdResult.start_time, 1012327624
    assert_equal thirdResult.end_time, 1012376895
    assert thirdResult.status_code["HL7 ActStatus"].include?("performed")

    #insurance providers
    insuranceProvider = patient.insurance_providers[0]
    assert_equal insuranceProvider.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal insuranceProvider.cda_identifier['extension'], "4"
    assert_equal insuranceProvider.oid, "2.16.840.1.113883.3.560.1.405"
    assert_equal insuranceProvider.start_time, 1111851000
    assert insuranceProvider.codes["SOP"].include?("349")

    #diagnostic study order
    diagStudy = patient.procedures[0]
    assert_equal diagStudy.cda_identifier['root'], "50f84dbb7042f9366f00014c"
    assert diagStudy.codes["LOINC"].include?("69399-4")
    assert_equal diagStudy.description, "Diagnostic Study, Order: VTE Diagnostic Test (Code List: 2.16.840.1.113883.3.117.1.7.1.276)"
    assert_equal diagStudy.start_time, 629709860
    assert_equal diagStudy.end_time, 629709860
    assert_equal diagStudy.oid, "2.16.840.1.113883.3.560.1.40"
    assert diagStudy.status_code["HL7 ActStatus"].include?("ordered")

  end
end
