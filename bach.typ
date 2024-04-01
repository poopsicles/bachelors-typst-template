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
  set page(paper: "a4")
  set par(justify: true, first-line-indent: 1.8em)
  set heading(numbering: "1.")
  set text(font: "New Computer Modern", 14pt)

  show raw: set text(font: "FiraCode Nerd Font Mono")
  show heading.where(level: 1): it => [
    // #set par(justify: false)
    // #set align(center)
    #smallcaps(it.body)

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

  outline(target: figure, title: "Table of Figures")
  pagebreak(weak: true)

  // abstract
  set page(header: [
    #align(right, [
      _ #title _
    ])
  ])

  heading("Abstract", numbering: none)
  par([#abstract])
  pagebreak(weak: true)

  // content
  set page(numbering: "1.")
  counter(page).update(1)
  show heading.where(level: 1): it => [
    #set par(justify: false)
    #set align(center)
    #smallcaps("Chapter " + counter(heading).display() + " " + it.body)
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
