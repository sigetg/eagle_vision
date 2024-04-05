require "application_system_test_case"

class TermsTest < ApplicationSystemTestCase
  setup do
    @term = terms(:one)
  end

  test "visiting the index" do
    visit terms_url
    assert_selector "h1", text: "Terms"
  end

  test "should create term" do
    visit terms_url
    click_on "New term"

    fill_in "Code", with: @term.code
    fill_in "Descr", with: @term.descr
    fill_in "Enddate", with: @term.endDate
    fill_in "Meta", with: @term.meta
    fill_in "Name", with: @term.name
    fill_in "Startdate", with: @term.startDate
    fill_in "Statekey", with: @term.stateKey
    fill_in "Typekey", with: @term.typeKey
    click_on "Create Term"

    assert_text "Term was successfully created"
    click_on "Back"
  end

  test "should update Term" do
    visit term_url(@term)
    click_on "Edit this term", match: :first

    fill_in "Code", with: @term.code
    fill_in "Descr", with: @term.descr
    fill_in "Enddate", with: @term.endDate
    fill_in "Meta", with: @term.meta
    fill_in "Name", with: @term.name
    fill_in "Startdate", with: @term.startDate
    fill_in "Statekey", with: @term.stateKey
    fill_in "Typekey", with: @term.typeKey
    click_on "Update Term"

    assert_text "Term was successfully updated"
    click_on "Back"
  end

  test "should destroy Term" do
    visit term_url(@term)
    click_on "Destroy this term", match: :first

    assert_text "Term was successfully destroyed"
  end
end
