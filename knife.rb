# See https://docs.getchef.com/config_rb_knife.html for more information
# on knife configuration options

chef_server_ip = 'chef-server'

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'ofer987'
client_key               "#{current_dir}/rsa_chef"
chef_server_url          "https://#{chef_server_ip}/organizations/otium"
cookbook_path            ["#{current_dir}/cookbooks"]
