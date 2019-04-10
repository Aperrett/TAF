context 'basic_spec.rb' do
  status = nil

  before(:context) do
    status = system(
      'docker-compose',
      '-f',
      "#{__dir__}/docker-compose.yml",
      'up',
      '--build',
      '--exit-code-from',
      'taf'
    )
  end

  context 'When running basic end-to-end tests' do
    it 'returns a successful exit code' do
      expect(status).to be true
    end
  end
end
