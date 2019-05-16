# frozen_string_literal: true

require 'rexml/document'

context 'End-to-end tests' do
  subject(:status) do
    system('taf', '-b', 'firefox-headless', '-t', '/e2e/fixtures/basic')
  end

  it 'return a successful exit code' do
    expect(status).to be true
  end

  it 'save a test report' do
    report = './Results/Tests/24-Dec-2018_20_30_test_result.xml'

    expect(File.exist?(report)).to be true

    # FIXME: The following tests should be moved to the unit level.
    xml = REXML::Document.new(File.new(report), ignore_whitespace_nodes: :all)

    expect(xml.root['classname']).to eq('/e2e/fixtures/basic')
    expect(xml.root['name']).to eq('/e2e/fixtures/basic')
    expect(xml.root['tests']).to eq('1')
    expect(xml.root['timestamp']).to eq('Mon Dec 24 20:30:00 UTC')

    test_suite = xml.root[0]

    expect(test_suite['assertions']).to eq('1')
    expect(test_suite['classname']).to eq('/e2e/fixtures/basic/basic.json')
    expect(test_suite['name']).to eq('/e2e/fixtures/basic/basic.json')
    expect(test_suite['tests']).to eq('1')

    test_case = test_suite[0]

    expect(test_case['classname'])
      .to eq('SuiteID: End-to-End Test Step: 1 Test Open_URL')
    expect(test_case['file']).to eq('/e2e/fixtures/basic/basic.json')
    expect(test_case['id']).to eq('1')
    expect(test_case['name']).to eq('Test Open_URL')
  end
end
