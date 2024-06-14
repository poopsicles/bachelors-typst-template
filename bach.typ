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
    (num == "2.", "Two"),
    (num == "3.", "Three"),
    (num == "4.", "Four"),
    (num == "5.", "Five"),
  ).find(x => x.at(0)).at(1)
}

// template
#let bach(
  title: none,
  author: none,
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
  set page(paper: "a4", margin: (top: 1in, bottom: 1in, left: 1.5in, right: 1in))
  set par(justify: true, leading: 0.75em)
  set heading(numbering: "1.")

  // Times doesn't have small caps, so we improvise
  let embiggen = if print == true { upper } else { smallcaps }

  // text is comp. modern normally
  // times when printing
  set text(
    font: if print == true {
      "Times New Roman"
    } else {
      "New Computer Modern"
    },
    12pt,
  )

  set enum(numbering: "i.")

  // make footnotes have dots above them
  // except the default when printing
  set footnote.entry(separator: if print == true {
    line(length: 30%, stroke: 0.5pt)
  } else {
    repeat[.]
  })

  // make heading refs. say chapter
  set ref(supplement: it => {
    if it.func() == heading {
      "Chapter"
    }
  })

  // make first row of table grey
  set table(
    fill: (_, y) => if y == 0 {
      luma(230)
    },
    align: horizon,
  )
  set table.cell(inset: 10pt) // padding

  // code block font
  show raw: set text(font: "FiraCode Nerd Font Mono")

  // table headings bold
  show table.cell.where(y: 0): set text(weight: "bold")

  // heading sizes
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 3): set text(size: 13pt)

  // make links blue/underline unless printing
  show link: it => if print == true {
    it
  } else {
    set text(fill: blue)
    underline(it)
  }

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
    #embiggen(it.body)
    #linebreak()
    #linebreak()
  ]

  // title page
  align(
    horizon + center,
    [
      #set text(weight: "bold", size: 14pt)
      #set par(justify: false)
      #embiggen([
        #title

        #linebreak()
        #linebreak()
        #linebreak()

        by

        #linebreak()
        #linebreak()
        #linebreak()

        #author
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
    #embiggen("Chapter " + stringify(counter(heading).display()))
    #linebreak()
    #embiggen(it.body)
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
    #embiggen(it.body)
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
