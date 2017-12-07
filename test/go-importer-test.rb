require 'minitest_helper'

class GoImporterTest < Minitest::Test
  def test_import

    patient = GoCDATools::Import::GoImporter.instance.parse_with_ffi(File.read('test/fixtures/qrda/cat1_good.xml'))

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
    assert_equal patient.encounters.length, 5
    encounter = patient.encounters[0]
    assert_equal encounter.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal encounter.cda_identifier['extension'], "50d3a288da5fe6e14000016c"
    assert encounter.codes['CPT'].include?("99201")
    assert_equal encounter.start_time, 1288612800
    assert_equal encounter.end_time, 1288616400
    assert_equal encounter.facility.code['code'], "GACH"
    assert_equal encounter.facility.code['code_system_name'], "HL7RoleCode"
    assert_equal encounter.facility.code['code_system_oid'], "2.16.840.1.113883.5.111"
    assert_equal encounter.facility.name, "Good Health Clinic"
    assert_equal encounter.facility.start_time, 1288612800
    assert_equal encounter.facility.end_time, 1288616400
    address = encounter.facility.addresses[0]
    assert_equal address.city, "Blue Bell"
    assert_equal address.country, "US"
    assert_equal address.state, "MA"
    assert_equal address.street, ["17 Daws Rd."]
    assert_equal address.zip, "02368"
    assert_equal address.use, "HP"
    telecom = encounter.facility.telecoms[0]
    assert_equal telecom.value, "tel:(781)555-1212"
    assert_equal telecom.use, "HP"


    encounter_order = patient.encounters[3]
    assert_equal encounter_order.cda_identifier['root'], "50f84c1b7042f9877500025e"
    assert encounter_order.codes['CPT'].include?("90815")
    assert encounter_order.codes['SNOMED-CT'].include?("76168009")
    assert encounter_order.codes['ICD-9-CM'].include?("94.49")
    assert encounter_order.codes['ICD-10-PCS'].include?("GZHZZZZ")
    assert_equal encounter_order.start_time, 1135608034
    assert_equal encounter_order.end_time, 1135608034

    #diagnoses
    assert_equal patient.conditions.length, 10

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
    assert_equal patient.results.length, 4

    #lab result
    labResult = patient.results[0]
    assert labResult.codes['LOINC'].include?("11268-0")
    assert_equal labResult.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert_equal labResult.cda_identifier['extension'], "50d3a288da5fe6e1400002a9"
    assert_equal labResult.description, "Laboratory Test, Result: Group A Streptococcus Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1012)"
    assert_equal labResult.start_time, 674670276
    assert_equal labResult.oid, "2.16.840.1.113883.3.560.1.12"

    #lab test order
    labOrder = patient.results[1]
    assert labOrder.codes['SNOMED-CT'].include?("8879006")
    assert labOrder.codes['CPT'].include?("80069")
    assert_equal labOrder.cda_identifier['root'], "50f84c1d7042f9877500039e"
    assert_equal labOrder.description, "Laboratory Test, Order: Laboratory Tests for Hypertension (Code List: 2.16.840.1.113883.3.600.1482)"
    assert_equal labOrder.start_time, 674670276
    assert_equal labOrder.end_time, 674670276
    assert_equal labOrder.oid, "2.16.840.1.113883.3.560.1.50"

    #lab test performed
    labPerformed = patient.results[2]
    assert labPerformed.codes['LOINC'].include?("7905-3")
    assert_equal labPerformed.cda_identifier['root'], "50f84c1d7042f98775000353"
    assert_equal labPerformed.description, "Laboratory Test, Performed: HBsAg (Code List: 2.16.840.1.113883.3.67.1.101.1.279)"
    assert_equal labPerformed.interpretation["code"], "N"
    assert_equal labPerformed.interpretation["code_system"], "HITSP C80 Observation Status"
    assert_equal labPerformed.oid, "2.16.840.1.113883.3.560.1.5"
    assert_equal labPerformed.reason["code"], "105480006"
    assert_equal labPerformed.reason["code_system"], "SNOMED-CT"
    assert_equal labPerformed.referenceRange, "M 13-18 g/dl; F 12-16 g/dl"
    assert_equal labPerformed.start_time, 1012327624
    assert_equal labPerformed.end_time, 1012376895
    assert labPerformed.status_code["HL7 ActStatus"].include?("performed")

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

    #transfer from
    transferFrom = patient.encounters[4]
    assert_equal transferFrom.cda_identifier['root'], "49d75f61-0dec-4972-9a51-e2490b18c772"
    assert transferFrom.codes["LOINC"].include?("77305-1")
    assert_equal transferFrom.start_time, 1415097000
    assert_equal transferFrom.transferFrom.time, 1415097000
    assert transferFrom.transferFrom.codes["SNOMED-CT"].include?("309911002")

    #transfer to
    transferTo = patient.encounters[5]
    assert_equal transferTo.cda_identifier['root'], "49d75f61-0dec-4972-9a51-e2490b18c772"
    assert transferTo.codes["LOINC"].include?("77306-9")
    assert_equal transferTo.start_time, 1415097000
    assert_equal transferTo.transferTo.time, 1415097000
    assert transferTo.transferTo.codes["SNOMED-CT"].include?("309911002")

    #medication active
    medActive = patient.medications[0]
    assert_equal medActive.cda_identifier['root'], "c0ea7bf3-50e7-4e7a-83a3-e5a9ccbb8541"
    assert medActive.codes["RxNorm"].include?("105152")
    assert_equal medActive.administrationTiming["institutionSpecified"], true
    assert_equal medActive.administrationTiming["period"]["unit"], "h"
    assert_equal medActive.administrationTiming["period"]["value"], 6
    assert_equal medActive.start_time, 1092658739
    assert_equal medActive.end_time, 1092676026
    assert_equal medActive.oid, "2.16.840.1.113883.3.560.1.13"
    assert_equal medActive.route["code"], "C38288"
    assert_equal medActive.route["code_system_name"], "NCI Thesaurus"
    assert_equal medActive.productForm["code"], "C42944"
    assert_equal medActive.productForm["code_system"], "NCI Thesaurus"
    assert_equal medActive.doseRestriction["numerator"]["unit"], "oz"
    assert_equal medActive.doseRestriction["numerator"]["value"], 42
    assert_equal medActive.doseRestriction["denominator"]["unit"], "oz"
    assert_equal medActive.doseRestriction["denominator"]["value"], 100
    orderInfo = medActive.orderInformation[0]
    assert_equal orderInfo.orderNumber, "12345"
    assert_equal orderInfo.quantityOrdered["value"], 75
    assert_equal orderInfo.fills, 1
    assert_equal orderInfo.orderDateTime, 1092676026
    assert medActive.status_code["HL7 ActStatus"].include?("active")
    assert medActive.status_code["SNOMED-CT"].include?("55561003")

    #medication dispensed
    medDispensed = patient.medications[1]
    assert_equal medDispensed.cda_identifier['root'], "50f84c1b7042f9877500023e"
    assert_equal medDispensed.oid, "2.16.840.1.113883.3.560.1.8"
    assert medDispensed.codes["RxNorm"].include?("977869")
    assert_equal medDispensed.start_time, 822072083
    assert_equal medDispensed.end_time, 822089605
    assert medDispensed.status_code["HL7 ActStatus"].include?("dispensed")

    #medication administered
    medAdmin = patient.medications[2]
    assert_equal medAdmin.cda_identifier['root'], "278dade0-4307-0130-0add-680688cbd736"
    assert_equal medAdmin.oid, "2.16.840.1.113883.3.560.1.14"
    assert medAdmin.codes["CVX"].include?("33")
    assert_equal medAdmin.start_time, 1165177036
    assert_equal medAdmin.end_time, 1165217102
    assert medAdmin.status_code["HL7 ActStatus"].include?("administered")

    #medication ordered
    medOrder = patient.medications[3]
    assert_equal medOrder.cda_identifier['root'], "50f84c1a7042f987750001d2"
    assert_equal medOrder.oid, "2.16.840.1.113883.3.560.1.17"
    assert medOrder.codes["RxNorm"].include?("866439")
    assert_equal medOrder.start_time, 954202441
    assert_equal medOrder.end_time, 954206964
    assert medOrder.status_code["HL7 ActStatus"].include?("ordered")

    #medication discharge active
    medDischarge = patient.medications[4]
    assert_equal medDischarge.cda_identifier['root'], "21305e00-4308-0130-0ade-680688cbd736"
    assert_equal medDischarge.oid, "2.16.840.1.113883.3.560.1.199"
    assert medDischarge.codes["RxNorm"].include?("994435")
    assert_equal medDischarge.start_time, 1114859893
    assert_equal medDischarge.end_time, 1114914106
    assert medDischarge.status_code["HL7 ActStatus"].include?("discharge")

    #medical device applied
    medDevice = patient.medical_equipment[0]
    assert_equal medDevice.cda_identifier['root'], "510969b3944dfe9bd7000056"
    assert_equal medDevice.anatomicalStructure['code'], "thigh"
    assert_equal medDevice.anatomicalStructure['code_system'], "2.16.840.1.113883.6.96"
    assert_equal medDevice.anatomicalStructure['code_system_name'], "SNOMED-CT"
    assert medDevice.codes["ICD-9-CM"].include?("37.98")
    assert_equal medDevice.start_time, 481091888
    assert medDevice.status_code["HL7 ActStatus"].include?("applied")

    #medical device not ordered
    medDevNO = patient.medical_equipment[1]
    assert_equal medDevNO.cda_identifier['root'], "1.3.6.1.4.1.115"
    assert medDevNO.codes["ICD-9-CM"].include?("48.20")
    assert_equal medDevNO.oid, "2.16.840.1.113883.3.560.1.137"
    assert_equal medDevNO.start_time, 1262304000
    assert_equal medDevNO.end_time, 1293840000
    assert_equal medDevNO.removalTime, 1293840000

    #medication intolerance
    medIntol = patient.allergies[0]
    assert_equal medIntol.cda_identifier['root'], "50f84c1a7042f987750001db"
    assert medIntol.codes["RxNorm"].include?("998695")
    assert_equal medIntol.oid, "2.16.840.1.113883.3.560.1.67"
    assert_equal medIntol.start_time, 1165177036

    #allergy
    patientAllergy = patient.allergies[1]
    assert_equal patientAllergy.cda_identifier['root'], "50f84db97042f9366f00000e"
    assert patientAllergy.codes["RxNorm"].include?("996994")
    assert_equal patientAllergy.oid, "2.16.840.1.113883.3.560.1.7"
    assert_equal patientAllergy.start_time, 303055256
    assert patientAllergy.type["codes"]["ActCode"].include?("ASSERTION")
    assert patientAllergy.reaction["codes"]["SNOMED-CT"].include?("422587007")
    assert patientAllergy.severity["codes"]["SNOMED-CT"].include?("371924009")

    #medication allergy
    medAllergy = patient.allergies[2]
    assert_equal medAllergy.cda_identifier['root'], "50f84db97042f9366f00000e"
    assert medAllergy.codes["RxNorm"].include?("996994")
    assert medAllergy.oid, "2.16.840.1.113883.3.560.1.1"
    assert medAllergy.start_time, 303055256

    #procedure intolerance
    prodIntol = patient.allergies[3]
    assert_equal prodIntol.cda_identifier['root'], "5102936b944dfe3db4000016"
    assert prodIntol.codes["CPT"].include?("90668")
    assert prodIntol.codes["SNOMED-CT"].include?("86198006")
    assert_equal prodIntol.oid, "2.16.840.1.113883.3.560.1.61"
    assert_equal prodIntol.start_time, 1094992715
    assert_equal prodIntol.end_time, 1095042729
    assert prodIntol.values.first.codes["SNOMED-CT"].include?("102460003")
    assert_equal prodIntol.values.first.start_time, 1094992715
    assert_equal prodIntol.values.first.end_time, 1095042729

    #test communication patient to provider
    commPatProv = patient.communications[0]
    assert_equal commPatProv.cda_identifier['root'], "50f84c187042f987750000e5"
    assert_equal commPatProv.oid, "2.16.840.1.113883.3.560.1.30"
    assert commPatProv.codes["SNOMED-CT"].include?("315640000")
    assert_equal commPatProv.direction, "communication_from_patient_to_provider"
    assert_equal commPatProv.negationInd, false
    assert_equal commPatProv.reason["code"], "105480006"
    assert_equal commPatProv.reason["code_system"], "SNOMED-CT"
    assert_equal commPatProv.references[0]["referenced_id"], "56c237ee02d40565bb00030e"
    assert_equal commPatProv.references[0]["referenced_type"], "Procedure"
    assert_equal commPatProv.references[0]["type"], "fulfills"

    #test communication provider to provider
    commProvProv = patient.communications[1]
    assert_equal commProvProv.cda_identifier['root'], "50f84c1d7042f987750003bf"
    assert_equal commProvProv.oid, "2.16.840.1.113883.3.560.1.129"
    assert commProvProv.codes["SNOMED-CT"].include?("371545006")
    assert_equal commProvProv.start_time, 362499961
    assert_equal commProvProv.direction, "communication_from_provider_to_provider"

    #test communication provider to patient
    commProvPat = patient.communications[2]
    assert_equal commProvPat.cda_identifier['root'], "50cf48409eae47465700008f"
    assert_equal commProvPat.oid, "2.16.840.1.113883.3.560.1.31"
    assert commProvPat.codes["LOINC"].include?("69981-9")
    assert_equal commProvPat.start_time, 1275775200
    assert_equal commProvPat.direction, "communication_from_provider_to_patient"

    #test ecog status
    ecogStatus = patient.conditions[5]
    assert_equal ecogStatus.cda_identifier['root'], "50f6c6067042f91c7c000272"
    assert_equal ecogStatus.oid, "2.16.840.1.113883.3.560.1.1001"
    assert ecogStatus.codes["SNOMED-CT"].include?("423237006")

    #test symptom active
    sympActive = patient.conditions[6]
    assert_equal sympActive.cda_identifier['root'], "50f84dbb7042f9366f0001ac"
    assert_equal sympActive.oid, "2.16.840.1.113883.3.560.1.69"
    assert sympActive.codes["SNOMED-CT"].include?("95815000")
    assert_equal sympActive.start_time, 729814935
    assert_equal sympActive.end_time, 729867188
    assert sympActive.status_code["HL7 ActStatus"].include?("active")
    assert sympActive.status_code["SNOMED-CT"].include?("55561003")

    #test diagnosis resolved
    diagResolved = patient.conditions[7]
    assert_equal diagResolved.cda_identifier['root'], "50f84c187042f98775000089"
    assert_equal diagResolved.oid, "2.16.840.1.113883.3.560.1.24"
    assert diagResolved.codes["SNOMED-CT"].include?("94643001")
    assert diagResolved.codes["ICD-10-CM"].include?("C21.8")
    assert diagResolved.codes["ICD-9-CM"].include?("197.5")
    assert diagResolved.status_code["SNOMED-CT"].include?("413322009")

    #test procedure performed
    procPerformed = patient.procedures[1]
    assert_equal procPerformed.cda_identifier['root'], "51083f0e944dfe9bd7000004"
    assert_equal procPerformed.oid, "2.16.840.1.113883.3.560.1.6"
    assert procPerformed.codes["CPT"].include?("55876")
    assert procPerformed.codes["SNOMED-CT"].include?("236211007")
    assert procPerformed.ordinality["codes"]["SNOMED-CT"].include?("63161005")
    assert_equal procPerformed.description, "Procedure, Performed: Salvage Therapy (Code List: 2.16.840.1.113883.3.526.3.399)"
    assert_equal procPerformed.start_time, 506358845
    assert_equal procPerformed.end_time, 506409573
    assert_equal procPerformed.incisionTime, 506358905
    assert_equal procPerformed.negationInd, true
    assert_equal procPerformed.anatomical_target["code"], "28273000"
    assert_equal procPerformed.anatomical_target["code_system"], "SNOMED-CT"
    assert_equal procPerformed.anatomical_target["code_system_oid"], "2.16.840.1.113883.6.96"

    #test negation reason
    negProc = patient.procedures[2]
    assert_equal negProc.negationInd, true
    assert_equal negProc.negationReason["code"], "308292007"
    assert_equal negProc.negationReason["code_system"], "SNOMED-CT"

    assert_equal negProc.values[0].units, "m[IU]/L"
    assert_equal negProc.values[0].scalar, "6"
    assert_equal negProc.values[1].scalar, "true"
    assert_equal negProc.values[2].scalar, "my_string_value"

    #test physical exam performed
    physExam = patient.procedures[3]
    assert_equal physExam.cda_identifier['root'], "5101a4f7944dfe3db4000006"
    assert_equal physExam.oid, "2.16.840.1.113883.3.560.1.57"
    assert physExam.codes["LOINC"].include?("8462-4")
    assert_equal physExam.description, "Physical Exam, Performed: Diastolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1033)"
    assert_equal physExam.start_time, 751003636
    assert_equal physExam.end_time, 751060302
    assert_equal physExam.negationInd, true
    assert physExam.status_code["HL7 ActStatus"].include?("performed")

    #test intervention order
    intervOrder = patient.procedures[4]
    assert_equal intervOrder.cda_identifier['root'], "510831719eae47faed000150"
    assert_equal intervOrder.oid, "2.16.840.1.113883.3.560.1.45"
    assert intervOrder.codes["CPT"].include?("43644")
    assert intervOrder.codes["HCP"].include?("G8417")
    assert intervOrder.codes["ICD-10-CM"].include?("Z71.3")
    assert intervOrder.codes["ICD-9-CM"].include?("V65.3")
    assert intervOrder.codes["SNOMED-CT"].include?("304549008")
    assert_equal intervOrder.start_time, 1277424000
    assert intervOrder.status_code["HL7 ActStatus"].include?("ordered")

    #test intervention performed
    intervPerformed = patient.procedures[5]
    assert_equal intervPerformed.cda_identifier['root'], "510831719eae47faed00019f"
    assert_equal intervPerformed.oid, "2.16.840.1.113883.3.560.1.46"
    assert intervPerformed.codes["HCP"].include?("S3005")
    assert intervPerformed.codes["ICD-10-CM"].include?("Z13.89")
    assert intervPerformed.codes["ICD-9-CM"].include?("V79.0")
    assert intervPerformed.codes["SNOMED-CT"].include?("171207006")
    assert_equal intervPerformed.start_time, 1265371200
    assert_equal intervPerformed.end_time, 1265371200
    assert intervPerformed.status_code["HL7 ActStatus"].include?("performed")

    #test procedure intervention results
    procInterRes = patient.procedures[6]
    assert_equal procInterRes.cda_identifier['root'], "50f84c1c7042f987750002d1"
    assert_equal procInterRes.oid, "2.16.840.1.113883.3.560.1.47"
    assert procInterRes.codes["SNOMED-CT"].include?("428181000124104")
    assert_equal procInterRes.start_time, 1097940444
    assert_equal procInterRes.end_time, 1097959712

    #test procedure order
    procOrder = patient.procedures[7]
    assert_equal procOrder.cda_identifier['root'], "5106e039944dfe4d2000000d"
    assert_equal procOrder.oid, "2.16.840.1.113883.3.560.1.62"
    assert procOrder.codes["CPT"].include?("90870")
    assert procOrder.codes["ICD-10-PCS"].include?("GZB4ZZZ")
    assert procOrder.codes["ICD-9-CM"].include?("94.27")
    assert procOrder.codes["SNOMED-CT"].include?("313020008")
    assert_equal procOrder.time, 1306230203
    assert procOrder.status_code["HL7 ActStatus"].include?("ordered")

    #test procedure results
    procResult = patient.procedures[8]
    assert_equal procResult.cda_identifier['root'], "51095fc3944dfe9bd7000012"
    assert_equal procResult.oid, "2.16.840.1.113883.3.560.1.63"
    assert procResult.codes["SNOMED-CT"].include?("116783008")
    assert_equal procResult.start_time, 1007264866
    assert_equal procResult.end_time, 1007316283

    #test risk category assessment
    riskAssess = patient.procedures[9]
    assert_equal riskAssess.cda_identifier['root'], "510963e9944dfe9bd7000047"
    assert_equal riskAssess.oid, "2.16.840.1.113883.3.560.1.21"
    assert riskAssess.codes["LOINC"].include?("72136-5")
    assert_equal riskAssess.start_time, 744555728
    assert_equal riskAssess.values[0].scalar, "7"

    #test diagnostic study not performed
    diagStudyNP = patient.procedures[10]
    assert_equal diagStudyNP.cda_identifier['root'], "50f84dbb7042f9366f000143"
    assert_equal diagStudyNP.oid, "2.16.840.1.113883.3.560.1.103"
    assert diagStudyNP.codes["LOINC"].include?("69399-4")
    assert_equal diagStudyNP.start_time, 1225314966
    assert_equal diagStudyNP.end_time, 1225321540

    #test diagnostic study results
    diagStudyRes = patient.procedures[11]
    assert_equal diagStudyRes.cda_identifier['root'], "50f84c1b7042f987750001e7"
    assert_equal diagStudyRes.oid, "2.16.840.1.113883.3.560.1.11"
    assert diagStudyRes.codes["LOINC"].include?("71485-7")
    assert_equal diagStudyRes.start_time, 622535563
    assert_equal diagStudyRes.end_time, 622548751
    assert_equal diagStudyRes.negationInd, true
    assert_equal diagStudyRes.negationReason["code"], "79899007"

    #test care goals
    careGoal = patient.care_goals[0]
    assert_equal careGoal.cda_identifier['root'], "F3D6FD73-B2C0-4274-BFD2-A485957734DB"
    assert_equal careGoal.oid, "2.16.840.1.113883.3.560.1.9"
    assert careGoal.codes["SNOMED-CT"].include?("252465000")
    assert_equal careGoal.description, "Care Goal: Pulse Oximetry greater than 92%"
    assert_equal careGoal.start_time, 1293890400

    #test clinical trial participant
    clinTrial = patient.conditions[8]
    assert_equal clinTrial.cda_identifier['root'], "22ab92c0-4308-0130-0ade-680688cbd736"
    assert_equal clinTrial.oid, "2.16.840.1.113883.3.560.1.401"
    assert clinTrial.codes["SNOMED-CT"].include?("428024001")
    assert clinTrial.start_time, 1262304000

    #test patient expired
    assert_equal patient.expired, true
    expired = patient.conditions[9]
    assert_equal expired.cda_identifier['root'], "22aeb750-4308-0130-0ade-680688cbd736"
    assert_equal expired.oid, "2.16.840.1.113883.3.560.1.404"
    assert_equal patient.deathdate, 1450141290

  end
end
