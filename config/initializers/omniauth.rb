Rails.application.config.middleware.use OmniAuth::Builder do
    
    provider :twitter, 'Cz7YgEQWfdfRyu34zcxKZobXH', 
    'OMFHvo5Txv8xd6sFAjJHeHen4Kr51nvi4wo8XVkX6npJPboC4g'
    
    provider :facebook, '957861170996900', 
    '7925c435e157c51ad884e552fd3a5e38'
    
end