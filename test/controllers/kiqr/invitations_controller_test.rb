require "test_helper"

class Kiqr::InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "can view page without beeing signed in" do
    invitation = create(:account_invitation)
    get invitation_path(invitation)
    assert_response :success
  end

  test "can accept invitation" do
    user = create(:user)
    invitation = create(:account_invitation)
    sign_in user

    assert_difference -> { user.accounts.count } do
      post accept_invitation_path(invitation)
    end

    assert_redirected_to dashboard_path(account_id: invitation.account)
    assert_not_nil invitation.reload.accepted_at
  end

  test "cant be accepted twice" do
    user = create(:user)
    invitation = create(:account_invitation, accepted_at: Time.now)
    sign_in user

    get invitation_path(invitation)
    assert_redirected_to dashboard_path

    assert_no_difference -> { user.accounts.count } do
      post accept_invitation_path(invitation)
    end
  end

  test "can reject invitation" do
    user = create(:user)
    invitation = create(:account_invitation)
    sign_in user

    post reject_invitation_path(invitation)

    assert_redirected_to dashboard_path
    assert_nil AccountInvitation.find_by(id: invitation.id)
  end
end
