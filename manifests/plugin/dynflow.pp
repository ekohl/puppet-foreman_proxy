# = Foreman Proxy Dynflow plugin
#
# This class installs Dynflow support for Foreman proxy
#
# === Parameters:
#
# $enabled::          Enables/disables the plugin
#                     type:boolean
#
# $listen_on::        Proxy feature listens on https, http, or both
#
# $database_path::    Path to the SQLite database file
#
# $console_auth::     Whether to enable trusted hosts and ssl for the dynflow console
#                     type:boolean
#
# $core_listen::      Address to listen on for the dynflow core service
#
# $core_port::        Port to use for the local dynflow core service
#                     type:integer
#
# $use_dynflow_core:: Whether to use dynflow core. This is only needed on 1.13+
#                     installs on RedHat
#                     type:boolean
#
class foreman_proxy::plugin::dynflow (
  $enabled           = $::foreman_proxy::plugin::dynflow::params::enabled,
  $listen_on         = $::foreman_proxy::plugin::dynflow::params::listen_on,
  $database_path     = $::foreman_proxy::plugin::dynflow::params::database_path,
  $console_auth      = $::foreman_proxy::plugin::dynflow::params::console_auth,
  $core_listen       = $::foreman_proxy::plugin::dynflow::params::core_listen,
  $core_port         = $::foreman_proxy::plugin::dynflow::params::core_port,
  $use_dynflow_core  = $::foreman_proxy::plugin::dynflow::params::use_dynflow_core,
) inherits foreman_proxy::plugin::dynflow::params {

  validate_integer($core_port)
  validate_bool($enabled, $console_auth, $use_dynflow_core)
  validate_listen_on($listen_on)
  validate_absolute_path($database_path)

  if $::foreman_proxy::ssl {
    $core_url = "https://${::fqdn}:${core_port}"
  } else {
    $core_url = "http://${::fqdn}:${core_port}"
  }

  foreman_proxy::plugin { 'dynflow':
  } ->
  foreman_proxy::settings_file { 'dynflow':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/dynflow.yml.erb',
  }

  if $use_dynflow_core {
    include ::foreman_proxy::plugin::dynflow_core
  }
}
