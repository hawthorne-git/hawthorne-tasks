require 'pkce_challenge'

pkce_challenge = PkceChallenge.challenge

puts pkce_challenge.code_verifier
puts pkce_challenge.code_challenge

puts Time.now.to_i