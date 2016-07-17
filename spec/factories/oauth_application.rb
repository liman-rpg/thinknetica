FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name "TestOAuth"
    redirect_uri "urn:ietf:wg:oauth:2.0:oob"
    uid '123456'
    secret '654321'
  end
end
