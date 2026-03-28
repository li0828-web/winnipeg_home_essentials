require "test_helper"

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get checkout_index_url
    assert_response :success
  end

  test "should get create" do
    get checkout_create_url
    assert_response :success
  end

  test "should get invoice" do
    get checkout_invoice_url
    assert_response :success
  end
end
