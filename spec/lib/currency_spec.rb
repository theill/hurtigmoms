require File.dirname(__FILE__) + '/../spec_helper'

describe Currency do
  ['DKK', 'USD', 'EUR'].each do |currency|
    it("should support at least #{currency}") { Currency::SUPPORTED.should include(currency) }
  end
  
end