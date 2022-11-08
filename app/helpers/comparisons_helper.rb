module ComparisonsHelper

  def is_sport?(eidr)
    eidr.starts_with?("com.mtg.content.SPORTS")
  end

end
