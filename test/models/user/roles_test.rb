require 'test_helper'

class User::RolesTest < ActiveSupport::TestCase
  test "founder?" do
    assert create(:user, roles: [:founder]).founder?
    assert create(:user, roles: %i[founder misc]).founder?
    refute create(:user, roles: [:misc]).founder?
  end

  test "admin?" do
    assert create(:user, roles: [:admin]).admin?
    assert create(:user, roles: %i[admin misc]).admin?
    refute create(:user, roles: [:misc]).admin?
  end

  test "staff?" do
    assert create(:user, roles: [:staff]).staff?
    assert create(:user, roles: %i[staff misc]).staff?
    refute create(:user, roles: [:misc]).staff?
  end

  test "maintainer?" do
    assert create(:user, roles: [:maintainer]).maintainer?
    assert create(:user, roles: %i[maintainer misc]).maintainer?
    refute create(:user, roles: [:misc]).maintainer?
  end
end
