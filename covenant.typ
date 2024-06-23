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

// #let x(x: "") = {
//   label(x)
//   figure("hi")
// }

// make a figure of code and pretend it's an image
#let code-figure(caption, code) = {
  set par(justify: false, leading: 0.75em)
  figure(
    block(fill: luma(240), width: 90%, inset: 10pt, radius: 5pt, code),
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
    (num == [1.], "One"),
    (num == "2.", "Two"),
    (num == [2.], "Two"),
    (num == "3.", "Three"),
    (num == [3.], "Three"),
    (num == "4.", "Four"),
    (num == [4.], "Four"),
    (num == "5.", "Five"),
    (num == [5.], "Five"),
  ).find(x => x.at(0)).at(1)
}

// template
#let bach(
  title: none,
  surname: none,
  names: none,
  matric: none,
  abstract: none,
  abbreviations: none,
  supervisor: none,
  dedication: none,
  acknowledgements: none,
  reference-path: none,
  date: datetime.today(),
  content,
) = {
  set page(paper: "a4", margin: (left: 1.25in, right: 1in, top: 1in, bottom: 1in))

  // text is times new roman
  set text(font: "Times New Roman", size: 12pt, hyphenate: false, kerning: false)

  set par(justify: true, leading: 12.6pt)

  set heading(numbering: "1.")
  // show heading: set block(below: 13pt)

  set enum(numbering: (it => strong[#numbering("(i)", it)]), indent: 1cm, body-indent: 0.5cm, number-align: start)

  // code block font
  show raw: set text(font: "FiraCode Nerd Font Mono")

  // table headings bold
  show table.cell.where(y: 0): set text(weight: "bold")
  show table.cell: set par(leading: 0.7em)
  // set table.cell(inset: 10pt) // padding
  // set table(stroke: (cap: "round"))

  // set table.ce
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

  //igure captions bold
  show figure.caption : strong
  show figure.caption.where(kind: "i-figured-table") : it => align(left)[#it]


  // make heading be all caps (when pretty)
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
    number-align: center,
  )

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
  linebreak()
  linebreak()

  grid(
    columns: (55%, auto),
    gutter: 6pt,
    [*#supervisor*], align(bottom)[#line(length: 100%)],
    [_Supervisor_], align(center)[*Signature and Date*],
  )

  linebreak()
  linebreak()
  linebreak()
  linebreak()

  linebreak()

  grid(
    columns: (55%, auto),
    gutter: 6pt,
    [*Prof. Olufunke O. Oladipupo*], align(bottom)[#line(length: 100%)],
    [_Head of Department_], align(center)[*Signature and Date*],
  )

  pagebreak(weak: true)

  // dedication
  heading("Dedication", numbering: none)
  [ 
    // setting paragraph spacing in here 
    // so that it doesnt affect headings
    #show par: set block(below: 18pt)
    #blankify(dedication)
  ]
  pagebreak(weak: true)

  // acknowledgements
  heading("Acknowledgements", numbering: none)
  [
    #show par: set block(below: 18pt)
    #blankify(acknowledgements)
  ]
  pagebreak(weak: true)

  // no more dots
  set outline(fill: none, title: none)

  // table of contents
  [
    #set par(leading: 0.8em)
    // add some spacing. do it the way they want
    #show outline.entry.where(level: 1): it => {
      let x = it.body.fields().at("text", default: "THISISAHACK")
      if x == "THISISAHACK" {
        x = it.body.fields().at("children")
        v(13pt)
        x = "Chapter " + stringify(x.at(0)) + ": " + x.at(2)
      }

      if x == "References" {
        v(13pt)
      }

      link(it.element.location())[#strong(upper(x))]
      box(width: 1fr)
      link(it.element.location())[#strong(it.page)]
    }

    #heading(numbering: none)[TABLE OF CONTENTS]
    *CONTENT*
    #box(width: 1fr)
    *PAGES*

    *COVER PAGE*
    #box(width: 1fr)
    *i*
    #v(-5pt)
    #outline(indent: auto)
    #pagebreak(weak: true)
  ]

  // table of figures
  [
    #show table.cell.where(y: 0): set text(weight: "regular")
    #set table.cell(inset: 0pt)
    #set par(leading: 0.8em)

    #show outline.entry: it => {
      let c = []
      for value in it.body.fields().at("children").slice(4) {
        c += value
      }
      show table: set block(below: 12pt, above: 0pt)
      table(
        columns: (15%, 70%, 10%),
        inset: 10pt,
        stroke: 0pt,
        align: (left, left, right),

      )[#link(it.element.location())[#it.body.at("children").at(2)]][#link(it.element.location())[#c]][#link(
          it.element.location(),
        )[#it.page]]
      v(-10pt)
    }

    #heading(numbering: none)[List of Figures]
    #show table: set block(below: 14pt, above: 0pt)
    #table(
      columns: (15%, 70%, 10%),
      inset: 0pt,
      stroke: 0pt,
      align: (left, center, right),

    )[*FIGURES*][*TITLE OF FIGURES*][*PAGES*]

    #i-figured.outline(target-kind: image, title: none)

    #pagebreak(weak: true)
  ]

  // list of tables
  [
    #show table.cell.where(y: 0): set text(weight: "regular")
    #set table.cell(inset: 0pt)
    #set par(leading: 0.8em)

    #show outline.entry: it => {
      let c = []
      for value in it.body.fields().at("children").slice(4) {
        c += value
      }
      show table: set block(below: 12pt, above: 0pt)
      table(
        columns: (15%, 70%, 10%),
        inset: 10pt,
        stroke: 0pt,
        align: (left, left, right),

      )[#link(it.element.location())[#it.body.at("children").at(2)]][#link(it.element.location())[#c]][#link(
          it.element.location(),
        )[#it.page]]
      v(-10pt)
    }

    #heading(numbering: none)[List of Tables]
    #show table: set block(below: 14pt, above: 0pt)
    #table(
      columns: (15%, 70%, 10%),
      stroke: 0pt,
      align: (left, center, right),

    )[*TABLES*][*TITLE OF TABLES*][*PAGES*]

    #i-figured.outline(target-kind: table, title: none)

    #pagebreak(weak: true)
  ]

  // abbreviations = ("a: dddd", "b: sjsjsjs")
  // abbreviations
  [
    #show table.cell.where(y: 0): set text(weight: "regular")
    #set table.cell(inset: 5pt)
    #set par(leading: 0.8em)
    #heading("Abbreviations", numbering: none)
    #if abbreviations != none {
      table(
        columns: (1fr),
        align: (left),
        stroke: 0pt,
        ..(abbreviations.sorted()),
      )
    }
  ]
  pagebreak(weak: true)

  // abstract
  heading("Abstract", numbering: none)
  [
    // #show par: set block(below: 18pt)
    #set par(leading: 0.5em)
    #blankify(abstract)
  ]
  pagebreak(weak: true)

  // make heading have "chapter x" on top and caps
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

  [
    #show heading: set block(below: 13pt)
    #show par: set block(below: 18pt)

    #content
  ]

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
