node[:webapp][:rvm][:common_pkgs].each do |p|
  package p
end

# Install system-wide.
node.override.rvm.install_rubies = true

# Install for the app.
node.override.rvm.installs = {app.user.name => true}
node.override.rvm.user_installs = [{
  'user'          => app.user.name,
  'home'          => app.user.home,
  'default_ruby'  => app.ruby_version,
  'install_rubies' => true,
  'rvmrc'         => {
    'rvm_project_rvmrc'     => 1,
    'rvm_trust_rvmrcs_flag' => 1
  },
  'global_gems'   => [
    { 'name'    => 'rubygems-bundler',
      'action'  => 'remove'
    }
  ] + app.gems.map {|g| { 'name' => g } }
}]

# Required to build ruby using rvm
package 'gawk'

include_recipe 'rvm::system'
include_recipe 'rvm::user'

rvm_script = '$HOME/.rvm/scripts/rvm'
ensure_line "#{app.user.home}/.bashrc" do
  content %{[[ -s "#{rvm_script}" ]] && source "#{rvm_script}"}
end
ensure_line "#{app.user.home}/.bashrc" do
  content %{export PATH=$PATH:$HOME/.rvm/bin}
end
