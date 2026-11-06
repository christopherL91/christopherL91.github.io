// The CV's PDF. The content is in data/cv.yaml.

#import "@preview/basic-resume:0.2.10": *

#let cv = yaml("/data/cv.yaml")

// Only locations that differ from the header's.
#let place(l) = if l == cv.location { "" } else { l }

// **bold** to strong text. Splitting, not eval, keeps # and $ literal;
// apostrophes are curled as on the web.
#let rich(s) = {
  s
    .replace("'", "’")
    .split("**")
    .enumerate()
    .map(((i, part)) => if calc.odd(i) { strong(part) } else { part })
    .join()
}

#let bullets(items) = list(..items.map(rich))

// Never break inside a header link.
#show link: box

#show: resume.with(
  author: cv.name,
  location: cv.location,
  email: cv.email,
  github: cv.github,
  linkedin: cv.linkedin,
  personal-site: cv.website,
  phone: cv.phone,
  font: "New Computer Modern",
  paper: "a4",
  author-position: left,
  personal-info-position: left,
)

== Summary

#rich(cv.summary)

== Skills

#list(..cv.skills.map(s => [*#s.category*: #s.items]))

== Work Experience

// Keep each role on one page.
#for job in cv.work [
  #block(breakable: false)[
    #work(
      title: job.title,
      location: place(job.location),
      company: job.company,
      dates: dates-helper(start-date: job.start, end-date: job.end),
    )
    #bullets(job.highlights)
  ]

]

== Personal Projects

// Only the summary; no line break before " — ".
#for p in cv.projects [
  #project(name: p.name.replace(" — ", "\u{a0}— "))
  #bullets(p.highlights.slice(0, 1))

]

== Education

#for e in cv.education [
  #edu(
    institution: e.institution,
    location: place(e.location),
    dates: e.dates,
    degree: e.degree,
    consistent: true,
  )
  #bullets(e.at("highlights", default: ()))

]
