require 'test_helper'

class PictureNumbersControllerTest < ActionController::TestCase
  setup do
    @picture_number = picture_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:picture_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create picture_number" do
    assert_difference('PictureNumber.count') do
      post :create, picture_number: { title: @picture_number.title }
    end

    assert_redirected_to picture_number_path(assigns(:picture_number))
  end

  test "should show picture_number" do
    get :show, id: @picture_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @picture_number
    assert_response :success
  end

  test "should update picture_number" do
    patch :update, id: @picture_number, picture_number: { title: @picture_number.title }
    assert_redirected_to picture_number_path(assigns(:picture_number))
  end

  test "should destroy picture_number" do
    assert_difference('PictureNumber.count', -1) do
      delete :destroy, id: @picture_number
    end

    assert_redirected_to picture_numbers_path
  end
end
