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

    # TODO: function might be broken
    # TODO: encapsulate it within a begin-rescue statement
    def delete_role_and_associated_nodes
      search_glob = "#{self.role_name}*"
      skip_list = Array(self.node_name)

      puts "deleting role with name = '#{search_glob}'"
      ::Chef::Search::Query
        .new
        .search('role', "name:#{search_glob}")
        .first
        .reject { |role| skip_list.include?(role.name)}
        .each { |role| puts role.as_json; role.destroy }
      puts "deleted role with name = '#{search_glob}'"

      puts "deleting node with role = '#{search_glob}'"
      ::Chef::Search::Query
        .new
        .search('node', "role:#{search_glob}")
        .first
        .reject { |node| skip_list.any? { |item| node.run_list.include?(item) } }
        .each { |node| puts node['hostname']; node.destroy }
      puts "deleted node with role = '#{search_glob}'"
    end

    def delete_role
      puts "deleting role with role_name = '#{role_name}'"
      ::Chef::Search::Query
        .new
        .search('role', "name:#{role_name}")
        .first
        .each { |role| role.destroy }
      puts "deleted role with role_name = '#{role_name}'"
    rescue => exception
      puts "error deleting role with node_name = '#{role_name}'"
      puts exception.backtrace
      puts exception
    end

    def delete_node
      puts "deleting node with node_name = '#{node_name}'"
      ::Chef::Search::Query
        .new
        .search('node', "name:#{node_name}")
        .first
        .each { |node| node.destroy }
      puts "deleted node with node_name = '#{node_name}'"
    rescue => exception
      puts "error deleting node with node_name = '#{node_name}'"
      puts exception.backtrace
      puts exception
    end

    def get_nodes
      ::Chef::Search::Query
        .new
        .search('node', "role:#{role_name}")[0]
        .reject { |i| i.nil? }
        .reject { |i| i['ipaddress'].blank? }
        .reject { |i| i['roles'].empty? }
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
