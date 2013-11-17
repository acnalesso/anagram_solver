require 'spec_helper'

feature "angram solver", js: true do

  given!(:word_list) { File.expand_path("../../support/words", __FILE__) }

  background do
    visit "/"
    attach_file("dict", word_list)
    click_button "upload"
  end

  scenario "must make search_area visible" do
    page.has_selector?("#search_area", visible: true).should be_true
  end

  scenario "must find anagrams for pots" do
    fill_in(:word, with: "pots")
    click_button("find")
    page.has_content?("stop").should be_true
    puts page.html
  end

end
