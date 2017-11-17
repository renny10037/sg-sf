require 'test_helper'

class AsignationsControllerTest < ActionController::TestCase
  setup do
    @asignation = asignations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asignations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asignation" do
    assert_difference('Asignation.count') do
      post :create, asignation: { admin: @asignation.admin, date_end: @asignation.date_end, date_start: @asignation.date_start, description: @asignation.description, observation: @asignation.observation, order_id: @asignation.order_id, payment: @asignation.payment, phase_id: @asignation.phase_id, state_id: @asignation.state_id, user_id: @asignation.user_id }
    end

    assert_redirected_to asignation_path(assigns(:asignation))
  end

  test "should show asignation" do
    get :show, id: @asignation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asignation
    assert_response :success
  end

  test "should update asignation" do
    patch :update, id: @asignation, asignation: { admin: @asignation.admin, date_end: @asignation.date_end, date_start: @asignation.date_start, description: @asignation.description, observation: @asignation.observation, order_id: @asignation.order_id, payment: @asignation.payment, phase_id: @asignation.phase_id, state_id: @asignation.state_id, user_id: @asignation.user_id }
    assert_redirected_to asignation_path(assigns(:asignation))
  end

  test "should destroy asignation" do
    assert_difference('Asignation.count', -1) do
      delete :destroy, id: @asignation
    end

    assert_redirected_to asignations_path
  end
end
