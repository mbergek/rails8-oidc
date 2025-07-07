require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @book = books(:one)
  end

  test "visiting the index" do
    visit books_url
    assert_selector "h1", text: "Books"
  end

  test "should create book" do
    visit books_url
    click_on "New book"

    fill_in "Author", with: @book.author_id
    fill_in "Description", with: @book.description
    fill_in "Title", with: @book.title
    fill_in "User", with: @book.user_id
    click_on "Create Book"

    assert_text "Book was successfully created"
    click_on "Back"
  end

  test "should update Book" do
    visit book_url(@book)
    click_on "Edit this book", match: :first

    fill_in "Author", with: @book.author_id
    fill_in "Description", with: @book.description
    fill_in "Title", with: @book.title
    fill_in "User", with: @book.user_id
    click_on "Update Book"

    assert_text "Book was successfully updated"
    click_on "Back"
  end

  test "should destroy Book" do
    visit book_url(@book)
    accept_confirm { click_on "Destroy this book", match: :first }

    assert_text "Book was successfully destroyed"
  end
end
