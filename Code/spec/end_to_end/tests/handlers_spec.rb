context 'End-to-end tests' do
  subject(:status) do
    system('taf', '-b', 'firefox-headless', '-t', '/e2e/fixtures/handlers')
  end

  it 'return a successful exit code' do
    expect(status).to be true
  end
end
