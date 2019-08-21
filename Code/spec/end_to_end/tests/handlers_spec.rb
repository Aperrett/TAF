# frozen_string_literal: true

context 'End-to-end tests' do
  subject(:status) do
    system('ruby', '-I', 'lib', 'bin/taf', '-b', 'firefox-headless', '-t',
           'spec/end_to_end/fixtures/handlers')
  end

  it 'return a successful exit code' do
    expect(status).to be true
  end
end
