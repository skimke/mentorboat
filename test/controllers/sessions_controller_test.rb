class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "inherits public methods from Clearance::SessionsController" do
    expected_ancestor = Clearance::SessionsController

    assert_includes SessionsController.ancestors, expected_ancestor
    %i(create destroy new).each do |method|
      SessionsController.public_method_defined?(method)
    end
  end
end
