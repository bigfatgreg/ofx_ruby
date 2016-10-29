# frozen_string_literal: true
module OFX
  class Errors < StandardError
    def initialize(options = {})
      @account_type = options[:accoint_type]
    end

    class UserMissing < Errors
      def message
        "You need to include 'user' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_USER as an environment variable."
      end
    end

    class PasswordMissing < Errors
      def message
        "You need to include 'password' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_PASSWORD as an environment variable."
      end
    end

		class FiOrgMissing < Errors
			def message
				"You need to include 'fi_org' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_FI_ORG as an environment variable."
			end
		end

		class FiFidMissing < Errors
			def message
				"You need to include 'fi_fid' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_FI_FID as an environment variable."
			end
		end

		class RoutingMissing < Errors
			def message
				"You need to include 'routing' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_ROUTING as an environment variable."
			end
		end

		class AccountMissing < Errors
			def message
				"You need to include 'account' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_ACCOUNT as an environment variable."
			end
		end

		class AppIdMissing < Errors
			def message
				"You need to include 'app_id' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_APP_ID as an environment variable."
			end
		end

		class AppVerMissing < Errors
			def message
				"You need to include 'app_ver' in the options hash" \
        "when you initialize your ofx document or " \
        "set OFX_APP_VER as an environment variable."
			end
		end

    class URIMissing < Errors
      def message
        'You must specify the uri of the ofx server you' \
        'plan to connect to. in the options hash.'
      end
    end

    class RoutingNumberMissing < Errors
      def message
        'You must specify the routing number for ' \
        'your account in the options hash or ' \
        'set OFX_URI as an environment.'
      end
    end

    class AccountNumberMissing < Errors
      def message
        'You must specify the account number in the options hash.'
      end
    end

    class AccountTypeNotAvailable < Errors
      def message
        "The account type #{@account_type} is not available. " \
        "Please choose :savings, :money_market, :credit_line or " \
        "omit for :checking."
      end
    end
  end
end
