#import "/src/lilaq.typ" as lq



#let minimal(it) = {

  show: lq.set-diagram(
    margin: 5%,
    height: 3cm,
    width: 4cm,
    xaxis: (hidden: true),
    yaxis: (hidden: true),
    grid: none,
    legend: (position: left, dx: 100%),
  )

  it
}
