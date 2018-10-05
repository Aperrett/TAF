# frozen_string_literal: true

class TafError < StandardError; end
class UnknownTestStep < TafError; end
class FailureThresholdExceeded < TafError; end
class BrowserFailedOpen < TafError; end
