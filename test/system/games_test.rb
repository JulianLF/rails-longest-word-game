require 'application_system_test_case'

class GamesTest < ApplicationSystemTestCase
  test 'Going to /new gives us a new random grid to play with' do
    visit new_url
    assert test: 'New game'
    assert_selector 'li', count: 10
  end

  test 'visiting /new renders the form' do
    visit new_url
    assert_selector 'p', text: 'What is the longest word you can find ?'
  end

  test 'fill the fotm with random word expect word not in the grid' do
    visit new_url
    fill_in 'word', with: 'hello'
    click_on 'Play'

    assert_text "Sorry but hello can't be built out of the grid"
  end

  test 'fill the form with one letter consonant word expect not valid English word' do
    visit new_url
    fill_in 'word', with: 'q'
    click_on 'Play'

    assert_text 'Sorry but q does not seem to be a valid English word...'
  end

  test 'fill the form with valid English word and expect congrat message' do
    visit new_url
    fill_in 'word', with: 'lab'
    click_on 'Play'

    assert_text 'Congratulations!'
  end
end
