# frozen_string_literal: true

module Seedee
  # Talk to Chef Server
  class Chef
    attr_reader :role_name, :node_name, :recipes, :role_description

    def initialize(role_name, recipes = [], role_description = '')
      self.role_name = role_name.to_s.strip
      self.node_name = "#{role_name}-#{SecureRandom.uuid}"
      self.recipes = Array(recipes).map(&:to_s).map(&:strip)
      self.role_description = role_description.to_s
    end

    def bootstrap(public_ip)
      public_ip = public_ip.to_s.strip
      run_list = "role[#{role_name}]"

      command = <<~COMMAND
        #{File.join('knife')} bootstrap #{public_ip} \
          --ssh-user #{ssh_user} \
          --sudo \
          --node-name #{node_name.to_s.strip} \
          --run-list '#{run_list}' \
          --ssh-identity-file #{ssh_identity_file} \
          --yes
      COMMAND

      system(command)
    end

    def create_role
      default_attributes = {
        'chef_client': {
          'interval': 1800,
          'splay': 300
        }
      }

      ::Chef::Role.new.tap do |role|
        role.name(self.role_name)
        role.run_list(Array(self.recipes))
        role.default_attributes(default_attributes)
        role.description(self.role_description)

        role.save
      end
    end

    def delete_role_and_associated_nodes
      search_glob = "#{self.role_name}*"
      skip_list = Array(self.node_name)

      ::Chef::Search::Query
        .new
        .search('role', "name:#{search_glob}")
        .first
        .reject { |role| skip_list.include?(role.name)}
        .each { |role| role.destroy }

      ::Chef::Search::Query
        .new
        .search('node', "role:#{search_glob}")
        .first
        .reject { |node| skip_list.any? { |item| node.run_list.include?(item) } }
        .each { |node| node.destroy }
    end

    private

    attr_writer :role_name, :node_name, :recipes, :role_description

    def ssh_user
      'root'
    end

    def ssh_identity_file
      File.join(
        travis_build_dir,
        'secrets',
        'ssh_keys',
        'travis_ci_rsa'
      )
    end

    def chef_configuration_file
      ENV['CHEF_CONFIGURATION_PATH']
    end

    def travis_build_dir
      ENV['TRAVIS_BUILD_DIR'] || File.join('~', 'work')
    end
  end
end
