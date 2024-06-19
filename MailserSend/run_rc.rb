require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------

get_recipients = false

send_reset_password_email = false

verify_email = true

# ------------------------------------------------------------------

authorization_header = {
  authorization: 'Bearer ' + ENV['MAILERSEND_API_TOKEN'],
  content_type: :json,
  accept: :json
}

# ------------------------------------------------------------------ get recipients

if get_recipients

  api_url = 'https://api.mailersend.com/v1/recipients'

  response = RestClient.get api_url, authorization_header

  puts response.to_s

end

# ------------------------------------------------------------------ send reset password

if send_reset_password_email

  api_url = 'https://api.mailersend.com/v1/email'

  values = {
    from: {
      email: 'hello@idesignmarketplace.com',
      name: 'iDesign Marketplace'
    },
    to: [
      {
        email: 'charlieprezzano@gmail.com'
      }
    ],
    bcc: [
      {
        email: 'hello@idesignmarketplace.com'
      }
    ],
    subject: 'Password Reset Request - iDesign Marketplace',
    template_id: '3zxk54v601zgjy6v',
    variables: [
      {
        email: 'charlieprezzano@gmail.com',
        substitutions: [{ var: 'action_url', value: 'https://www.idesignmarketplace.com/reset-password?token=' + 'bKVxB1WGv3ZHSMdsiopEuCTgcFrqmAYfyU5nOt40R6NJkIwD9l' }]
      }
    ]
  }

  response = RestClient.post api_url, values.to_json, authorization_header

  JSON.parse(response)['data']['id'].to_s

  puts response.to_s

end

# ------------------------------------------------------------------ verify an email

if verify_email

  email_address = 'charlieprezzano1@gmail.com'

  api_url = 'https://api.mailersend.com/v1/email-verification/verify'
  values = { email: email_address }
  response = RestClient.post api_url, values.to_json, authorization_header

  puts response.to_s

end

# ------------------------------------------------------------------