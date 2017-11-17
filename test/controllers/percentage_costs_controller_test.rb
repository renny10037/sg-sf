require 'test_helper'

class PercentageCostsControllerTest < ActionController::TestCase
  setup do
    @percentage_cost = percentage_costs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:percentage_costs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create percentage_cost" do
    assert_difference('PercentageCost.count') do
      post :create, percentage_cost: { order_id: @percentage_cost.order_id, quantify: @percentage_cost.quantify }
    end

    assert_redirected_to percentage_cost_path(assigns(:percentage_cost))
  end

  test "should show percentage_cost" do
    get :show, id: @percentage_cost
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @percentage_cost
    assert_response :success
  end

  test "should update percentage_cost" do
    patch :update, id: @percentage_cost, percentage_cost: { order_id: @percentage_cost.order_id, quantify: @percentage_cost.quantify }
    assert_redirected_to percentage_cost_path(assigns(:percentage_cost))
  end

  test "should destroy percentage_cost" do
    assert_difference('PercentageCost.count', -1) do
      delete :destroy, id: @percentage_cost
    end

    assert_redirected_to percentage_costs_path
  end
end
