#import "@preview/i-figured:0.2.4"

#let bach(
  title: none,
  author: none,
  matric: none,
  abstract: none,
  acknowledgements: none,
  dedication: none,
  date: datetime.today(),
  content,
) = {
  set page(paper: "a4", margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in))
  set par(justify: true, leading: 0.7em)
  set heading(numbering: "1.")
  set text(font: "New Computer Modern", 12pt)
  set enum(numbering: "i.")

  show raw: set text(font: "FiraCode Nerd Font Mono")

  // heading sizes
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 3): set text(size: 13pt)

  // make links blue/underline
  show link: underline
  show link: set text(fill: blue)

  // fix for nbhyp
  show "-": sym.hyph.nobreak

  // special figure numbering
  show heading: i-figured.reset-counters
  show figure: i-figured.show-figure

  show heading.where(level: 1): it => [
    #set par(justify: false)
    #set align(center)
    #smallcaps(it.body)
    \
    \
  ]

  // title page
  align(center, [
    #set text(weight: "bold")
    #set par(justify: false)
    #smallcaps([
      #title

      #author, #matric

      Covenant University, Ota, Ogun, Nigeria

      #image("covenant.png", width: 17%)

      #date.display("[month repr:long] [year]")
    ])
  ])
  pagebreak(weak: true)

  set page(numbering: "i.", number-align: right)

  // acknowledgements
  heading("Acknowledgements", numbering: none)
  par([#acknowledgements])
  pagebreak(weak: true)

  // dedication
  heading("Dedication", numbering: none)
  par([#dedication])
  pagebreak(weak: true)

  // tables
  outline(target: heading, title: "Table of Contents")
  pagebreak(weak: true)

  outline(target: figure.where(kind: image), title: "Table of Figures")
  pagebreak(weak: true)

  outline(target: figure.where(kind: table), title: "List of Tables")
  pagebreak(weak: true)

  // abstract
  // set page(header: [
  //   #align(right, [
  //     _ #title _
  //   ])
  // ])

  heading("Abstract", numbering: none)
  par([#abstract])
  pagebreak(weak: true)

  // content
  set page(numbering: "1.")
  counter(page).update(1)

  show heading.where(level: 1): it => [
    #set par(justify: false)
    #set align(center)
    #smallcaps("Chapter " + counter(heading).display()) 
    #linebreak()
    #smallcaps(it.body)
    \
    \
  ]

  // columns(2, content)
  content

  // references
  pagebreak(weak: true)
  set page(header: [])
  bibliography(
    "../references.yml",
    title: "References",
    style: "american-psychological-association",
  )
}

#let code-figure(caption, code) = {
  figure(
    block(fill: luma(240), width: 90%, inset: 10pt, code), 
    caption: caption, 
    kind: image, 
    supplement: "Figure"
  )
}