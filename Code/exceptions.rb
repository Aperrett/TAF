class TafError < StandardError; end
class UnknownTestStep < TafError; end
class FailureThresholdExceeded < TafError; end