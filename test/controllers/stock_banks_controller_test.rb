require 'test_helper'

class StockBanksControllerTest < ActionController::TestCase
  setup do
    @stock_bank = stock_banks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_banks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_bank" do
    assert_difference('StockBank.count') do
      post :create, stock_bank: { cod: @stock_bank.cod, name: @stock_bank.name }
    end

    assert_redirected_to stock_bank_path(assigns(:stock_bank))
  end

  test "should show stock_bank" do
    get :show, id: @stock_bank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_bank
    assert_response :success
  end

  test "should update stock_bank" do
    patch :update, id: @stock_bank, stock_bank: { cod: @stock_bank.cod, name: @stock_bank.name }
    assert_redirected_to stock_bank_path(assigns(:stock_bank))
  end

  test "should destroy stock_bank" do
    assert_difference('StockBank.count', -1) do
      delete :destroy, id: @stock_bank
    end

    assert_redirected_to stock_banks_path
  end
end
