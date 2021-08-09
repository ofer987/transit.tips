# frozen_string_literal: true

module Seedee
  # Talk to Chef Server
  class Vaults
    def self.deps(&block)
    end

    def self.option(*args)
    end

    include ::Chef::Knife::VaultBase

    def refresh
      item_names.each do |vault_name, item_name|
        begin
          ChefVault::Item.new(vault_name, item_name).refresh
        rescue => exception
          puts "error refreshing vault = (#{vault_name}), item = (#{item_name})"
      end
    end

    def vault_names
      ::Chef::DataBag.list.keys
    end

    def item_names
      vault_names
        .select { |name| bag_is_vault? name }
        .map { |name| [name, split_vault_keys(::Chef::DataBag.load(name))[1]] }
        .to_h
    end
  end
end
