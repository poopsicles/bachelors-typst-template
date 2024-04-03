#import "@preview/i-figured:0.2.4"

#let blankify(thing) = {
  if thing == none {
    align(horizon+center)[
      This page is intentionally left blank.
    ]
  } else {
    par[#thing]
  }
}

#let bach(
  title: none,
  author: none,
  matric: none,
  abstract: none,
  supervisor: none,
  dedication: none,
  acknowledgements: none,
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
    #linebreak()
    #linebreak()
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

  // certification
  heading("Certification", numbering: none)

  par(
    )[
    I hereby certify that this project was carried out by #author (#matric) in the
    Department of Computer and Information Sciences, College of Science and
    Technology, Covenant University, Ogun State, Nigeria, under my supervision.
  ]

  linebreak()
  linebreak()

  grid(
    columns: (55%, auto),
    gutter: 10pt,
    [*#supervisor*],
    align(bottom)[#line(length: 100%)],
    [_Supervisor_],
    align(center)[*Signature and Date*],
  )

  linebreak()
  linebreak()

  grid(
    columns: (55%, auto),
    gutter: 10pt,
    [*Professor Olufunke O. Oladipupo*],
    align(bottom)[#line(length: 100%)],
    [_Head of Department_],
    align(center)[*Signature and Date*],
  )

  pagebreak(weak: true)

  // dedication
  heading("Dedication", numbering: none)
  blankify(dedication)
  pagebreak(weak: true)

  // acknowledgements
  heading("Acknowledgements", numbering: none)
  blankify(acknowledgements)
  pagebreak(weak: true)

  // tables // todo fix
  outline(target: heading, title: "Table of Contents")
  pagebreak(weak: true)

  outline(target: figure.where(kind: image), title: "Table of Figures")
  pagebreak(weak: true)

  outline(target: figure.where(kind: table), title: "List of Tables")
  pagebreak(weak: true)

  // abstract
  heading("Abstract", numbering: none)
  blankify(abstract)
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
    #linebreak()
    #linebreak()
  ]

  content

  // references
  pagebreak(weak: true)
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
    supplement: "Figure",
  )
}
