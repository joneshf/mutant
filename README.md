mutant
======

[![Build Status](https://secure.travis-ci.org/mbj/mutant.png?branch=master)](http://travis-ci.org/mbj/mutant)
[![Dependency Status](https://gemnasium.com/mbj/mutant.png)](https://gemnasium.com/mbj/mutant)
[![Code Climate](https://codeclimate.com/github/mbj/mutant.png)](https://codeclimate.com/github/mbj/mutant)
[![Inline docs](http://inch-ci.org/github/mbj/mutant.png)](http://inch-ci.org/github/mbj/mutant)
[![Gem Version](https://img.shields.io/gem/v/mutant.svg)](https://rubygems.org/gems/mutant)
[![Flattr](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/thing/1823010/mbjmutant-on-GitHub)

Mutant is a mutation testing tool for Ruby.

The idea is that if code can be changed and your tests do not notice, either that code isn't being covered
or it does not have a speced side effect.

Mutant supports MRI and RBX 2.0 and 2.1, while support for JRuby is planned.
It should also work under any Ruby engine that supports POSIX-fork(2) semantics.

Mutant uses a pure Ruby [parser](https://github.com/whitequark/parser) and an [unparser](https://github.com/mbj/unparser)
to do its magic.

Mutant does not have really good "getting started" documentation currently so please refer to presentations and blog posts below.

Mutation-Operators:
-------------------

Mutant supports a wide range of mutation operators. An exhaustive list can be found in the [mutant-meta](https://github.com/mbj/mutant/tree/master/meta).
The `mutant-meta` is arranged to the AST-Node-Types of parser. Refer to parsers [AST documentation](https://github.com/whitequark/parser/blob/master/doc/AST_FORMAT.md) in doubt.

There is no easy and universal way to count the number of mutation operators a tool supports.

Presentations
-------------

There are some presentations about mutant in the wild:

* [RailsConf 2014](http://railsconf.com/) / http://confreaks.com/videos/3333-railsconf-mutation-testing-with-mutant
* [Wrocloverb 2014](http://wrocloverb.com/) / https://www.youtube.com/watch?v=rz-lFKEioLk
* [eurucamp 2013](http://2013.eurucamp.org/) / FrOSCon-2013 http://slid.es/markusschirp/mutation-testing
* [Cologne.rb](http://www.colognerb.de/topics/mutation-testing-mit-mutant) / https://github.com/DonSchado/colognerb-on-mutant/blob/master/mutation_testing_slides.pdf

Blog-Posts
----------

* http://www.sitepoint.com/mutation-testing-mutant/
* http://solnic.eu/2013/01/23/mutation-testing-with-mutant.html

Installation
------------

Install the gem `mutant` via your preferred method.

```ruby
gem install mutant
```

If you plan to use the RSpec integration you'll have to install `mutant-rspec` also.
Please add an explicit dependency to `rspec-core` for the RSpec version you want to use.

```ruby
gem install mutant-rspec
```

The minitest integration is still in the works.

The Crash / Stuck Problem (MRI)
-------------------------------

Mutations generated by mutant can cause MRI to enter VM states its not prepared for.
All MRI versions > 1.9 and < 2.2.1 are affected by this depending on your compiler flags,
compiler version, and OS scheduling behavior.

This can have the following unintended effects:

* MRI crashes with a segfault. Mutant kills each mutation in a dedicated fork to isolate
  the mutations side effects when this fork terminates abnormally (segfault) mutant
  counts the mutation as killed.

* MRI crashes with a segfault and gets stuck when handling the segfault.
  Depending on the number of active kill jobs mutant might appear to continue normally until
  all workers are stuck into this state when it begins to hang.
  Currently mutant must assume that your test suite simply not terminated yet as from the outside
  (parent process) the difference between a long running test and a stuck MRI is not observable.
  Its planned to implement a timeout enforced from the parent process, but ideally MRI simply gets fixed.

References:

* [MRI fix](https://github.com/ruby/ruby/commit/8fe95fea9d238a6deb70c8953ceb3a28a67f4636)
* [MRI backport to 2.2.1](https://github.com/ruby/ruby/commit/8fe95fea9d238a6deb70c8953ceb3a28a67f4636)
* [Mutant issue](https://github.com/mbj/mutant/issues/265)
* [Upstream bug redmine](https://bugs.ruby-lang.org/issues/10460)
* [Upstream bug github](https://github.com/ruby/ruby/pull/822)

Examples
--------

```
cd virtus
# Run mutant on virtus namespace
mutant --include lib --require virtus --use rspec Virtus*
# Run mutant on specific virtus class
mutant --include lib --require virtus --use rspec Virtus::Attribute
# Run mutant on specific virtus class method
mutant --include lib --require virtus --use rspec Virtus::Attribute.build
# Run mutant on specific virtus instance method
mutant --include lib --require virtus --use rspec Virtus::Attribute#type
```

Subjects
--------

Mutant currently mutates code in instance and singleton methods. It is planned to support mutation
of constant definitions and domain specific languages, DSL probably as plugins.

Test-Selection
--------------

Mutation testing is slow. The key to making it fast is selecting the correct set of tests to run.
Mutant currently supports the following built-in strategy for selecting tests/specs:

Mutant uses the "longest rspec example group descriptions prefix match" to select the tests to run.

Example for a subject like `Foo::Bar#baz` it will run all example groups with description prefixes in
`Foo::Bar#baz`, `Foo::Bar` and `Foo`. The order is important, so if mutant finds example groups in the
current prefix level, these example groups *must* kill the mutation.

Rails
-------

Assuming you are using rspec, you can mutation test Rails models by adding the following lines to your Gemfile:

```ruby
group :test do
  gem 'mutant'
  gem 'mutant-rspec'
end
```

Next, run bundle and comment out ```require 'rspec/autorun'``` from your spec_helper.rb file.  Having done so you should be able to use commands like the following:

```sh
RAILS_ENV=test bundle exec mutant -r ./config/environment --use rspec User
```

Support
-------

I'm very happy to receive/answer feedback/questions and criticism.

Your options:

* [GitHub Issues](https://github.com/mbj/mutant/issues)
* Ping me on [twitter](https://twitter.com/_m_b_j_)

There is also the [#mutant](http://irclog.whitequark.org/mutant) channel on freenode.
As my OSS time budged is very limited I cannot join it often. Please prefer to use GitHub issues with
a 'Question: ' prefix in title.

Credits
-------

* [Markus Schirp (mbj)](https://github.com/mbj)
* A gist, now removed, from [dkubb](https://github.com/dkubb) showing ideas.
* Older abandoned [mutant](https://github.com/txus/mutant). For motivating me doing this one.
* [heckle](https://github.com/seattlerb/heckle). For getting me into mutation testing.

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

See LICENSE file.
