module OmniauthMacros

  def facebook_mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456789',
      info: { email: 'test@test.com' }
    })
  end

  def facebook_mock_invalid_auth_hash
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end

  def twitter_mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456789',
      info: { email: nil }
    })
  end

  def twitter_mock_invalid_auth_hash
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end
end
