class Report
  class Analyser
    GOOD = [
      'running well',
      '',
      'all clear',
    ].freeze

    BAD = [
      'turning back',
      'stalled',
      'service suspended',
      'diverting',
      'holding',
      'delayed',
      'police',
      'changing'
    ].freeze

    def smooth_road?(description)
      Regexp
        .new(BAD.join('|'), Regexp::IGNORECASE)
        .match(description.to_s)
        .nil?
    end
  end
end
