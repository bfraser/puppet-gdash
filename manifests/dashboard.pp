# Create a dashboard
define gdash::dashboard(
  $category         = 'servers',
  $description      = '',
  $graph_properties = {},
) {
  Gdash::Category[$category] -> Gdash::Dashboard[$title]

  $dashboard_dir = "${gdash::configure::template_dir}/${category}/${title}"

  file { $dashboard_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "${dashboard_dir}/dash.yaml":
    ensure  => file,
    content => template('gdash/dash.yaml.erb'),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    require => File[$dashboard_dir],
  }
}
