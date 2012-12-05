require 'test_helper'

class PlayingsControllerTest < ActionController::TestCase
  setup do
    @playing = playings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:playings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create playing" do
    assert_difference('Playing.count') do
      post :create, playing: { content: @playing.content, game: @playing.game, location: @playing.location }
    end

    assert_redirected_to playing_path(assigns(:playing))
  end

  test "should show playing" do
    get :show, id: @playing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @playing
    assert_response :success
  end

  test "should update playing" do
    put :update, id: @playing, playing: { content: @playing.content, game: @playing.game, location: @playing.location }
    assert_redirected_to playing_path(assigns(:playing))
  end

  test "should destroy playing" do
    assert_difference('Playing.count', -1) do
      delete :destroy, id: @playing
    end

    assert_redirected_to playings_path
  end
end
