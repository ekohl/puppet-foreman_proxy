class foreman_proxy::plugin::dynflow_core {
  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {
    $scl_prefix = 'tfm-'
  } else {
    $scl_prefix = '' # lint:ignore:empty_string_assignment
  }

  foreman_proxy::plugin { 'dynflow_core':
    package => "${scl_prefix}${::foreman_proxy::plugin_prefix}dynflow_core",
  } ~>
  file { '/etc/smart_proxy_dynflow_core/settings.yml':
    ensure  => file,
    content => template('foreman_proxy/plugin/dynflow_core.yml.erb'),
  } ~>
  service { 'smart_proxy_dynflow_core':
    ensure => running,
    enable => true,
  }
}
