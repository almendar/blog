---
layout: post
title:  "Type lambda"
date:   2017-03-23 13:34:34 +0100
categories: scala fp
---

## An accidental feature of Scala

```scala
({ type T[A] = K[A, B] })#T
```

Type lambda is one of those features of Scala language that allowed to unleash a
lot of power in the language, yet it's ugly and makes code a lot harder to read.
The most funny things is that from what I know it is completely accidental
that it was possible to have that feature.
It's a result of crafting together a bunch of language features together in a
very clever way rather than an upfront plan.

## Why it's called a lambda?

Reason why it's called "a lambda" comes of course from the meaning of lambda
used on the value level.
Here it is exactly the same but we operate on a type level. Let's try to see the
similarities.
