object false
node(:success) { @result.success? ? Spree.t(@result.value) : '' }
node(:error) { @result.failure? ? Spree.t(@result.value) : '' }
node(:successful) { @result.success? }
node(:status_code) { @result.value }
