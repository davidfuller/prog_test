module ComparisonsHelper

  def is_sport?(eidr)
    eidr.starts_with?("com.mtg.content.SPORTS")
  end

  def add_all_checked_sports_button
    "Add all checked (Create new title. Use for sport)"
  end

end
