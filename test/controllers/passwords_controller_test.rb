class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "inherits public methods from Clearance::PasswordsController" do
    expected_ancestor = Clearance::PasswordsController

    assert_includes PasswordsController.ancestors, expected_ancestor
    %i(create edit new update).each do |method|
      PasswordsController.public_method_defined?(method)
    end
  end
end
