# frozen_string_literal: true

module Seedee
  # Talk to Chef Server
  class Chef
    def bootstrap(droplet, node_name, recipes)
      run_list = "recipe[#{Array(recipes).join(' ')}]"

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

    private

    def ssh_user
      'root'
    end

    def ssh_identity_file
      File.join(
        travis_build_dir,
        'secrets',
        'ssh_keys',
        'digital_ocean_rsa'
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
