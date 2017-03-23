---
layout: post
title:  "Type lambda"
date:   2017-03-20 13:34:34 +0100
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

### Value level

```scala
def foo(a: Int)       : Int        = ???
def bar(a: Int)       : Int => Int = ???
def cow(a: Int => Int): Int        = ???
```

Let's look at the signature of three functions `foo`, `bar` and `cow`.
`foo` is a regular function that every programmer wrote millions of times.
Takes an `int` and returns an `int`. Argument and result are **values**.
Now if we look at `bar` then we see that argument is also an `int` (value) but
the returned type is not a regular value. It's another function or lambda or
whatever we call it.
What is important here is that we sort a like manipulate time. Somewhere else in
our program an `int` will be produced thanks to `bar`, but first someone else
will need to provide what `bar` returned with another `int`. So we let someone
else provide us with a value, at different place than `bar` was called to
produce another value. In somehow similar spirit `cow` function also allows us
to warp time. Someone could write the `a` function somewhere, before the `cow`
function was called, taking for granted that someone will provide it with an
`int`.

Now what if we would like to use `cow` function, but the only function we have
and can pass to it as argument is something with signature like this
`(Int, Int) => Int`? What then? We need to get rid of one of the arguments by
hardcoding a value.

```scala
scala> val Add = (_:Int) + (_:Int)
AddTwo: (Int, Int) => Int = $$Lambda$1127/1099248281@60d40ff4

scala> val AddThree = Add(3, (_:Int))
AddThree: Int => Int = $$Lambda$1128/1623670360@5984feef
```

`AddThree` has the proper number of arguments.


### Type level
What is interesting is the idea that we can do something very similiar on types.
If you have a regular java mindset, when you see `List[A]` you'll probably think
about generics and the fact that list can hold values of different type in its
nodes. A somehow different and a very unorthodox view of `List[A]` is that it is
a function that can take an argument that is a **type**(!!!) and will produce
another **type**. So we see generics as a form of function where the expected
arguments and what is returned are types.

It will probably be more obvious to see the "function" nature of generics if we
use the type alias:

```scala
type Foo[X] = List[X]
```


Now it looks more like a function. We need to pass `X` (e.g. `int`) to `Foo` and
we'll get `List[Int]`. To make it clearer we can also write something like this
which is perfectly fine:

```scala
type Id[X] = X
```

What is important to understand is that a generic type with already filled type
hole is on par with a regular type. E.g. List[Int] and String are on the same
"level". And by level I mean, that they are both specific, and there is no
delay in time, both don't take arguments, opposite to the example with `bar`.


I think the correspondence between the "value level `Foo`" and the "type level
`Foo`" should be apparent now. Not hard to guess that it is also possible to do
the same thing for `bar` and `cow` on type level. It's not that obvious
unfortunately. Let's try to do this nonetheless.

If we want to mimic `bar` on type level we need to return something that is a
type level function. As we already said it is perfectly fine to perceive
generics as functions. So what we need is to return a generic but without yet
filled hole.

```scala
type Bar[F[_]] = F
```

Unfortunately this won't compile, as in Scala types are not values and cannot be
passed around. We can however use them when declaring traits and methods.

```scala
 trait Bar[F[_]]
```

Notice how `Bar` expects to get some type that also expect to get some type.

Now if we would try to create `Bar` instance directly:

```scala
scala> new Bar {}
<console>:13: error: trait Bar takes type parameters
       new Bar {}
```

now compare this with:

```scala
scala> bar()
<console>:13: error: not enough arguments for method bar: (a: Int)Int => Int.
Unspecified value parameter a.
       bar()
```

so let's provide bar with "type parameters":

```scala
scala> new Bar[List] {}
res7: Bar[List] = $anon$1@4ec0229c
```

Notice that we passed into `Bar` a `List`. Not `List[Int]` or `List[A]`.
We passed in a generic, that will have it's type hole filled later.
