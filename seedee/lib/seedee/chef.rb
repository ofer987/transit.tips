# frozen_string_literal: true

module Seedee
  # Talk to Chef Server
  class Chef
    def bootstrap(droplet, node_name, role_names)
      run_list = "role[#{Array(role_names).join(' ')}]"

      command = <<~COMMAND
        #{File.join('knife')} bootstrap #{droplet.public_ip} \
          --ssh-user #{ssh_user} \
          --sudo \
          --node-name #{node_name.to_s.strip} \
          --run-list '#{run_list}' \
          --ssh-identity-file #{ssh_identity_file} \
          --yes
      COMMAND

      system(command)
    end

    def create_role(name, recipes = [], description = '')
      name = name.to_s.strip

      default_attributes = {
        'chef_client': {
          'interval': 1800,
          'splay': 300
        }
      }

      ::Chef::Role.new.tap do |role|
        role.name(name.to_s.strip)
        role.run_list(Array(recipes).map(&:to_s).map(&:strip))
        role.default_attributes(default_attributes)
        role.description(description.to_s.strip)

        role.save
      end
    end

    def delete_role_and_associated_nodes(search_glob, skip_list = [])
      search_glob = search_glob.to_s.strip
      skip_list = Array(skip_list).map(&:to_s).map(&:strip)

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

    def ssh_user
      'root'
    end

    def role_name
      @role_name ||= "client_#{SecureRandom.uuid}"
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
