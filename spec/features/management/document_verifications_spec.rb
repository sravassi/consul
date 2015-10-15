require 'rails_helper'

feature 'DocumentVerifications' do

  background do
    login_as_manager
  end

  scenario 'Verifying a level 3 user shows an "already verified" page' do
    user = create(:user, :level_three)

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: user.document_number
    click_button 'Check'

    expect(page).to have_content "already verified"
  end

  scenario 'Verifying a level 2 user displays the verification form' do

    user = create(:user, :level_two)

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: user.document_number
    click_button 'Check'

    expect(page).to have_content "Vote proposals"

    click_button 'Verify'

    expect(page).to have_content "already verified"

    expect(user.reload).to be_level_three_verified
  end

  scenario 'Verifying a user which does not exist and is not in the census shows an error' do

    expect_any_instance_of(Verification::Management::Document).to receive(:in_census?).and_return(false)

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: "inexisting"
    click_button 'Check'

    expect(page).to have_content "This document is not registered"
  end

  scenario 'Verifying a user which does exists in the census but not in the db redirects allows sending an email' do

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: '1234'
    click_button 'Check'

    expect(page).to have_content "Please introduce the email used on the account"
  end

end