RDFize: Set Your Data Free
==========================

RDFize is a [Ruby][]-based command-line tool for converting various data
formats and data sources into [RDF][] data.

Examples
--------

    $ rdfize [options] files...

Documentation
-------------

* <http://rdfize.rubyforge.org/>

Dependencies
------------

* [Ruby](http://ruby-lang.org/) (>= 1.9.2)
* [RDF.rb](http://rubygems.org/gems/rdf) (>= 0.3.0)
* [RDF::Raptor](http://rubygems.org/gems/rdf-raptor) (>= 0.3.0) and
  [libraptor](http://librdf.org/raptor/) (>= 2.0)
* [Curb](http://rubygems.org/gems/curb) (>= 0.7.15) and
  [libcurl](http://curl.haxx.se/libcurl/) (>= 7.21)

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of RDFize, do:

    $ [sudo] gem install rdfize

Download
--------

To get a local working copy of the development repository, do:

    $ git clone git://rubyforge.org/rdfize.git

Mailing List
------------

* <http://groups.google.com/group/rdfize>

Resources
---------

* <http://rdfize.rubyforge.org/>
* <http://github.com/datagraph/rdfize>
* <http://rubygems.org/gems/rdfize>
* <http://rubyforge.org/projects/rdfize/>
* <http://raa.ruby-lang.org/project/rdfize/>

Authors
-------

RDFcache is a [Datagraph][] technology.

* [Arto Bendiken](http://github.com/bendiken) - <http://ar.to/>
* [Josh Huckabee](http://github.com/jhuckabee) - <http://joshhuckabee.com/>

Contributors
------------

Refer to the accompanying {file:CREDITS} file.

Contributing
------------

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for guidance.
* Don't touch the `.gemspec`, `VERSION`, or `AUTHORS` files.
  If you need to change them, do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the corresponding
  list in the `README`. Alphabetical order applies.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you.

License
-------

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[Datagraph]:  http://datagraph.org/
[RDF]:        http://www.w3.org/RDF/
[RDF.rb]:     http://rdf.rubyforge.org/
[Ruby]:       http://ruby-lang.org/
[YARD]:       http://yardoc.org/
[YARD-GS]:    http://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:        http://unlicense.org/#unlicensing-contributions
