require 'test_helper'

class StackBanksControllerTest < ActionController::TestCase
  setup do
    @stack_bank = stack_banks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stack_banks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stack_bank" do
    assert_difference('StackBank.count') do
      post :create, stack_bank: { cod: @stack_bank.cod, name: @stack_bank.name }
    end

    assert_redirected_to stack_bank_path(assigns(:stack_bank))
  end

  test "should show stack_bank" do
    get :show, id: @stack_bank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stack_bank
    assert_response :success
  end

  test "should update stack_bank" do
    patch :update, id: @stack_bank, stack_bank: { cod: @stack_bank.cod, name: @stack_bank.name }
    assert_redirected_to stack_bank_path(assigns(:stack_bank))
  end

  test "should destroy stack_bank" do
    assert_difference('StackBank.count', -1) do
      delete :destroy, id: @stack_bank
    end

    assert_redirected_to stack_banks_path
  end
end
