# frozen_string_literal: true

module Fireblocks
  # Namespace to access Fireblocks api methods
  class API
    class << self
      def get_vault_accounts
        Request.get(path: '/v1/vault/accounts_paged')
      end

      def create_vault_account(name:, customer_ref_id:)
        Request.post(body: { name: name, customerRefId: customer_ref_id }, path: '/v1/vault/accounts')
      end

      def get_vault_account(id)
        Request.get(path: "/v1/vault/accounts/#{id}")
      end

      def update_vault_account(vault_account_id, name:)
        Request.put(
          body: { name: name },
          path: "/v1/vault/accounts/#{vault_account_id}"
        )
      end

      def get_vault_account_asset(vault_account_id, asset_id)
        Request.get(path: "/v1/vault/accounts/#{vault_account_id}/#{asset_id}")
      end

      def create_vault_account_asset(vault_account_id, asset_id)
        Request.post(
          body: {},
          path: "/v1/vault/accounts/#{vault_account_id}/#{asset_id}"
        )
      end

      def create_deposit_address(vault_account_id, asset_id, description: nil, customer_ref_id: nil)
        Request.post(
          body: { description: description, customerRefId: customer_ref_id },
          path: "/v1/vault/accounts/#{vault_account_id}/#{asset_id}/addresses"
        )
      end

      def get_deposit_addresses(vault_account_id, asset_id)
        Request.get(
          path: "/v1/vault/accounts/#{vault_account_id}/#{asset_id}/addresses"
        )
      end

      def get_internal_wallet(wallet_id)
        Request.get(path: "/v1/internal_wallets/#{wallet_id}")
      end

      def get_internal_wallets
        Request.get(path: '/v1/internal_wallets')
      end

      def create_internal_wallet(name:)
        Request.post(body: { name: name }, path: '/v1/internal_wallets')
      end

      def get_supported_assets
        Request.get(path: '/v1/supported_assets')
      end

      def resend_webhook(txId)
        Request.post(
          body: { resendStatusUpdated: true, resendCreated: false },
          path: "/v1/webhooks/resend/#{txId}")
      end

      def create_new_transaction(options: {})
        Request.post(
          body: options,
          path: "/v1/transactions"
        )
      end

      def get_transaction(txId)
        Request.get(path: "/v1/transactions/#{txId}")
      end

      def get_tx_by_external_tx_id(external_tx_id)
        Request.get(path: "/v1/transactions/external_tx_id/#{external_tx_id}/")
      end

      # options: { operation: "TRANSFER", source: { type: "VAULT_ACCOUNT" id: ""}, destination: { type: "VAULT_ACCOUNT", id: ""}, assetId: "ETH", amount: "0.02" }
      def fee_estimate(operation: "TRANSFER", options: {})
        Request.post(
          body: options,
          path: "/v1/transactions/estimate_fee")
      end
    end
  end
end
