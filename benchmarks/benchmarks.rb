require 'bundler'
Bundler.require
require 'benchmark'
require 'haml'
require 'tilt-jadeite'

class Scope

  def foo(what)
    "Foo says #{what}"
  end

  def play(artist, song)
    "Play #{song} from #{artist}"
  end

  def say_hello
    "Hello to you!"
  end

  def fruity_song
    "banana-na-na-na-na-na"
  end

  def development
    true
  end
end

proxied = Scope.new

data = {
  :foo => proc { |what|
    proxied.send(:foo, what)
  },

  :play => proc { |artist, song|
    proxied.send(:play, artist, song)
  },

  :say_hello => "Hello World",
  :fruity_song => proxied.fruity_song,
  :development => proxied.development
}

FILES = %w(simple.jade template.jade template.haml template.erb large.jade large.haml large.erb)

def measure(times, title, &blk)
  puts
  puts "=== #{title} - #{times} times each"
  FILES.each do |f|
    puts "=> #{f}"
    blk.call(times, f, Tilt[f])
    puts
  end
end

measure 1000, "Initialize + render" do |times, file, template_class|
  puts Benchmark.measure {
    times.times do
      scope = Scope.new
      template = template_class.new(file)
      template.render(scope, data)
    end
  }
end

measure 1000, "Render only" do |times, file, template_class|
  template = template_class.new(file)
  puts Benchmark.measure {
    scope = Scope.new
    times.times { template.render(scope, data) }
  }
end
