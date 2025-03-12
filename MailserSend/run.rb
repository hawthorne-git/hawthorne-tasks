require 'json/ext'
require 'mailersend-ruby'

ms_client = Mailersend::Client.new(ENV['MAILERSEND_API_TOKEN'])

# Intialize the email class
ms_email = Mailersend::Email.new(ms_client)

# Add parameters
ms_email.add_recipients(email: 'charlieprezzano@gmail.com')
ms_email.add_from(email: 'hello@idesignmarketplace.com', name: 'iDesign Marketplace')
ms_email.add_bcc(email: 'hello@idesignmarketplace.com') if false
ms_email.add_subject('Password Reset Request - iDesign Marketplace ')
ms_email.add_template_id('jpzkmgqdd51l059v')

variables = {
  email: 'charlieprezzano@gmail.com',
  substitutions: [
    {
      var: 'action_url',
      value: 'https://www.idesignmarketplace.com/create-art'
    }
  ]
}

ms_email.add_variables(variables)

# Send the email
response = ms_email.send
puts response.to_s