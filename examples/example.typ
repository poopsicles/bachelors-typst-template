#import "../bach.typ": *

#show: content => bach(
  title: "On instant noodles",
  author: "Fumnanya",
  matric: "30XX123456",
  supervisor: "Dr. Supervisor",
  date: datetime(year: 2024, month: 4, day: 1),
  abstract: [
    We attempt to make the perfect bowl of noodles.
  ],
  dedication: [
    To all who have fallen during the climb.
  ],
  acknowledgements: [
    No one else had a hand in this.
  ],
  content,
)

= Introduction

We begin, as all things should, with a word salad @word-salad.

#lorem(100)

#table-figure(
  "a table?", 
  table(
    columns: 2,
    table.header[Amount][Ingredient],
    [360g], [Baking flour],
  )
)

#code-figure(
  "International Scheme code in Bosnian", 
  ```scm
  (definiši (zdravo-svjete)
    (prikaži "Zdravo, Svjete!"))
  ```
)

