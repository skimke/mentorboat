class UsersControllerTest < ActionDispatch::IntegrationTest
  test "inherits from Clearance::UsersController" do
    expected_ancestor = Clearance::UsersController

    assert_includes UsersController.ancestors, expected_ancestor
    %i(create new).each do |method|
      UsersController.public_method_defined?(method)
    end
  end
end
