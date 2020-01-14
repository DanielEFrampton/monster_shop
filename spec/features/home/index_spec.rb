require 'rails_helper'

RSpec.describe 'Home Page' do
  it "should have a welcome message" do
    visit '/'

    expect(page).to have_content('Ahoy, me hearties! Be ye welcome to Treasure Trove.')
  end
end
