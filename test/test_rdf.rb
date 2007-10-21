require 'rdf'

class TestRDF < Test::Unit::TestCase
  include RDF

  def test_namespace_registration
    Namespace.register! :eg, 'http://example.org/test#'
    assert Namespace.prefixes.has_key?(:eg)

    assert_equal Namespace.prefixes[:eg], 'http://example.org/test#'

    Namespace.unregister! :eg
    assert !Namespace.prefixes.has_key?(:eg)
  end

  def test_namespace_predicates
    Namespace.register! :eg, 'http://example.org/test#'
    eg = Namespace[:eg]

    assert_kind_of Resource, eg['arbitrary']
    assert_equal eg['name'].uri, 'http://example.org/test#name'
    assert_equal eg.name.uri, 'http://example.org/test#name'
    assert_equal eg.compound_name.uri, 'http://example.org/test#compound-name'
  end

end
