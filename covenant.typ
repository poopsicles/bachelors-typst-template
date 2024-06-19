#import "@preview/i-figured:0.2.4"

// if none, give "blank page template"
#let blankify(thing) = {
  if thing == none {
    align(horizon + center)[
      This page has been intentionally left blank.\
      // Except for the line above this.\
      // And this.

      // You get the idea.
    ]
  } else {
    par[#thing]
  }
}

// make a figure of code and pretend it's an image
#let code-figure(caption, code) = {
  set par(justify: false)
  figure(
    block(fill: luma(240), width:  90%, inset: 10pt, radius: 5pt, code),
    caption: caption,
    kind: image,
    supplement: "Figure",
  )
}

// make a table figure and break it across a page if need be
#let table-figure(caption, table) = {
  set par(justify: false)
  show figure: set block(breakable: true)

  figure(table, caption: caption)
}

// convert num to string for chapter headings
#let stringify(num) = {
  (
    (num == "1.", "One"),
    (num == "2.", "Two"),
    (num == "3.", "Three"),
    (num == "4.", "Four"),
    (num == "5.", "Five"),
  ).find(x => x.at(0)).at(1)
}

// template
#let bach(
  title: none,
  surname: none,
  names: none,
  matric: none,
  abstract: none,
  supervisor: none,
  dedication: none,
  acknowledgements: none,
  reference-path: none,
  date: datetime.today(),
  print: none,
  content,
) = {
  set page(paper: "a4", margin: (left: 1.25in, right: 1in, top: 1in, bottom: 1in))
  set par(justify: true, leading: 12.6pt)
  show par: set block(below: 1.5em)

  set heading(numbering: "1.")

  // text is times new roman
  set text (font: "Times New Roman", size: 12pt, hyphenate: false, kerning: false)

  set enum(numbering: "(i)", indent: 0.39in)

  // code block font
  show raw: set text(font: "FiraCode Nerd Font Mono")

  // table headings bold
  show table.cell.where(y: 0): set text(weight: "bold")
  set table.cell(inset: 10pt) // padding

  // make heading refs. say chapter
  set ref(supplement: it => {
    if it.func() == heading {
      "Chapter"
    }
  })

  // heading sizes
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 3): set text(size: 13pt)

  // fix for nbhyp
  show "-": sym.hyph.nobreak

  // special figure numbering
  show heading: i-figured.reset-counters
  show figure: i-figured.show-figure

  // table captions top
  show figure.where(kind: table): set figure.caption(position: top)

  // make heading be smallcaps (when pretty)
  show heading.where(level: 1): it => [
    #i-figured.reset-counters(it, return-orig-heading: false)
    #set par(justify: false)
    #set align(center)
    #upper(it.body)
    #linebreak()
    #linebreak()
  ]

  // title page
  align(
    horizon + center,
    [
      #set text(weight: "bold", size: 16pt)
      #set par(justify: false)
      #upper([
        #title

        #linebreak()
        #linebreak()
        #linebreak()

        by

        #linebreak()
        #linebreak()
        #linebreak()

        #surname, #text(weight: "regular")[#names]
        #linebreak()
        (#matric)

        #linebreak()

        A Project Submitted to the Department of Computer and Information Sciences,
        College of Science and Technology, Covenant University Ota, Ogun State.

        #linebreak()

        In Partial Fulfilment of the Requirements for the Award of the Bachelor of
        Science (Honours) Degree in Computer Science.

        #linebreak()

        #date.display("[month repr:long] [year]")
      ])
    ],
  )

  pagebreak(weak: true)
  set page(
    numbering: "i",
    number-align: if print == true {
      center
    } else {
      right
    },
  )
  counter(page).update(1)

  // certification
  heading("Certification", numbering: none)

  par[
    I hereby certify that this project was carried out by #names #upper[#surname] in the
    Department of Computer and Information Sciences, College of Science and
    Technology, Covenant University, Ogun State, Nigeria, under my supervision.
  ]

  linebreak()
  linebreak()
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
  linebreak()
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

  // tables of contents, tables, figures
  outline(title: "Table of Contents", indent: auto)
  pagebreak(weak: true)

  i-figured.outline(target-kind: table, title: "List of Tables")
  pagebreak(weak: true)

  i-figured.outline(target-kind: image, title: "List of Figures")
  pagebreak(weak: true)

  // abstract
  heading("Abstract", numbering: none)
  blankify(abstract)
  pagebreak(weak: true)

  // content
  set page(numbering: "1")
  counter(page).update(1)

  // make heading have "chapter x" on top and smallcaps
  show heading.where(level: 1): it => [
    #i-figured.reset-counters(it, return-orig-heading: false)
    #set par(justify: false)
    #set align(center)
    #linebreak()
    #upper("Chapter " + stringify(counter(heading).display()))
    #linebreak()
    #upper(it.body)
    #linebreak()
    #linebreak()
  ]

  content

  // references
  // make heading be smallcaps
  show heading.where(level: 1): it => [
    #i-figured.reset-counters(it, return-orig-heading: false)
    #set par(justify: false)
    #set align(center)
    #upper(it.body)
    #linebreak()
    #linebreak()
  ]

  pagebreak(weak: true)
  bibliography(
    reference-path,
    title: "References",
    style: "american-psychological-association",
  )
}
