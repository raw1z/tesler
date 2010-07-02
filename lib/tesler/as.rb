module Kernel

  # Stolen from Facets. Allows one two execute a specific ancestor's method
  def as(ancestor, &blk)
    @__as ||= {}
    unless r = @__as[ancestor]
      r = (@__as[ancestor] = As.new(self, ancestor))
    end
    r.instance_eval(&blk) if block_given?
    r
  end
end

class As < BasicObject #:nodoc:
  def initialize(subject, ancestor)
    @subject = subject
    @ancestor = ancestor
  end

  def method_missing(sym, *args, &blk)
    @ancestor.instance_method(sym).bind(@subject).call(*args,&blk)
  end
end
