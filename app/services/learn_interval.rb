class LearnInterval

  def initialize(card, answer, time = 0)
    @card = card
    @answer = answer
    @time = time
  end

  def check_translation
    @card.original_text == @answer
  end

  def update_card
    @new_iteration = @card.iteration.nil? ? 1 : @card.iteration + 1
    @quality = get_quality
    new_efactor = calc_efactor(@quality)
    number_of = calc_interval(@quality)

    @card.update_attributes(review_date: number_of.days.from_now, interval: number_of, efactor: new_efactor, iteration: @new_iteration)
  end

  def calc_interval(q)
    if q < 3
      0
    elsif @new_iteration == 1
      1
    elsif @new_iteration == 2
      6
    elsif check_translation
      (@card.interval.eql?(0.0) ? 1 : @card.interval)*calc_efactor(q).round
    else 0
    end
  end

  def calc_efactor(q)
    @card.efactor < 1.3 ? 1.3 : (@card.efactor - 0.8 + 0.28*q - 0.02*q*q)
  end

  def get_quality
    if check_translation
      ((get_distance + get_time_of_answer) / 2.0).round
    else
      get_distance
    end
  end

  def get_distance
    # Get rating according to diff of the words
    case levenshtein_distance
    when 0 then 5
    when 0.01..0.2 then 4
    when 0.21..0.4 then 3
    when 0.41..0.6 then 2
    when 0.61..0.8 then 1
    when 0.81..1 then 0
    end
  end

  def get_time_of_answer
    # Get rating according to time that was needed to answer
    case (@time.to_f / 1000.0).round
    when 0..10 then 5
    when 11..20 then 4
    when 21..30 then 3
    when 31..40 then 2
    when 41..50 then 1
    else 0
    end
  end

  def levenshtein_distance
    Levenshtein.distance(@card.original_text, @answer)
  end
end
