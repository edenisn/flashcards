class SM2CardsReviewer
  attr_accessor :easiness_factor, :number_repetitions, :repetition_interval, :review_date

  # after each repetition access the quality of repetition response in 0-5 grade scale
  QUALITY_OF_RESPONSE = [0, 3, 4, 5]

  def initialize(easiness_factor, number_repetitions, repetition_interval, review_date)
    @easiness_factor = easiness_factor
    @number_repetitions = number_repetitions
    @repetition_interval = repetition_interval
    @review_date = review_date
  end

  def self.translating_card_time(translate_time)
    if translate_time > 0 && translate_time <= 10
      QUALITY_OF_RESPONSE[3] # perfect response
    elsif translate_time > 10 && translate_time <= 15
      QUALITY_OF_RESPONSE[2] # correct response after a hesitation
    elsif translate_time > 15 && translate_time <= 20
      QUALITY_OF_RESPONSE[1] # correct response recalled with serious difficulty
    else
      QUALITY_OF_RESPONSE[0] # complete blackout
    end
  end

  def processing_count_result(quality_of_response)
    if quality_of_response < 3
      @number_repetitions = 0
      @repetition_interval = 0
    else
      @easiness_factor = calculate_easiness_factor(@easiness_factor, quality_of_response)

      if quality_of_response == 3
        @repetition_interval = 0
      else
        @number_repetitions += 1

        @repetition_interval = case @number_repetitions
                               when 1 then 1
                               when 2 then 6
                               else @repetition_interval * @easiness_factor
                               end
      end
    end
    @review_date = DateTime.now + 12.hour + @repetition_interval.floor
  end

  private
    def calculate_easiness_factor(easiness_factor, quality_of_response)
      ef_old = easiness_factor
      q = quality_of_response

      # http://www.supermemo.com/english/ol/sm2.htm
      result = ef_old + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
      result < 1.3 ? 1.3 : result.round(1)
    end
end