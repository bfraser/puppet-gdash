# Create a graph
define gdash::graph(
  $area        = 'none',
  $category    = 'servers',
  $dashboard   = $hostname,
  $description = '',
  $graph_title = $title,
  $vtitle      = '',
  $ymax        = undef,
  $ymin        = undef,
) {
  Gdash::Dashboard[$dashboard] -> Gdash::Graph[$title]

  $graph_file = "${gdash::configure::template_dir}/${category}/${dashboard}/${title}.graph"

  datacat { $graph_file:
    template => 'gdash/graph.erb',
  }

  datacat_fragment { "${category}_${title}":
    data     => {
      area        => $area,
      description => $description,
      graph_title => $graph_title,
      vtitle      => $vtitle,
      ymax        => $ymax,
      ymin        => $ymin,
    },
    loglevel => 'debug',
    target   => $graph_file,
  }
}
