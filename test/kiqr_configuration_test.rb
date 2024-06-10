require "test_helper"

class KiqrConfigurationTest < ActiveSupport::TestCase
  test "it loads the KIQR gem" do
    assert Kiqr::VERSION
  end

  test "application controller includes Kiqr::Framework" do
    assert ApplicationController.include? Kiqr::Framework
  end
end
