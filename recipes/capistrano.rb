# Prepare dirs for capistrano deployment, similar to running `cap deploy:setup`

directory app.path do
  owner app.user.name
  group app.user.group
  mode 0755
end

[app.releases_path, app.shared_path, app.log_path, app.system_path, app.run_path, app.init_path].each do |dir|
  directory dir do
    owner app.user.name
    group app.user.group
    mode 0775
  end
end

directory "#{app.releases_path}/empty" do
  owner app.user.name
  group app.user.group
  mode 0775
  not_if "test -f #{app.current_path}"
end

directory "#{app.releases_path}/empty/config" do
  owner app.user.name
  group app.user.group
  mode 0700
  not_if "test -f #{app.current_path}"
end

directory app.shared_path do
  owner app.user.name
  group app.user.group
  mode 0700
end

directory "#{app.shared_path}/config" do
  owner app.user.name
  group app.user.group
  mode 0700
end

directory "#{app.shared_path}/assets" do
  owner app.user.name
  group app.user.group
  mode 0775
end

# Create an empty manifest.json to start out with before anything's deployed.
# It doesn't appear to be actually used by Business-Portal though,
# as ember-cli takes care of asset building.
file "#{app.shared_path}/assets/manifest.json" do
  owner app.user.name
  group app.user.group
  mode 0664
  not_if "test -f #{app.current_path}"
end

# Finally, link the current release to the dummy 'empty' release.
link app.current_path do
  to "#{app.releases_path}/empty"
  not_if "test -L #{app.current_path}"
end
