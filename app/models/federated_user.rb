class FederatedUser < User
  attr_accessible :service_provider
  after_create :update_profile 
   
  # credentials - user profile data fetched during federated login process
  def initialize(credentials, attributes = {})
    super(attributes)
    @credentials = credentials
  end
  
  # create a unique local login name using 'login@service_provider' pattern
  def self.custom_login(credentials, service)
    login = case service
    when :twitter 
      credentials["screen_name"] + "@" + service.to_s 
    when :facebook
      # example of other service provider - forthcoming
    end 
    login
  end
  
  # calling method for importing user profile from specific service provider
  def update_profile
     method('import_profile_from_' + self.service_provider).call 
  end
  
  # overwrite this - so no activation code generated for federated login
  def make_activation_code
  end
 
  protected    
  
  # import user profile data fetched from Twitter 
  def import_profile_from_twitter
     self.profile.first_name = @credentials['name']
     self.profile.website = @credentials['url']
     self.profile.federated_profile_image_url =  @credentials['profile_image_url']
     self.profile.save
  end
  
  # import user profile data fetched from Google 
  def import_profile_from_google
   # forthcoming
  end
  
  # overwrite this - activation request not necessary
  def send_activation_request
  end
  
  # overwrite this - activation/reset request not necessary
  def send_activation_or_reset_mail
  end
   
end