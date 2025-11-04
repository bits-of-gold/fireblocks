# frozen_string_literal: true

module Fireblocks
  # Namespace to access Fireblocks api methods
  class API
    class << self
      def get_vault_accounts(query_params: '')
        path = '/v1/vault/accounts_paged'
        path += "?#{query_params}" if query_params.present?

        Request.get(path: path)
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

      # Get all unspent transaction inputs (UTXOs) for a vault account and asset
      #
      # Returns unspent inputs information of an UTXO asset in a vault account.
      # Endpoint: GET /v1/vault/accounts/{vaultAccountId}/{assetId}/unspent_inputs
      #
      # @param vault_account_id [String, Integer] The ID of the vault account (required)
      # @param asset_id [String] The ID of the asset (required, e.g., "BTC", "BTC_TEST", "LTC", "LTC_TEST")
      # @return [Array<Hash>] Array of unspent input objects
      #
      # @example
      #   Fireblocks::API.get_unspent_inputs("0", "BTC")
      #
      # @example Response format
      #   [
      #     {
      #       "input" => {
      #         "txHash" => "6b21446af4a5e3ec588960d2338ab52428a3eb729038146ea09905199723061f",
      #         "index" => 0
      #       },
      #       "address" => "bc1qjhm0h7vhdyu0d0luv34dlz654rmsvg8twywk99",
      #       "amount" => "0.0009",
      #       "confirmations" => 4780,
      #       "status" => "AVAILABLE"
      #     }
      #   ]
      #
      # Response fields:
      # - input (Hash): A representation of an Unspent Transaction Output (UTXO)
      #   - txHash (String): Transaction Hash
      #   - index (Integer): The UTXO index (vOut)
      # - address (String): The blockchain address associated with the UTXO
      # - amount (String): The quantity of the asset held in the UTXO, expressed in base asset units
      # - confirmations (Integer): The count of confirmations on the blockchain for this UTXO
      # - status (String): UTXO Status - one of: "AVAILABLE", "PENDING", "FROZEN"
      #
      # @see https://developers.fireblocks.com/reference/getunspentinputs
      def get_unspent_inputs(vault_account_id, asset_id)
        Request.get(
          path: "/v1/vault/accounts/#{vault_account_id}/#{asset_id}/unspent_inputs"
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

      def set_confirmation_threshold(txId, number_of_confirmation)
        Request.post(
          body: { numOfConfirmations: number_of_confirmation },
          path: "/v1/transactions/#{txId}/set_confirmation_threshold"
        )
      end

      # options: { operation: "TRANSFER", source: { type: "VAULT_ACCOUNT" id: ""}, destination: { type: "VAULT_ACCOUNT", id: ""}, assetId: "ETH", amount: "0.02" }
      def fee_estimate(operation: "TRANSFER", options: {})
        Request.post(
          body: options,
          path: "/v1/transactions/estimate_fee")
      end

      def tx_history(query_params:)
        Request.get(path: "/v1/transactions?#{query_params}")
      end
    end
  end
end
