require 'minitest_helper'

class GoExporterTest < Minitest::Test
  def test_valid_cda
    cda = GoCDATools::Export::GoExporter.instance.export_with_ffi(File.read('test/fixtures/records/barry_berry.json'), [JSON.parse(File.read('test/fixtures/measures/cms9v4a.json'))].to_json)
    errors = HealthDataStandards::Validate::CDA.instance().validate(cda)
    assert errors.empty?, "CDA Validation had #{errors.length} error(s). \n \t#{errors.map{|e| e.message}.join("\n\t")}"
  end
end
