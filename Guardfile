# frozen_string_literal: true
guard :minitest do
  watch(%r{^test/(.*)_test\.rb$})
  watch(%r{^lib/(.*)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^lib/(ofx|ofx\/errors)\.rb$}) { "test" }
  watch(%r{^test/test_helper\.rb$}) { "test" }
end
