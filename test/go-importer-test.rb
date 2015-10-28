require 'minitest_helper'

class GoImporterTest < Minitest::Test
  def test_demographics
    patient = GoCDATools::Import::GoImporter.instance.parse_with_ffi('test/fixtures/qrda/cat1_good.xml')
    assert_equal patient.first, "Norman"
    assert_equal patient.last, "Flores"
    assert_equal patient.birthdate, 599616000
    assert_equal patient.gender, "M"
    assert_equal patient.race["code"], "1002-5"
    assert_equal patient.race["code_set"], "CDC Race and Ethnicity"
    assert_equal patient.ethnicity["code"], "2186-5"
    assert_equal patient.ethnicity["code_set"], "CDC Race and Ethnicity"
  end
end
