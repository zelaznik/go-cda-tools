require 'minitest_helper'

class GoExporterTest < Minitest::Test
  def test_hello
    puts GoCDATools::Export::GoExporter.instance.export_with_ffi(File.read('test/fixtures/records/barry_berry.json'))
    # assert_equal "Hello world", patient
  end
end
