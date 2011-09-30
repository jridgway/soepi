require 'test_helper'

class BlahTest < ActionMailer::TestCase
  test "yah" do
    mail = Blah.yah
    assert_equal "Yah", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
