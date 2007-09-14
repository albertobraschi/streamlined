require File.join(File.dirname(__FILE__), '../../../test_helper')
require 'streamlined/controller/options_methods'

class Streamlined::Controller::OptionsMethodsTest < Test::Unit::TestCase
  include Streamlined::Controller::OptionsMethods
  
  def test_merge_count_or_find_options
    mock_count_or_find_options(:conditions => "foo=1")
    merge_count_or_find_options(options = {})
    assert_equal({ :conditions => "foo=1" }, options)
  end
  
  def test_merge_count_or_find_options_with_merge_set_to_true
    mock_count_or_find_options(:conditions => "foo=1", :merge => true)
    merge_count_or_find_options(options = { :conditions => "bar=2 OR bat=3" })
    assert_equal({ :conditions => "(bar=2 OR bat=3) AND foo=1" }, options)
  end
  
  def test_merge_count_or_find_options_with_empty_conditions_and_merge_set_to_true
    mock_count_or_find_options(:conditions => "foo=1", :merge => true)
    merge_count_or_find_options(options = {})
    assert_equal({ :conditions => "foo=1" }, options)
  end
  
  def test_count_or_find_options_with_empty_hash
    mock_count_or_find_options({})
    assert_equal({}, count_or_find_options)
  end
  
  def test_count_or_find_options_with_strings
    mock_count_or_find_options(:conditions => "foo=1")
    assert_equal({:conditions => "foo=1"}, count_or_find_options)
  end
  
  def test_count_or_find_options_with_method_symbols
    mock_count_or_find_options(:conditions => :foo_method)
    flexmock(self).should_receive(:foo_method => "foo=1").once
    assert_equal({:conditions => "foo=1"}, count_or_find_options)
  end
  
  private
  def mock_count_or_find_options(options)
    flexmock(self.class).should_receive(:count_or_find_options => options).once
  end
end