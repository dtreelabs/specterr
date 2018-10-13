class TestController < ApplicationController
  def index
    raise Exception.new "Test Exception"
  end

  def list
  end
end
