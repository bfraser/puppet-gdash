# Add a field to your graph
define gdash::field(
  $data,
  $graph,
  $category     = 'servers',
  $color        = undef,
  $dashboard    = $hostname,
  $legend_alias = $title,
  $scale        = 1,
) {
  Gdash::Graph[$graph] -> Gdash::Field[$title]

  datacat_fragment { "${category}_${graph}_${title}":
    target   => "${gdash::configure::template_dir}/${category}/${dashboard}/${graph}.graph",
    loglevel => 'debug',
    data     => {
      fields => [
        {
          alias => $legend_alias,
          color => $color,
          data  => $data,
          name  => $title,
          scale => $scale,
        }
      ],
    },
  }
}
