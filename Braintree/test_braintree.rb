require 'braintree'

# ----------------------------------------------------------------------------------------

puts 'Staring Braintree Test ...'

# ----------------------------------------------------------------------------------------

production_env = :production
sandbox_env = :sandbox
environment = sandbox_env

# ----------------------------------------------------------------------------------------

customer_id = 51606265339

create_customer = false

find_customer = true

update_customer = false

# ----------------------------------------------------------------------------------------

merchant_id = (environment == production_env) ? ENV['BRAINTREE_MERCHANT_ID'] : ENV['BRAINTREE_MERCHANT_SANDBOX_ID']
public_key = (environment == production_env) ? ENV['BRAINTREE_PUBLIC_KEY'] : ENV['BRAINTREE_PUBLIC_SANDBOX_KEY']
private_key = (environment == production_env) ? ENV['BRAINTREE_PRIVATE_KEY'] : ENV['BRAINTREE_PRIVATE_SANDBOX_KEY']

puts ''
puts 'environment: ' + environment.to_s
puts 'merchant_id: ' + merchant_id.to_s
puts 'public_key: ' + public_key.to_s
puts 'private_key: ' + private_key.to_s

# ----------------------------------------------------------------------------------------
# establish a gateway connection

gateway = Braintree::Gateway.new(
  environment: environment,
  merchant_id: merchant_id,
  public_key: public_key,
  private_key: private_key
)

client_token = gateway.client_token.generate
puts ''
puts 'client_token: ' + client_token.to_s

# ----------------------------------------------------------------------------------------
# create a customer, save to the vault

if create_customer

  customer = gateway.customer.create!(email: 'jen@example.com')

  puts ''
  puts 'customer.id: ' + customer.id.to_s

end

# ----------------------------------------------------------------------------------------
# find a customer from the vault

if find_customer

  customer = gateway.customer.find(customer_id.to_s)

  puts ''
  puts 'customer.id: ' + customer.id.to_s
  puts 'customer.email: ' + customer.email.to_s

end

# ----------------------------------------------------------------------------------------

if update_customer

  gateway.customer.update(customer_id, email: 'jen.updated@example.com')

  customer = gateway.customer.find(customer_id)

  puts ''
  puts 'customer.id: ' + customer.id.to_s
  puts 'customer.email: ' + customer.email.to_s

end

# ----------------------------------------------------------------------------------------
