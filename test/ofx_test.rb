require 'test_helper'

class OFXTest < Minitest::Test
  describe OFX::VERSION do
    it 'has a version number' do
      refute_nil ::OFX::VERSION
    end
  end
end
